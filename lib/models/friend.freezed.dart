// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Friend _$FriendFromJson(Map<String, dynamic> json) {
  return _Friend.fromJson(json);
}

/// @nodoc
mixin _$Friend {
  String get id => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  List<String>? get bioLinks => throw _privateConstructorUsedError;
  String? get currentAvatarImageUrl => throw _privateConstructorUsedError;
  String? get currentAvatarThumbnailImageUrl =>
      throw _privateConstructorUsedError;
  List<String>? get currentAvatarTags => throw _privateConstructorUsedError;
  String? get developerType => throw _privateConstructorUsedError;
  String? get friendKey => throw _privateConstructorUsedError;
  bool get isFriend => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_platform')
  String? get lastPlatform => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_login')
  DateTime? get lastLogin => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_activity')
  DateTime? get lastActivity => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_mobile')
  DateTime? get lastMobile => throw _privateConstructorUsedError;
  String? get platform => throw _privateConstructorUsedError;
  String? get profilePicOverride => throw _privateConstructorUsedError;
  String? get profilePicOverrideThumbnail => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get statusDescription => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  String? get userIcon => throw _privateConstructorUsedError; // 계산된 필드들
  bool get isOnline => throw _privateConstructorUsedError;
  String? get instanceId => throw _privateConstructorUsedError;
  String? get worldId => throw _privateConstructorUsedError;
  String? get travelingToLocation => throw _privateConstructorUsedError;
  bool get canRequestInvite =>
      throw _privateConstructorUsedError; // VRChat API 원본 응답 저장
  Map<String, dynamic>? get rawApiResponse =>
      throw _privateConstructorUsedError;

  /// Serializes this Friend to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendCopyWith<Friend> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendCopyWith<$Res> {
  factory $FriendCopyWith(Friend value, $Res Function(Friend) then) =
      _$FriendCopyWithImpl<$Res, Friend>;
  @useResult
  $Res call({
    String id,
    String displayName,
    String? bio,
    List<String>? bioLinks,
    String? currentAvatarImageUrl,
    String? currentAvatarThumbnailImageUrl,
    List<String>? currentAvatarTags,
    String? developerType,
    String? friendKey,
    bool isFriend,
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
    bool isOnline,
    String? instanceId,
    String? worldId,
    String? travelingToLocation,
    bool canRequestInvite,
    Map<String, dynamic>? rawApiResponse,
  });
}

