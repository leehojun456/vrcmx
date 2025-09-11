class Friend {
  final String id;
  final String displayName;
  final String? bio;
  final List<String>? bioLinks;
  final String? currentAvatarImageUrl;
  final String? currentAvatarThumbnailImageUrl;
  final List<String>? currentAvatarTags;
  final String? developerType;
  final String? friendKey;
  final bool isFriend;
  final String? imageUrl;
  final String? lastPlatform; // API key: last_platform
  final String? location;
  final DateTime? lastLogin; // API key: last_login
  final DateTime? lastActivity; // API key: last_activity
  final DateTime? lastMobile; // API key: last_mobile
  final String? platform;
  final String? profilePicOverride;
  final String? profilePicOverrideThumbnail;
  final String? status;
  final String? statusDescription;
  final List<String>? tags;
  final String? userIcon;
  // computed / extra
  final bool isOnline;
  final String? instanceId;
  final String? worldId;
  final String? travelingToLocation;
  final bool canRequestInvite;
  final Map<String, dynamic>? rawApiResponse;

  const Friend({
    required this.id,
    required this.displayName,
    this.bio,
    this.bioLinks,
    this.currentAvatarImageUrl,
    this.currentAvatarThumbnailImageUrl,
    this.currentAvatarTags,
    this.developerType,
    this.friendKey,
    this.isFriend = true,
    this.imageUrl,
    this.lastPlatform,
    this.location,
    this.lastLogin,
    this.lastActivity,
    this.lastMobile,
    this.platform,
    this.profilePicOverride,
    this.profilePicOverrideThumbnail,
    this.status,
    this.statusDescription,
    this.tags,
    this.userIcon,
    this.isOnline = false,
    this.instanceId,
    this.worldId,
    this.travelingToLocation,
    this.canRequestInvite = false,
    this.rawApiResponse,
  });

  Friend copyWith({
    String? id,
    String? displayName,
    String? bio,
    List<String>? bioLinks,
    String? currentAvatarImageUrl,
    String? currentAvatarThumbnailImageUrl,
    List<String>? currentAvatarTags,
    String? developerType,
    String? friendKey,
    bool? isFriend,
    String? imageUrl,
    String? lastPlatform,
    String? location,
    DateTime? lastLogin,
    DateTime? lastActivity,
    DateTime? lastMobile,
    String? platform,
    String? profilePicOverride,
    String? profilePicOverrideThumbnail,
    String? status,
    String? statusDescription,
    List<String>? tags,
    String? userIcon,
    bool? isOnline,
    String? instanceId,
    String? worldId,
    String? travelingToLocation,
    bool? canRequestInvite,
    Map<String, dynamic>? rawApiResponse,
  }) {
    return Friend(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      bioLinks: bioLinks ?? this.bioLinks,
      currentAvatarImageUrl:
          currentAvatarImageUrl ?? this.currentAvatarImageUrl,
      currentAvatarThumbnailImageUrl:
          currentAvatarThumbnailImageUrl ??
              this.currentAvatarThumbnailImageUrl,
      currentAvatarTags: currentAvatarTags ?? this.currentAvatarTags,
      developerType: developerType ?? this.developerType,
      friendKey: friendKey ?? this.friendKey,
      isFriend: isFriend ?? this.isFriend,
      imageUrl: imageUrl ?? this.imageUrl,
      lastPlatform: lastPlatform ?? this.lastPlatform,
      location: location ?? this.location,
      lastLogin: lastLogin ?? this.lastLogin,
      lastActivity: lastActivity ?? this.lastActivity,
      lastMobile: lastMobile ?? this.lastMobile,
      platform: platform ?? this.platform,
      profilePicOverride: profilePicOverride ?? this.profilePicOverride,
      profilePicOverrideThumbnail: profilePicOverrideThumbnail ??
          this.profilePicOverrideThumbnail,
      status: status ?? this.status,
      statusDescription: statusDescription ?? this.statusDescription,
      tags: tags ?? this.tags,
      userIcon: userIcon ?? this.userIcon,
      isOnline: isOnline ?? this.isOnline,
      instanceId: instanceId ?? this.instanceId,
      worldId: worldId ?? this.worldId,
      travelingToLocation: travelingToLocation ?? this.travelingToLocation,
      canRequestInvite: canRequestInvite ?? this.canRequestInvite,
      rawApiResponse: rawApiResponse ?? this.rawApiResponse,
    );
  }

  factory Friend.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDT(dynamic v) => v == null ? null : DateTime.tryParse(v);
    return Friend(
      id: json['id'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      bio: json['bio'] as String?,
      bioLinks: (json['bioLinks'] as List?)?.cast<String>(),
      currentAvatarImageUrl: json['currentAvatarImageUrl'] as String?,
      currentAvatarThumbnailImageUrl:
          json['currentAvatarThumbnailImageUrl'] as String?,
      currentAvatarTags: (json['currentAvatarTags'] as List?)?.cast<String>(),
      developerType: json['developerType'] as String?,
      friendKey: json['friendKey'] as String?,
      isFriend: (json['isFriend'] as bool?) ?? true,
      imageUrl: json['imageUrl'] as String?,
      lastPlatform: json['last_platform'] as String?,
      location: json['location'] as String?,
      lastLogin: _parseDT(json['last_login']),
      lastActivity: _parseDT(json['last_activity']),
      lastMobile: _parseDT(json['last_mobile']),
      platform: json['platform'] as String?,
      profilePicOverride: json['profilePicOverride'] as String?,
      profilePicOverrideThumbnail:
          json['profilePicOverrideThumbnail'] as String?,
      status: json['status'] as String?,
      statusDescription: json['statusDescription'] as String?,
      tags: (json['tags'] as List?)?.cast<String>(),
      userIcon: json['userIcon'] as String?,
      isOnline: (json['isOnline'] as bool?) ?? false,
      instanceId: json['instanceId'] as String?,
      worldId: json['worldId'] as String?,
      travelingToLocation: json['travelingToLocation'] as String?,
      canRequestInvite: (json['canRequestInvite'] as bool?) ?? false,
      rawApiResponse: json['rawApiResponse'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'bio': bio,
        'bioLinks': bioLinks,
        'currentAvatarImageUrl': currentAvatarImageUrl,
        'currentAvatarThumbnailImageUrl': currentAvatarThumbnailImageUrl,
        'currentAvatarTags': currentAvatarTags,
        'developerType': developerType,
        'friendKey': friendKey,
        'isFriend': isFriend,
        'imageUrl': imageUrl,
        'last_platform': lastPlatform,
        'location': location,
        'last_login': lastLogin?.toIso8601String(),
        'last_activity': lastActivity?.toIso8601String(),
        'last_mobile': lastMobile?.toIso8601String(),
        'platform': platform,
        'profilePicOverride': profilePicOverride,
        'profilePicOverrideThumbnail': profilePicOverrideThumbnail,
        'status': status,
        'statusDescription': statusDescription,
        'tags': tags,
        'userIcon': userIcon,
        'isOnline': isOnline,
        'instanceId': instanceId,
        'worldId': worldId,
        'travelingToLocation': travelingToLocation,
        'canRequestInvite': canRequestInvite,
        'rawApiResponse': rawApiResponse,
      };
}

class FriendsListResponse {
  final bool success;
  final String? message;
  final List<Friend> friends;
  final int? total;
  final Map<String, dynamic>? rawApiResponse;

  const FriendsListResponse({
    required this.success,
    this.message,
    this.friends = const [],
    this.total,
    this.rawApiResponse,
  });

  factory FriendsListResponse.fromJson(Map<String, dynamic> json) {
    return FriendsListResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      friends: (json['friends'] as List?)
              ?.map((e) => Friend.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      total: (json['total'] as num?)?.toInt(),
      rawApiResponse: json['rawApiResponse'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'friends': friends.map((e) => e.toJson()).toList(),
        'total': total,
        'rawApiResponse': rawApiResponse,
      };
}

