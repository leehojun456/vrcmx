// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FriendImpl _$$FriendImplFromJson(Map<String, dynamic> json) => _$FriendImpl(
  id: json['id'] as String,
  username: json['username'] as String,
  displayName: json['displayName'] as String,
  bio: json['bio'] as String?,
  currentAvatarImageUrl: json['currentAvatarImageUrl'] as String?,
  status: json['status'] as String?,
  statusDescription: json['statusDescription'] as String?,
  location: json['location'] as String?,
  instanceId: json['instanceId'] as String?,
  worldId: json['worldId'] as String?,
  lastLogin: json['lastLogin'] == null
      ? null
      : DateTime.parse(json['lastLogin'] as String),
  platform: json['platform'] as String?,
  isOnline: json['isOnline'] as bool? ?? false,
  developerType: json['developerType'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  friendKey: json['friendKey'] as String?,
  rawApiResponse: json['rawApiResponse'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$FriendImplToJson(_$FriendImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'displayName': instance.displayName,
      'bio': instance.bio,
      'currentAvatarImageUrl': instance.currentAvatarImageUrl,
      'status': instance.status,
      'statusDescription': instance.statusDescription,
      'location': instance.location,
      'instanceId': instance.instanceId,
      'worldId': instance.worldId,
      'lastLogin': instance.lastLogin?.toIso8601String(),
      'platform': instance.platform,
      'isOnline': instance.isOnline,
      'developerType': instance.developerType,
      'tags': instance.tags,
      'friendKey': instance.friendKey,
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