/// @nodoc
class _$FriendCopyWithImpl<$Res, $Val extends Friend>
    implements $FriendCopyWith<$Res> {
  _$FriendCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? bio = freezed,
    Object? bioLinks = freezed,
    Object? currentAvatarImageUrl = freezed,
    Object? currentAvatarThumbnailImageUrl = freezed,
    Object? currentAvatarTags = freezed,
    Object? developerType = freezed,
    Object? friendKey = freezed,
    Object? isFriend = null,
    Object? imageUrl = freezed,
    Object? lastPlatform = freezed,
    Object? location = freezed,
    Object? lastLogin = freezed,
    Object? lastActivity = freezed,
    Object? lastMobile = freezed,
    Object? platform = freezed,
    Object? profilePicOverride = freezed,
    Object? profilePicOverrideThumbnail = freezed,
    Object? status = freezed,
    Object? statusDescription = freezed,
    Object? tags = freezed,
    Object? userIcon = freezed,
    Object? isOnline = null,
    Object? instanceId = freezed,
    Object? worldId = freezed,
    Object? travelingToLocation = freezed,
    Object? canRequestInvite = null,
    Object? rawApiResponse = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            bio: freezed == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String?,
            bioLinks: freezed == bioLinks
                ? _value.bioLinks
                : bioLinks // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            currentAvatarImageUrl: freezed == currentAvatarImageUrl
                ? _value.currentAvatarImageUrl
                : currentAvatarImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            currentAvatarThumbnailImageUrl:
                freezed == currentAvatarThumbnailImageUrl
                ? _value.currentAvatarThumbnailImageUrl
                : currentAvatarThumbnailImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            currentAvatarTags: freezed == currentAvatarTags
                ? _value.currentAvatarTags
                : currentAvatarTags // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            developerType: freezed == developerType
                ? _value.developerType
                : developerType // ignore: cast_nullable_to_non_nullable
                      as String?,
            friendKey: freezed == friendKey
                ? _value.friendKey
                : friendKey // ignore: cast_nullable_to_non_nullable
                      as String?,
            isFriend: null == isFriend
                ? _value.isFriend
                : isFriend // ignore: cast_nullable_to_non_nullable
                      as bool,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastPlatform: freezed == lastPlatform
                ? _value.lastPlatform
                : lastPlatform // ignore: cast_nullable_to_non_nullable
                      as String?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastLogin: freezed == lastLogin
                ? _value.lastLogin
                : lastLogin // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lastActivity: freezed == lastActivity
                ? _value.lastActivity
                : lastActivity // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lastMobile: freezed == lastMobile
                ? _value.lastMobile
                : lastMobile // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            platform: freezed == platform
                ? _value.platform
                : platform // ignore: cast_nullable_to_non_nullable
                      as String?,
            profilePicOverride: freezed == profilePicOverride
                ? _value.profilePicOverride
                : profilePicOverride // ignore: cast_nullable_to_non_nullable
                      as String?,
            profilePicOverrideThumbnail: freezed == profilePicOverrideThumbnail
                ? _value.profilePicOverrideThumbnail
                : profilePicOverrideThumbnail // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            statusDescription: freezed == statusDescription
                ? _value.statusDescription
                : statusDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            tags: freezed == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            userIcon: freezed == userIcon
                ? _value.userIcon
                : userIcon // ignore: cast_nullable_to_non_nullable
                      as String?,
            isOnline: null == isOnline
                ? _value.isOnline
                : isOnline // ignore: cast_nullable_to_non_nullable
                      as bool,
            instanceId: freezed == instanceId
                ? _value.instanceId
                : instanceId // ignore: cast_nullable_to_non_nullable
                      as String?,
            worldId: freezed == worldId
                ? _value.worldId
                : worldId // ignore: cast_nullable_to_non_nullable
                      as String?,
            travelingToLocation: freezed == travelingToLocation
                ? _value.travelingToLocation
                : travelingToLocation // ignore: cast_nullable_to_non_nullable
                      as String?,
            canRequestInvite: null == canRequestInvite
                ? _value.canRequestInvite
                : canRequestInvite // ignore: cast_nullable_to_non_nullable
                      as bool,
            rawApiResponse: freezed == rawApiResponse
                ? _value.rawApiResponse
                : rawApiResponse // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FriendImplCopyWith<$Res> implements $FriendCopyWith<$Res> {
  factory _$$FriendImplCopyWith(
    _$FriendImpl value,
    $Res Function(_$FriendImpl) then,
  ) = __$$FriendImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String displayName,
    String? bio,
    List<String>? bioLinks,
    String? currentAvatarImageUrl,
    String? currentAvatarThumbnailImageUrl,
    List<String>? currentAvatarTags,
    String? developerType,
    String? friendKey,
    bool isFriend,
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
    bool isOnline,
    String? instanceId,
    String? worldId,
    String? travelingToLocation,
    bool canRequestInvite,
    Map<String, dynamic>? rawApiResponse,
  });
}

