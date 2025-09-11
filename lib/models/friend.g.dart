// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FriendImpl _$$FriendImplFromJson(Map<String, dynamic> json) => _$FriendImpl(
  id: json['id'] as String,
  displayName: json['displayName'] as String,
  bio: json['bio'] as String?,
  bioLinks: (json['bioLinks'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  currentAvatarImageUrl: json['currentAvatarImageUrl'] as String?,
  currentAvatarThumbnailImageUrl:
      json['currentAvatarThumbnailImageUrl'] as String?,
  currentAvatarTags: (json['currentAvatarTags'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  developerType: json['developerType'] as String?,
  friendKey: json['friendKey'] as String?,
  isFriend: json['isFriend'] as bool? ?? true,
  imageUrl: json['imageUrl'] as String?,
  lastPlatform: json['last_platform'] as String?,
  location: json['location'] as String?,
  lastLogin: json['last_login'] == null
      ? null
      : DateTime.parse(json['last_login'] as String),
  lastActivity: json['last_activity'] == null
      ? null
      : DateTime.parse(json['last_activity'] as String),
  lastMobile: json['last_mobile'] == null
      ? null
      : DateTime.parse(json['last_mobile'] as String),
  platform: json['platform'] as String?,
  profilePicOverride: json['profilePicOverride'] as String?,
  profilePicOverrideThumbnail: json['profilePicOverrideThumbnail'] as String?,
  status: json['status'] as String?,
  statusDescription: json['statusDescription'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  userIcon: json['userIcon'] as String?,
  isOnline: json['isOnline'] as bool? ?? false,
  instanceId: json['instanceId'] as String?,
  worldId: json['worldId'] as String?,
  travelingToLocation: json['travelingToLocation'] as String?,
  canRequestInvite: json['canRequestInvite'] as bool? ?? false,
  rawApiResponse: json['rawApiResponse'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$FriendImplToJson(_$FriendImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'bio': instance.bio,
      'bioLinks': instance.bioLinks,
      'currentAvatarImageUrl': instance.currentAvatarImageUrl,
      'currentAvatarThumbnailImageUrl': instance.currentAvatarThumbnailImageUrl,
      'currentAvatarTags': instance.currentAvatarTags,
      'developerType': instance.developerType,
      'friendKey': instance.friendKey,
      'isFriend': instance.isFriend,
      'imageUrl': instance.imageUrl,
      'last_platform': instance.lastPlatform,
      'location': instance.location,
      'last_login': instance.lastLogin?.toIso8601String(),
      'last_activity': instance.lastActivity?.toIso8601String(),
      'last_mobile': instance.lastMobile?.toIso8601String(),
      'platform': instance.platform,
      'profilePicOverride': instance.profilePicOverride,
      'profilePicOverrideThumbnail': instance.profilePicOverrideThumbnail,
      'status': instance.status,
      'statusDescription': instance.statusDescription,
      'tags': instance.tags,
      'userIcon': instance.userIcon,
      'isOnline': instance.isOnline,
      'instanceId': instance.instanceId,
      'worldId': instance.worldId,
      'travelingToLocation': instance.travelingToLocation,
      'canRequestInvite': instance.canRequestInvite,
      'rawApiResponse': instance.rawApiResponse,
    };

_$FriendsListResponseImpl _$$FriendsListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$FriendsListResponseImpl(
  success: json['success'] as bool,
  message: json['message'] as String?,
  friends:
      (json['friends'] as List<dynamic>?)
          ?.map((e) => Friend.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  total: (json['total'] as num?)?.toInt(),
  rawApiResponse: json['rawApiResponse'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$FriendsListResponseImplToJson(
  _$FriendsListResponseImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'friends': instance.friends,
  'total': instance.total,
  'rawApiResponse': instance.rawApiResponse,
};
