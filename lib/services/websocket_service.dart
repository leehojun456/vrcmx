import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:get/get.dart';

import '../controllers/friends_controller.dart';
// import '../models/notification.dart';
import 'auth_service.dart';
import 'package:vrcmx/constants/app_info.dart';

class WebSocketService {
  Timer? _connectionMonitorTimer;
  final Duration _connectionMonitorInterval = const Duration(seconds: 10);
  static const String wsUrl = 'wss://pipeline.vrchat.cloud/';

  final AuthService _authService;
  WebSocket? _webSocket;
  StreamSubscription? _subscription;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  // 재연결: 지수 백오프 + 지터 (HTTP 폴링 금지)
  final Duration _reconnectBaseDelay = const Duration(seconds: 2);
  final Duration _reconnectMaxDelay = const Duration(minutes: 1);
  // bool _manuallyClosed = false; // 수동 연결 해제 상태 제거

  WebSocketService(this._authService);

  void _startConnectionMonitor() {
    print('[DEBUG] 연결 상태 모니터링 타이머 시작');
    _connectionMonitorTimer?.cancel();
    _connectionMonitorTimer = Timer.periodic(_connectionMonitorInterval, (
      timer,
    ) {
      print('[DEBUG] 연결 상태 체크: isConnected=$_isConnected');
      if (!_isConnected) {
        print('[DEBUG] 연결 끊김 감지 → 재연결 시도');
        connect();
      }
    });
  }

  void _stopConnectionMonitor() {
    print('[DEBUG] 연결 상태 모니터링 타이머 중지');
    _connectionMonitorTimer?.cancel();
    _connectionMonitorTimer = null;
  }

  /// 웹소켓 실시간 연결 시작
  Future<bool> connect() async {
    print('[DEBUG] connect() 호출됨');
    try {
      // _manuallyClosed = false; // 수동 연결 해제 상태 제거
      await _authService.loadSavedCookie();

      if (_authService.authCookie == null || _authService.authCookie!.isEmpty) {
        print('❌ 웹소켓 연결 실패: 인증 쿠키가 없음');
        return false;
      }

      // 기존 연결이 있으면 중지
      await disconnect();
      _startConnectionMonitor();

      print('🔄 웹소켓 연결 시도 중...');
      print('🍪 사용할 쿠키: ${_authService.authCookie}');

      // 웹소켓 연결 전에 친구 목록 먼저 로드
      print('📋 초기 친구 목록 로드 중...');

      // 공식 문서에 따른 authToken 쿼리 파라미터 방식
      // 쿠키가 이미 authcookie_로 시작하는지 확인
      String authToken = _authService.authCookie!;
      if (!authToken.startsWith('authcookie_')) {
        authToken = 'authcookie_$authToken';
      }

      // URI 파싱 문제 해결 - 수동으로 URI 구성
      final uri = Uri(
        scheme: 'wss',
        host: 'pipeline.vrchat.cloud',
        path: '/',
        queryParameters: {'authToken': authToken},
      );
      print('🌐 연결 URL: $uri');
      print('🔑 사용할 authToken: $authToken');
      print('🔍 최종 URI: $uri');

      // HttpClient로 수동 웹소켓 핸드셰이크
      final httpClient = HttpClient();

      // WebSocket key 생성
      final random = Random();
      final keyBytes = Uint8List(16);
      for (int i = 0; i < 16; i++) {
        keyBytes[i] = random.nextInt(256);
      }
      final webSocketKey = base64.encode(keyBytes);

      print('🔑 WebSocket Key: $webSocketKey');

      final request = await httpClient.getUrl(
        Uri.parse('https://pipeline.vrchat.cloud/?authToken=$authToken'),
      );
      request.headers.set('Connection', 'Upgrade');
      request.headers.set('Upgrade', 'websocket');
      request.headers.set('Sec-WebSocket-Version', '13');
      request.headers.set('Sec-WebSocket-Key', webSocketKey);
      request.headers.set('User-Agent', AppInfo.userAgent);
      request.headers.set('Origin', 'https://vrchat.com');

      final response = await request.close();

      print('🌐 수동 핸드셰이크 응답 상태: ${response.statusCode}');
      print('📋 수동 핸드셰이크 헤더: ${response.headers}');

      if (response.statusCode == 101) {
        // 성공! 소켓을 WebSocket으로 변환
        final socket = await response.detachSocket();
        _webSocket = WebSocket.fromUpgradedSocket(socket, serverSide: false);
        // 핑으로 유휴 연결 상태 감지 (응답 없으면 연결 종료됨)
        _webSocket!.pingInterval = const Duration(seconds: 20);

        print('✅ 수동 웹소켓 연결 성공!');
        _isConnected = true;
        _reconnectAttempts = 0;
        _notifyConnection(true);

        // 웹소켓 재연결 시 친구 리스트 새로고침 (쿨다운 무시)
        _refreshFriendsOnReconnection();
      } else {
        print('❌ 수동 핸드셰이크 실패: ${response.statusCode}');
        throw Exception('WebSocket upgrade failed: ${response.statusCode}');
      }

      // 연결 확인을 위한 타임아웃
      final connectionTimeout = Timer(const Duration(seconds: 10), () {
        if (!_isConnected) {
          print('❌ 웹소켓 연결 타임아웃 - 재연결 시도 예정');
          _onError('Connection timeout');
        }
      });

      // 메시지 스트림 구독
      _subscription = _webSocket!.listen(
        (message) {
          connectionTimeout.cancel();
          _onMessage(message);
        },
        onError: (error) {
          connectionTimeout.cancel();
          _onError(error);
        },
        onDone: () {
          connectionTimeout.cancel();
          _onDisconnected();
        },
      );

      return true;
    } catch (e) {
      print('❌ 웹소켓 연결 오류: $e');
      _isConnected = false;
      _notifyConnection(false);
      _scheduleReconnect();
      return false;
    }
  }