/// @nodoc
class __$$FriendImplCopyWithImpl<$Res>
    extends _$FriendCopyWithImpl<$Res, _$FriendImpl>
    implements _$$FriendImplCopyWith<$Res> {
  __$$FriendImplCopyWithImpl(
    _$FriendImpl _value,
    $Res Function(_$FriendImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? bio = freezed,
    Object? bioLinks = freezed,
    Object? currentAvatarImageUrl = freezed,
    Object? currentAvatarThumbnailImageUrl = freezed,
    Object? currentAvatarTags = freezed,
    Object? developerType = freezed,
    Object? friendKey = freezed,
    Object? isFriend = null,
    Object? imageUrl = freezed,
    Object? lastPlatform = freezed,
    Object? location = freezed,
    Object? lastLogin = freezed,
    Object? lastActivity = freezed,
    Object? lastMobile = freezed,
    Object? platform = freezed,
    Object? profilePicOverride = freezed,
    Object? profilePicOverrideThumbnail = freezed,
    Object? status = freezed,
    Object? statusDescription = freezed,
    Object? tags = freezed,
    Object? userIcon = freezed,
    Object? isOnline = null,
    Object? instanceId = freezed,
    Object? worldId = freezed,
    Object? travelingToLocation = freezed,
    Object? canRequestInvite = null,
    Object? rawApiResponse = freezed,
  }) {
    return _then(
      _$FriendImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String?,
        bioLinks: freezed == bioLinks
            ? _value._bioLinks
            : bioLinks // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        currentAvatarImageUrl: freezed == currentAvatarImageUrl
            ? _value.currentAvatarImageUrl
            : currentAvatarImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        currentAvatarThumbnailImageUrl:
            freezed == currentAvatarThumbnailImageUrl
            ? _value.currentAvatarThumbnailImageUrl
            : currentAvatarThumbnailImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        currentAvatarTags: freezed == currentAvatarTags
            ? _value._currentAvatarTags
            : currentAvatarTags // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        developerType: freezed == developerType
            ? _value.developerType
            : developerType // ignore: cast_nullable_to_non_nullable
                  as String?,
        friendKey: freezed == friendKey
            ? _value.friendKey
            : friendKey // ignore: cast_nullable_to_non_nullable
                  as String?,
        isFriend: null == isFriend
            ? _value.isFriend
            : isFriend // ignore: cast_nullable_to_non_nullable
                  as bool,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastPlatform: freezed == lastPlatform
            ? _value.lastPlatform
            : lastPlatform // ignore: cast_nullable_to_non_nullable
                  as String?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastLogin: freezed == lastLogin
            ? _value.lastLogin
            : lastLogin // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastActivity: freezed == lastActivity
            ? _value.lastActivity
            : lastActivity // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastMobile: freezed == lastMobile
            ? _value.lastMobile
            : lastMobile // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        platform: freezed == platform
            ? _value.platform
            : platform // ignore: cast_nullable_to_non_nullable
                  as String?,
        profilePicOverride: freezed == profilePicOverride
            ? _value.profilePicOverride
            : profilePicOverride // ignore: cast_nullable_to_non_nullable
                  as String?,
        profilePicOverrideThumbnail: freezed == profilePicOverrideThumbnail
            ? _value.profilePicOverrideThumbnail
            : profilePicOverrideThumbnail // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        statusDescription: freezed == statusDescription
            ? _value.statusDescription
            : statusDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
        tags: freezed == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        userIcon: freezed == userIcon
            ? _value.userIcon
            : userIcon // ignore: cast_nullable_to_non_nullable
                  as String?,
        isOnline: null == isOnline
            ? _value.isOnline
            : isOnline // ignore: cast_nullable_to_non_nullable
                  as bool,
        instanceId: freezed == instanceId
            ? _value.instanceId
            : instanceId // ignore: cast_nullable_to_non_nullable
                  as String?,
        worldId: freezed == worldId
            ? _value.worldId
            : worldId // ignore: cast_nullable_to_non_nullable
                  as String?,
        travelingToLocation: freezed == travelingToLocation
            ? _value.travelingToLocation
            : travelingToLocation // ignore: cast_nullable_to_non_nullable
                  as String?,
        canRequestInvite: null == canRequestInvite
            ? _value.canRequestInvite
            : canRequestInvite // ignore: cast_nullable_to_non_nullable
                  as bool,
        rawApiResponse: freezed == rawApiResponse
            ? _value._rawApiResponse
            : rawApiResponse // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendImpl implements _Friend {
  const _$FriendImpl({
    required this.id,
    required this.displayName,
    this.bio,
    final List<String>? bioLinks,
    this.currentAvatarImageUrl,
    this.currentAvatarThumbnailImageUrl,
    final List<String>? currentAvatarTags,
    this.developerType,
    this.friendKey,
    this.isFriend = true,
    this.imageUrl,
    @JsonKey(name: 'last_platform') this.lastPlatform,
    this.location,
    @JsonKey(name: 'last_login') this.lastLogin,
    @JsonKey(name: 'last_activity') this.lastActivity,
    @JsonKey(name: 'last_mobile') this.lastMobile,
    this.platform,
    this.profilePicOverride,
    this.profilePicOverrideThumbnail,
    this.status,
    this.statusDescription,
    final List<String>? tags,
    this.userIcon,
    this.isOnline = false,
    this.instanceId,
    this.worldId,
    this.travelingToLocation,
    this.canRequestInvite = false,
    final Map<String, dynamic>? rawApiResponse,
  }) : _bioLinks = bioLinks,
       _currentAvatarTags = currentAvatarTags,
       _tags = tags,
       _rawApiResponse = rawApiResponse;

  factory _$FriendImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendImplFromJson(json);

  @override
  final String id;
  @override
  final String displayName;
  @override
  final String? bio;
  final List<String>? _bioLinks;
  @override
  List<String>? get bioLinks {
    final value = _bioLinks;
    if (value == null) return null;
    if (_bioLinks is EqualUnmodifiableListView) return _bioLinks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? currentAvatarImageUrl;
  @override
  final String? currentAvatarThumbnailImageUrl;
  final List<String>? _currentAvatarTags;
  @override
  List<String>? get currentAvatarTags {
    final value = _currentAvatarTags;
    if (value == null) return null;
    if (_currentAvatarTags is EqualUnmodifiableListView)
      return _currentAvatarTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? developerType;
  @override
  final String? friendKey;
  @override
  @JsonKey()
  final bool isFriend;
  @override
  final String? imageUrl;
  @override
  @JsonKey(name: 'last_platform')
  final String? lastPlatform;
  @override
  final String? location;
  @override
  @JsonKey(name: 'last_login')
  final DateTime? lastLogin;
  @override
  @JsonKey(name: 'last_activity')
  final DateTime? lastActivity;
  @override
  @JsonKey(name: 'last_mobile')
  final DateTime? lastMobile;
  @override
  final String? platform;
  @override
  final String? profilePicOverride;
  @override
  final String? profilePicOverrideThumbnail;
  @override
  final String? status;
  @override
  final String? statusDescription;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? userIcon;
  // 계산된 필드들
  @override
  @JsonKey()
  final bool isOnline;
  @override
  final String? instanceId;
  @override
  final String? worldId;
  @override
  final String? travelingToLocation;
  @override
  @JsonKey()
  final bool canRequestInvite;
  // VRChat API 원본 응답 저장
  final Map<String, dynamic>? _rawApiResponse;
  // VRChat API 원본 응답 저장
  @override
  Map<String, dynamic>? get rawApiResponse {
    final value = _rawApiResponse;
    if (value == null) return null;
    if (_rawApiResponse is EqualUnmodifiableMapView) return _rawApiResponse;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Friend(id: $id, displayName: $displayName, bio: $bio, bioLinks: $bioLinks, currentAvatarImageUrl: $currentAvatarImageUrl, currentAvatarThumbnailImageUrl: $currentAvatarThumbnailImageUrl, currentAvatarTags: $currentAvatarTags, developerType: $developerType, friendKey: $friendKey, isFriend: $isFriend, imageUrl: $imageUrl, lastPlatform: $lastPlatform, location: $location, lastLogin: $lastLogin, lastActivity: $lastActivity, lastMobile: $lastMobile, platform: $platform, profilePicOverride: $profilePicOverride, profilePicOverrideThumbnail: $profilePicOverrideThumbnail, status: $status, statusDescription: $statusDescription, tags: $tags, userIcon: $userIcon, isOnline: $isOnline, instanceId: $instanceId, worldId: $worldId, travelingToLocation: $travelingToLocation, canRequestInvite: $canRequestInvite, rawApiResponse: $rawApiResponse)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            const DeepCollectionEquality().equals(other._bioLinks, _bioLinks) &&
            (identical(other.currentAvatarImageUrl, currentAvatarImageUrl) ||
                other.currentAvatarImageUrl == currentAvatarImageUrl) &&
            (identical(
                  other.currentAvatarThumbnailImageUrl,
                  currentAvatarThumbnailImageUrl,
                ) ||
                other.currentAvatarThumbnailImageUrl ==
                    currentAvatarThumbnailImageUrl) &&
            const DeepCollectionEquality().equals(
              other._currentAvatarTags,
              _currentAvatarTags,
            ) &&
            (identical(other.developerType, developerType) ||
                other.developerType == developerType) &&
            (identical(other.friendKey, friendKey) ||
                other.friendKey == friendKey) &&
            (identical(other.isFriend, isFriend) ||
                other.isFriend == isFriend) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.lastPlatform, lastPlatform) ||
                other.lastPlatform == lastPlatform) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.lastLogin, lastLogin) ||
                other.lastLogin == lastLogin) &&
            (identical(other.lastActivity, lastActivity) ||
                other.lastActivity == lastActivity) &&
            (identical(other.lastMobile, lastMobile) ||
                other.lastMobile == lastMobile) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.profilePicOverride, profilePicOverride) ||
                other.profilePicOverride == profilePicOverride) &&
            (identical(
                  other.profilePicOverrideThumbnail,
                  profilePicOverrideThumbnail,
                ) ||
                other.profilePicOverrideThumbnail ==
                    profilePicOverrideThumbnail) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusDescription, statusDescription) ||
                other.statusDescription == statusDescription) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.userIcon, userIcon) ||
                other.userIcon == userIcon) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.instanceId, instanceId) ||
                other.instanceId == instanceId) &&
            (identical(other.worldId, worldId) || other.worldId == worldId) &&
            (identical(other.travelingToLocation, travelingToLocation) ||
                other.travelingToLocation == travelingToLocation) &&
            (identical(other.canRequestInvite, canRequestInvite) ||
                other.canRequestInvite == canRequestInvite) &&
            const DeepCollectionEquality().equals(
              other._rawApiResponse,
              _rawApiResponse,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    displayName,
    bio,
    const DeepCollectionEquality().hash(_bioLinks),
    currentAvatarImageUrl,
    currentAvatarThumbnailImageUrl,
    const DeepCollectionEquality().hash(_currentAvatarTags),
    developerType,
    friendKey,
    isFriend,
    imageUrl,
    lastPlatform,
    location,
    lastLogin,
    lastActivity,
    lastMobile,
    platform,
    profilePicOverride,
    profilePicOverrideThumbnail,
    status,
    statusDescription,
    const DeepCollectionEquality().hash(_tags),
    userIcon,
    isOnline,
    instanceId,
    worldId,
    travelingToLocation,
    canRequestInvite,
    const DeepCollectionEquality().hash(_rawApiResponse),
  ]);

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendImplCopyWith<_$FriendImpl> get copyWith =>
      __$$FriendImplCopyWithImpl<_$FriendImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendImplToJson(this);
  }
}

