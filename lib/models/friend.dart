import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'friend.freezed.dart';
part 'friend.g.dart';

@freezed
class Friend with _$Friend {
  const factory Friend({
    required String id,
    required String displayName,
    String? bio,
    List<String>? bioLinks,
    String? currentAvatarImageUrl,
    String? currentAvatarThumbnailImageUrl,
    List<String>? currentAvatarTags,
    String? developerType,
    String? friendKey,
    @Default(true) bool isFriend,
    String? imageUrl,
    @JsonKey(name: 'last_platform') String? lastPlatform,
    String? location,
    @JsonKey(name: 'last_login') DateTime? lastLogin,
    @JsonKey(name: 'last_activity') DateTime? lastActivity,
    @JsonKey(name: 'last_mobile') DateTime? lastMobile,
    String? platform,
    String? profilePicOverride,
    String? profilePicOverrideThumbnail,
    String? status,
    String? statusDescription,
    List<String>? tags,
    String? userIcon,
    // 계산된 필드들
    @Default(false) bool isOnline,
    String? instanceId,
    String? worldId,
    String? travelingToLocation,
    @Default(false) bool canRequestInvite,
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