  /// 웹소켓 연결 해제
  Future<void> disconnect() async {
    print('[DEBUG] disconnect() 호출됨');
    print('🔌 웹소켓 연결 해제');
    // _manuallyClosed = true; // 수동 연결 해제 상태 제거

    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    _stopConnectionMonitor();

    await _subscription?.cancel();
    _subscription = null;

    await _webSocket?.close();
    _webSocket = null;

    _isConnected = false;
  }

  /// 메시지 수신 처리
  void _onMessage(dynamic message) {
    print('[DEBUG] _onMessage() 호출됨');
    try {
      print('📨 웹소켓 메시지 수신: $message');

      final Map<String, dynamic> data = jsonDecode(message);
      final messageType = data['type'] as String?;

      if (messageType == null) return;

      switch (messageType) {
        case 'friend-offline':
          {
            final contentStr = data['content'] as String?;
            if (contentStr != null) {
              final content = jsonDecode(contentStr);
              final id =
                  content['userId'] ?? content['userid'] ?? content['id'];
              final lastPlatform = content['platform'] as String?;
              try {
                Get.find<FriendsController>().updateFriendInfo(
                  id: id,
                  lastPlatform: lastPlatform,
                  status: 'offline',
                );
              } catch (e) {
                print('친구 정보 갱신 오류: $e');
              }
            }
            break;
          }
        case 'friend-online':
        case 'friend-active':
        case 'friend-location':
        case 'friend-update':
          {
            final contentStr = data['content'] as String?;
            if (contentStr != null) {
              final content = jsonDecode(contentStr);
              final id =
                  content['userId'] ?? content['userid'] ?? content['id'];
              // user object가 있으면 더 많은 정보 갱신
              final userObj = content['user'] as Map<String, dynamic>?;
              String? status;
              String? statusDescription;
              String? location;
              String? lastPlatform;
              List<String>? tags;
              if (userObj != null) {
                status = userObj['status'] as String?;
                statusDescription = userObj['statusDescription'] as String?;
                location =
                    userObj['location'] as String? ??
                    content['location'] as String?;
                lastPlatform =
                    userObj['last_platform'] as String? ??
                    userObj['lastPlatform'] as String? ??
                    content['platform'] as String?;
                final tagsRaw = userObj['tags'] ?? content['tags'];
                if (tagsRaw is List) {
                  tags = tagsRaw.whereType<String>().toList();
                }
              } else {
                location = content['location'] as String?;
                status = content['status'] as String?;
                statusDescription = content['statusDescription'] as String?;
                lastPlatform =
                    content['last_platform'] as String? ??
                    content['lastPlatform'] as String? ??
                    content['platform'] as String?;
                final tagsRaw = content['tags'];
                if (tagsRaw is List) {
                  tags = tagsRaw.whereType<String>().toList();
                }
              }
              try {
                Get.find<FriendsController>().updateFriendInfo(
                  id: id,
                  location: location,
                  status: status,
                  statusDescription: statusDescription,
                  lastPlatform: lastPlatform,
                  tags: tags,
                );
              } catch (e) {
                print('친구 정보 갱신 오류: $e');
              }
            }
            break;
          }
        case 'friend-delete':
          {
            final contentStr = data['content'] as String?;
            if (contentStr != null) {
              final content = jsonDecode(contentStr);
              final id =
                  content['userId'] ?? content['userid'] ?? content['id'];
              try {
                // 친구 삭제: friends 리스트에서 제거
                final controller = Get.find<FriendsController>();
                controller.friends.removeWhere((f) => f.id == id);
              } catch (e) {
                print('친구 삭제 오류: $e');
              }
            }
            break;
          }
        case 'user-location':
          _handleUserLocationMessage(data);
          break;
        case 'user-update':
          {
            final contentStr = data['content'] as String?;
            if (contentStr != null) {
              final content = jsonDecode(contentStr);
              final id =
                  content['userId'] ?? content['userid'] ?? content['id'];
              final userObj = content['user'] as Map<String, dynamic>?;
              // Removed unused variables: displayName, bio, currentAvatarImageUrl, currentAvatarThumbnailImageUrl
              String? status;
              String? statusDescription;
              String? location;
              String? lastPlatform;
              List<String>? tags;
              if (userObj != null) {
                // Removed assignments to undefined variables: displayName, bio, currentAvatarImageUrl, currentAvatarThumbnailImageUrl
                status = userObj['status'] as String?;
                statusDescription = userObj['statusDescription'] as String?;
                location = userObj['location'] as String?;
                lastPlatform =
                    userObj['last_platform'] as String? ??
                    userObj['lastPlatform'] as String?;
                final tagsRaw = userObj['tags'];
                if (tagsRaw is List) {
                  tags = tagsRaw.whereType<String>().toList();
                }
              }
              try {
                Get.find<FriendsController>().updateFriendInfo(
                  id: id,
                  location: location,
                  status: status,
                  statusDescription: statusDescription,
                  lastPlatform: lastPlatform,
                  tags: tags,
                );
              } catch (e) {
                print('유저 정보 갱신 오류: $e');
              }
            }
            break;
          }
        default:
          print('🔍 알 수 없는 메시지 타입: $messageType');
          break;
      }
    } catch (e) {
      print('❌ 메시지 처리 오류: $e');
    }
  }