abstract class _Friend implements Friend {
  const factory _Friend({
    required final String id,
    required final String displayName,
    final String? bio,
    final List<String>? bioLinks,
    final String? currentAvatarImageUrl,
    final String? currentAvatarThumbnailImageUrl,
    final List<String>? currentAvatarTags,
    final String? developerType,
    final String? friendKey,
    final bool isFriend,
    final String? imageUrl,
    @JsonKey(name: 'last_platform') final String? lastPlatform,
    final String? location,
    @JsonKey(name: 'last_login') final DateTime? lastLogin,
    @JsonKey(name: 'last_activity') final DateTime? lastActivity,
    @JsonKey(name: 'last_mobile') final DateTime? lastMobile,
    final String? platform,
    final String? profilePicOverride,
    final String? profilePicOverrideThumbnail,
    final String? status,
    final String? statusDescription,
    final List<String>? tags,
    final String? userIcon,
    final bool isOnline,
    final String? instanceId,
    final String? worldId,
    final String? travelingToLocation,
    final bool canRequestInvite,
    final Map<String, dynamic>? rawApiResponse,
  }) = _$FriendImpl;

  factory _Friend.fromJson(Map<String, dynamic> json) = _$FriendImpl.fromJson;

  @override
  String get id;
  @override
  String get displayName;
  @override
  String? get bio;
  @override
  List<String>? get bioLinks;
  @override
  String? get currentAvatarImageUrl;
  @override
  String? get currentAvatarThumbnailImageUrl;
  @override
  List<String>? get currentAvatarTags;
  @override
  String? get developerType;
  @override
  String? get friendKey;
  @override
  bool get isFriend;
  @override
  String? get imageUrl;
  @override
  @JsonKey(name: 'last_platform')
  String? get lastPlatform;
  @override
  String? get location;
  @override
  @JsonKey(name: 'last_login')
  DateTime? get lastLogin;
  @override
  @JsonKey(name: 'last_activity')
  DateTime? get lastActivity;
  @override
  @JsonKey(name: 'last_mobile')
  DateTime? get lastMobile;
  @override
  String? get platform;
  @override
  String? get profilePicOverride;
  @override
  String? get profilePicOverrideThumbnail;
  @override
  String? get status;
  @override
  String? get statusDescription;
  @override
  List<String>? get tags;
  @override
  String? get userIcon; // 계산된 필드들
  @override
  bool get isOnline;
  @override
  String? get instanceId;
  @override
  String? get worldId;
  @override
  String? get travelingToLocation;
  @override
  bool get canRequestInvite; // VRChat API 원본 응답 저장
  @override
  Map<String, dynamic>? get rawApiResponse;

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendImplCopyWith<_$FriendImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FriendsListResponse _$FriendsListResponseFromJson(Map<String, dynamic> json) {
  return _FriendsListResponse.fromJson(json);
}

/// @nodoc
mixin _$FriendsListResponse {
  bool get success => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  List<Friend> get friends => throw _privateConstructorUsedError;
  int? get total => throw _privateConstructorUsedError;
  Map<String, dynamic>? get rawApiResponse =>
      throw _privateConstructorUsedError;

  /// Serializes this FriendsListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FriendsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendsListResponseCopyWith<FriendsListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendsListResponseCopyWith<$Res> {
  factory $FriendsListResponseCopyWith(
    FriendsListResponse value,
    $Res Function(FriendsListResponse) then,
  ) = _$FriendsListResponseCopyWithImpl<$Res, FriendsListResponse>;
  @useResult
  $Res call({
    bool success,
    String? message,
    List<Friend> friends,
    int? total,
    Map<String, dynamic>? rawApiResponse,
  });
}

/// @nodoc
class _$FriendsListResponseCopyWithImpl<$Res, $Val extends FriendsListResponse>
    implements $FriendsListResponseCopyWith<$Res> {
  _$FriendsListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? friends = null,
    Object? total = freezed,
    Object? rawApiResponse = freezed,
  }) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
            friends: null == friends
                ? _value.friends
                : friends // ignore: cast_nullable_to_non_nullable
                      as List<Friend>,
            total: freezed == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int?,
            rawApiResponse: freezed == rawApiResponse
                ? _value.rawApiResponse
                : rawApiResponse // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FriendsListResponseImplCopyWith<$Res>
    implements $FriendsListResponseCopyWith<$Res> {
  factory _$$FriendsListResponseImplCopyWith(
    _$FriendsListResponseImpl value,
    $Res Function(_$FriendsListResponseImpl) then,
  ) = __$$FriendsListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool success,
    String? message,
    List<Friend> friends,
    int? total,
    Map<String, dynamic>? rawApiResponse,
  });
}

