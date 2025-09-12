import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../services/websocket_service.dart';
import '../models/friend.dart';
import '../controllers/auth_controller.dart';
import '../models/auth_state.dart';
import 'dart:async';

class FriendsController extends GetxController {
  final AuthService _auth = Get.find<AuthService>();
  final WebSocketService _ws = Get.find<WebSocketService>();

  final RxList<Friend> friends = <Friend>[].obs;
  final RxBool loading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isConnected = false.obs;

  // 쿨다운 관리
  DateTime? _lastRefreshTime;
  static const Duration _refreshCooldown = Duration(seconds: 30);
  final RxBool canRefresh = true.obs; // RxBool로 변경
  Timer? _cooldownTimer; // 쿨다운 타이머

  /// 마지막 새로고침으로부터 얼마나 시간이 지났는지 반환
  Duration? get timeSinceLastRefresh {
    if (_lastRefreshTime == null) return null;
    return DateTime.now().difference(_lastRefreshTime!);
  }

  /// 쿨다운이 끝날 때까지 남은 시간 (초)
  int get remainingCooldownSeconds {
    if (_lastRefreshTime == null) return 0;
    final elapsed = DateTime.now().difference(_lastRefreshTime!);
    final remaining = _refreshCooldown - elapsed;
    return remaining.inSeconds > 0 ? remaining.inSeconds : 0;
  }

  /// 쿨다운 타이머 시작
  void _startCooldownTimer() {
    _cooldownTimer?.cancel();
    canRefresh.value = false;

    // 1초마다 쿨다운 상태 체크
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_lastRefreshTime == null) {
        canRefresh.value = true;
        timer.cancel();
        return;
      }

      final elapsed = DateTime.now().difference(_lastRefreshTime!);
      if (elapsed >= _refreshCooldown) {
        canRefresh.value = true;
        timer.cancel();
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    // 인증 상태 확인 후 bootstrap 호출
    final authController = Get.find<AuthController>();

    // 현재 인증 상태가 authenticated인 경우 즉시 bootstrap
    if (authController.state.value.isAuthenticated) {
      bootstrap();
    } else {
      // 인증 상태 변화를 감지하여 authenticated가 되면 bootstrap 호출
      ever(authController.state, (AuthState state) {
        if (state.isAuthenticated) {
          bootstrap();
        }
      });
    }
  }

  Future<void> bootstrap() async {
    loading.value = true;
    errorMessage.value = '';
    try {
      // Connect websocket (single place)
      await _ws.connect();

      // Initial load: online + offline merged (like existing UI)
      final online = await _auth.getAllFriends(includeOffline: false);
      final offline = await _auth.getAllFriends(includeOffline: true);

      if (!online.success || !offline.success) {
        errorMessage.value =
            online.message ?? offline.message ?? 'Failed to load friends';
        friends.clear();
      } else {
        final map = <String, Friend>{};
        for (final f in online.friends) {
          map[f.id] = f;
        }
        for (final f in offline.friends) {
          map[f.id] = f;
        }
        friends.value = map.values.toList();
      }
    } catch (e) {
      errorMessage.value = '네트워크 오류: ${e.toString()}';
      friends.clear();
    } finally {
      loading.value = false;
      _lastRefreshTime = DateTime.now(); // 새로고침 시간 기록
      _startCooldownTimer(); // 쿨다운 타이머 시작
    }
  }

  Future<void> refreshFriends() async {
    // 쿨다운 체크
    if (!canRefresh.value) {
      print('새로고침 쿨다운 중입니다. ${remainingCooldownSeconds}초 후에 다시 시도해주세요.');
      return;
    }

    await _performRefresh();
  }

  /// 웹소켓 재연결 시 쿨다운 무시하고 친구 리스트 새로고침
  Future<void> refreshFriendsForReconnection() async {
    print('웹소켓 재연결로 인한 친구 리스트 새로고침 (쿨다운 무시)');
    await _performRefresh();
  }

  /// 실제 새로고침 로직 (공통 메서드)
  Future<void> _performRefresh() async {
    try {
      loading.value = true;
      final online = await _auth.getAllFriends(includeOffline: false);
      final offline = await _auth.getAllFriends(includeOffline: true);
      if (!online.success || !offline.success) {
        errorMessage.value =
            online.message ?? offline.message ?? 'Failed to refresh friends';
        friends.clear();
        return;
      }
      friends.clear();
      for (final f in online.friends) {
        friends.add(f);
      }
      for (final f in offline.friends) {
        if (!friends.any((x) => x.id == f.id)) {
          friends.add(f);
        }
      }
    } catch (e) {
      friends.clear();
      errorMessage.value = '네트워크 오류: ${e.toString()}';
    } finally {
      loading.value = false;
      _lastRefreshTime = DateTime.now(); // 새로고침 시간 기록
      _startCooldownTimer(); // 쿨다운 타이머 시작
    }
  }

  Future<void> connect() => _ws.connect();

  // 특정 친구 정보만 갱신하는 메서드
  void updateFriendInfo({
    required String id,
    String? location,
    String? status,
    String? statusDescription,
    String? lastPlatform,
    List<String>? tags,
  }) {
    final idx = friends.indexWhere((f) => f.id == id);
    if (idx != -1) {
      final old = friends[idx];
      friends[idx] = Friend(
        id: old.id,
        displayName: old.displayName,
        currentAvatarImageUrl: old.currentAvatarImageUrl,
        currentAvatarThumbnailImageUrl: old.currentAvatarThumbnailImageUrl,
        bio: old.bio,
        status: status ?? old.status,
        statusDescription: statusDescription ?? old.statusDescription,
        location: location ?? old.location,
        lastPlatform: lastPlatform ?? old.lastPlatform,
        lastLogin: old.lastLogin,
        tags: tags ?? old.tags,
      );
    }
  }

  @override
  void onClose() {
    _cooldownTimer?.cancel(); // 타이머 정리
    super.onClose();
  }
}