  /// 사용자 위치 메시지 처리
  void _handleUserLocationMessage(Map<String, dynamic> data) {
    try {
      final contentStr = data['content'] as String?;
      if (contentStr == null) return;

      final Map<String, dynamic> content = jsonDecode(contentStr);
      print('📍 사용자 위치 업데이트: ${content['location']}');
    } catch (e) {
      print('❌ 사용자 위치 메시지 처리 오류: $e');
    }
  }

  /// 연결 오류 처리
  void _onError(error) {
    print('[DEBUG] _onError() 호출됨');
    print('❌ 웹소켓 오류: $error');
    _isConnected = false;
    _notifyConnection(false);
    _scheduleReconnect();
  }

  /// 연결 종료 처리
  void _onDisconnected() {
    print('[DEBUG] _onDisconnected() 호출됨');
    print('🔌 웹소켓 연결 종료됨');
    _isConnected = false;
    _notifyConnection(false);
    _scheduleReconnect();
  }

  /// 재연결 스케줄링
  void _scheduleReconnect() {
    print('[DEBUG] _scheduleReconnect() 호출됨');
    // 항상 재연결 시도 (수동 연결 해제 상태 제거)

    _reconnectAttempts++;
    // 지수 백오프 계산 (최대 _reconnectMaxDelay), 0~30% 지터 추가
    final baseMs = _reconnectBaseDelay.inMilliseconds;
    final capMs = _reconnectMaxDelay.inMilliseconds;
    final exp = 1 << (_reconnectAttempts - 1);
    var waitMs = baseMs * exp;
    if (waitMs > capMs) waitMs = capMs;
    final jitter = (waitMs * (Random().nextDouble() * 0.3)).toInt();
    final delay = Duration(milliseconds: waitMs + jitter);

    print('🔄 재연결 예약: ${delay.inSeconds}s 후 (시도: $_reconnectAttempts)');

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () async {
      await connect();
    });
  }

  /// 수동 재연결
  Future<bool> reconnect() async {
    _reconnectAttempts = 0;
    return await connect();
  }

  void dispose() {
    _stopConnectionMonitor();
    disconnect();
  }

  void _notifyConnection(bool value) {
    try {
      Get.find<FriendsController>().isConnected.value = value;
    } catch (_) {}
  }

  /// 웹소켓 재연결 시 친구 리스트 새로고침 (쿨다운 무시)
  void _refreshFriendsOnReconnection() {
    try {
      final friendsController = Get.find<FriendsController>();
      // 웹소켓 재연결 시에는 쿨다운을 무시하고 친구 리스트 새로고침
      friendsController.refreshFriendsForReconnection();
    } catch (e) {
      print('웹소켓 재연결 시 친구 리스트 새로고침 실패: $e');
    }
  }
}