/// @nodoc
class __$$FriendsListResponseImplCopyWithImpl<$Res>
    extends _$FriendsListResponseCopyWithImpl<$Res, _$FriendsListResponseImpl>
    implements _$$FriendsListResponseImplCopyWith<$Res> {
  __$$FriendsListResponseImplCopyWithImpl(
    _$FriendsListResponseImpl _value,
    $Res Function(_$FriendsListResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FriendsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? friends = null,
    Object? total = freezed,
    Object? rawApiResponse = freezed,
  }) {
    return _then(
      _$FriendsListResponseImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
        friends: null == friends
            ? _value._friends
            : friends // ignore: cast_nullable_to_non_nullable
                  as List<Friend>,
        total: freezed == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int?,
        rawApiResponse: freezed == rawApiResponse
            ? _value._rawApiResponse
            : rawApiResponse // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendsListResponseImpl implements _FriendsListResponse {
  const _$FriendsListResponseImpl({
    required this.success,
    this.message,
    final List<Friend> friends = const [],
    this.total,
    final Map<String, dynamic>? rawApiResponse,
  }) : _friends = friends,
       _rawApiResponse = rawApiResponse;

  factory _$FriendsListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendsListResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String? message;
  final List<Friend> _friends;
  @override
  @JsonKey()
  List<Friend> get friends {
    if (_friends is EqualUnmodifiableListView) return _friends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_friends);
  }

  @override
  final int? total;
  final Map<String, dynamic>? _rawApiResponse;
  @override
  Map<String, dynamic>? get rawApiResponse {
    final value = _rawApiResponse;
    if (value == null) return null;
    if (_rawApiResponse is EqualUnmodifiableMapView) return _rawApiResponse;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'FriendsListResponse(success: $success, message: $message, friends: $friends, total: $total, rawApiResponse: $rawApiResponse)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendsListResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._friends, _friends) &&
            (identical(other.total, total) || other.total == total) &&
            const DeepCollectionEquality().equals(
              other._rawApiResponse,
              _rawApiResponse,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    success,
    message,
    const DeepCollectionEquality().hash(_friends),
    total,
    const DeepCollectionEquality().hash(_rawApiResponse),
  );

  /// Create a copy of FriendsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendsListResponseImplCopyWith<_$FriendsListResponseImpl> get copyWith =>
      __$$FriendsListResponseImplCopyWithImpl<_$FriendsListResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendsListResponseImplToJson(this);
  }
}

abstract class _FriendsListResponse implements FriendsListResponse {
  const factory _FriendsListResponse({
    required final bool success,
    final String? message,
    final List<Friend> friends,
    final int? total,
    final Map<String, dynamic>? rawApiResponse,
  }) = _$FriendsListResponseImpl;

  factory _FriendsListResponse.fromJson(Map<String, dynamic> json) =
      _$FriendsListResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String? get message;
  @override
  List<Friend> get friends;
  @override
  int? get total;
  @override
  Map<String, dynamic>? get rawApiResponse;

  /// Create a copy of FriendsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendsListResponseImplCopyWith<_$FriendsListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
