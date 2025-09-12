import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/friends_controller.dart';
import '../models/friend.dart';
import '../models/notification.dart';
import 'auth_service.dart';

class WebSocketService {
  static const String wsUrl = 'wss://pipeline.vrchat.cloud/';

  final AuthService _authService;
  WebSocket? _webSocket;
  StreamSubscription? _subscription;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int maxReconnectAttempts = 5;
  static const Duration reconnectDelay = Duration(seconds: 5);

  // 현재 친구 목록 캐시
  List<Friend> _currentFriends = [];

  WebSocketService(this._authService);

  /// 웹소켓 실시간 연결 시작
  Future<bool> connect() async {
    try {
      await _authService.loadSavedCookie();

      if (_authService.authCookie == null || _authService.authCookie!.isEmpty) {
        print('❌ 웹소켓 연결 실패: 인증 쿠키가 없음');
        return false;
      }

      // 기존 연결이 있으면 중지
      await disconnect();

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
      request.headers.set(
        'User-Agent',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0',
      );
      request.headers.set('Origin', 'https://vrchat.com');

      final response = await request.close();

      print('🌐 수동 핸드셰이크 응답 상태: ${response.statusCode}');
      print('📋 수동 핸드셰이크 헤더: ${response.headers}');

      if (response.statusCode == 101) {
        // 성공! 소켓을 WebSocket으로 변환
        final socket = await response.detachSocket();
        _webSocket = WebSocket.fromUpgradedSocket(socket, serverSide: false);

        print('✅ 수동 웹소켓 연결 성공!');
        _isConnected = true;
        _reconnectAttempts = 0;
      } else {
        print('❌ 수동 핸드셰이크 실패: ${response.statusCode}');
        throw Exception('WebSocket upgrade failed: ${response.statusCode}');
      }

      // 연결 확인을 위한 타임아웃
      final connectionTimeout = Timer(const Duration(seconds: 10), () {
        if (!_isConnected) {
          print('❌ 웹소켓 연결 타임아웃 - HTTP 폴링으로 전환');
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
      return false;
    }
  }

  /// 웹소켓 연결 해제
  Future<void> disconnect() async {
    print('🔌 웹소켓 연결 해제');

    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    await _subscription?.cancel();
    _subscription = null;

    await _webSocket?.close();
    _webSocket = null;

    _isConnected = false;
  }

  /// 메시지 수신 처리
  void _onMessage(dynamic message) {
    try {
      print('📨 웹소켓 메시지 수신: $message');

      final Map<String, dynamic> data = jsonDecode(message);
      final messageType = data['type'] as String?;

      if (messageType == null) return;

      switch (messageType) {
        case 'notification':
          break;
        case 'friend-online':
        case 'friend-offline':
        case 'friend-location':
        case 'friend-update':
          {
            // 친구 정보 실시간 갱신
            final contentStr = data['content'] as String?;
            if (contentStr != null) {
              final content = jsonDecode(contentStr);
              final id = content['userId'] ?? content['id'];
              if (id != null) {
                final location = content['location'] as String?;
                final status = content['status'] as String?;
                final statusDescription =
                    content['statusDescription'] as String?;
                final lastPlatform =
                    content['last_platform'] as String? ??
                    content['lastPlatform'] as String?;
                try {
                  Get.find<FriendsController>().updateFriendInfo(
                    id: id,
                    location: location,
                    status: status,
                    statusDescription: statusDescription,
                    lastPlatform: lastPlatform,
                  );
                } catch (e) {
                  print('친구 정보 갱신 오류: $e');
                }
              }
            }
            break;
          }
        case 'user-location':
          _handleUserLocationMessage(data);
          break;
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
    print('❌ 웹소켓 오류: $error');
    _isConnected = false;
    _scheduleReconnect();
  }

  /// 연결 종료 처리
  void _onDisconnected() {
    print('🔌 웹소켓 연결 종료됨');
    _isConnected = false;
    _scheduleReconnect();
  }

  /// 재연결 스케줄링
  void _scheduleReconnect() {
    if (_reconnectAttempts >= maxReconnectAttempts) {
      print('❌ 최대 재연결 시도 횟수 초과');
      return;
    }

    _reconnectAttempts++;
    print(
      '🔄 재연결 시도 $_reconnectAttempts/$maxReconnectAttempts (${reconnectDelay.inSeconds}초 후)',
    );

    _reconnectTimer = Timer(reconnectDelay, () async {
      await connect();
    });
  }

  /// 수동 재연결
  Future<bool> reconnect() async {
    _reconnectAttempts = 0;
    return await connect();
  }

  void dispose() {
    disconnect();
  }
}
