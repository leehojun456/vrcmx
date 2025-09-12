import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../services/websocket_service.dart';
import '../models/friend.dart';

class FriendsController extends GetxController {
  final AuthService _auth = Get.find<AuthService>();
  final WebSocketService _ws = Get.find<WebSocketService>();

  final RxList<Friend> friends = <Friend>[].obs;
  final RxBool loading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isConnected = false.obs;

  @override
  void onInit() {
    super.onInit();
    bootstrap();
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
    }
  }

  Future<void> refreshFriends() async {
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
    super.onClose();
  }
}
