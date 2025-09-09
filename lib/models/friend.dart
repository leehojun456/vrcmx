import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend.freezed.dart';
part 'friend.g.dart';

@freezed
class Friend with _$Friend {
  const factory Friend({
    required String id,
    required String username,
    required String displayName,
    String? bio,
    String? currentAvatarImageUrl,
    String? status,
    String? statusDescription,
    String? location, // world 또는 offline, private 등
    String? instanceId,
    String? worldId,
    DateTime? lastLogin,
    String? platform,
    @Default(false) bool isOnline,
    String? developerType,
    List<String>? tags,
    String? friendKey,
    // VRChat API 원본 응답 저장
    Map<String, dynamic>? rawApiResponse,
  }) = _Friend;

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);
}

@freezed
class FriendsListResponse with _$FriendsListResponse {
  const factory FriendsListResponse({
    required bool success,
    String? message,
    @Default([]) List<Friend> friends,
    int? total,
    Map<String, dynamic>? rawApiResponse,
  }) = _FriendsListResponse;

  factory FriendsListResponse.fromJson(Map<String, dynamic> json) => 
      _$FriendsListResponseFromJson(json);
}