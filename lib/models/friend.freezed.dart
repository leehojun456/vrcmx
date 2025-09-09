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
  String get username => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  String? get currentAvatarImageUrl => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get statusDescription => throw _privateConstructorUsedError;
  String? get location =>
      throw _privateConstructorUsedError; // world 또는 offline, private 등
  String? get instanceId => throw _privateConstructorUsedError;
  String? get worldId => throw _privateConstructorUsedError;
  DateTime? get lastLogin => throw _privateConstructorUsedError;
  String? get platform => throw _privateConstructorUsedError;
  bool get isOnline => throw _privateConstructorUsedError;
  String? get developerType => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  String? get friendKey =>
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
    String username,
    String displayName,
    String? bio,
    String? currentAvatarImageUrl,
    String? status,
    String? statusDescription,
    String? location,
    String? instanceId,
    String? worldId,
    DateTime? lastLogin,
    String? platform,
    bool isOnline,
    String? developerType,
    List<String>? tags,
    String? friendKey,
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
    Object? username = null,
    Object? displayName = null,
    Object? bio = freezed,
    Object? currentAvatarImageUrl = freezed,
    Object? status = freezed,
    Object? statusDescription = freezed,
    Object? location = freezed,
    Object? instanceId = freezed,
    Object? worldId = freezed,
    Object? lastLogin = freezed,
    Object? platform = freezed,
    Object? isOnline = null,
    Object? developerType = freezed,
    Object? tags = freezed,
    Object? friendKey = freezed,
    Object? rawApiResponse = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            bio: freezed == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String?,
            currentAvatarImageUrl: freezed == currentAvatarImageUrl
                ? _value.currentAvatarImageUrl
                : currentAvatarImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            statusDescription: freezed == statusDescription
                ? _value.statusDescription
                : statusDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            instanceId: freezed == instanceId
                ? _value.instanceId
                : instanceId // ignore: cast_nullable_to_non_nullable
                      as String?,
            worldId: freezed == worldId
                ? _value.worldId
                : worldId // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastLogin: freezed == lastLogin
                ? _value.lastLogin
                : lastLogin // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            platform: freezed == platform
                ? _value.platform
                : platform // ignore: cast_nullable_to_non_nullable
                      as String?,
            isOnline: null == isOnline
                ? _value.isOnline
                : isOnline // ignore: cast_nullable_to_non_nullable
                      as bool,
            developerType: freezed == developerType
                ? _value.developerType
                : developerType // ignore: cast_nullable_to_non_nullable
                      as String?,
            tags: freezed == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            friendKey: freezed == friendKey
                ? _value.friendKey
                : friendKey // ignore: cast_nullable_to_non_nullable
                      as String?,
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
    String username,
    String displayName,
    String? bio,
    String? currentAvatarImageUrl,
    String? status,
    String? statusDescription,
    String? location,
    String? instanceId,
    String? worldId,
    DateTime? lastLogin,
    String? platform,
    bool isOnline,
    String? developerType,
    List<String>? tags,
    String? friendKey,
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
    Object? username = null,
    Object? displayName = null,
    Object? bio = freezed,
    Object? currentAvatarImageUrl = freezed,
    Object? status = freezed,
    Object? statusDescription = freezed,
    Object? location = freezed,
    Object? instanceId = freezed,
    Object? worldId = freezed,
    Object? lastLogin = freezed,
    Object? platform = freezed,
    Object? isOnline = null,
    Object? developerType = freezed,
    Object? tags = freezed,
    Object? friendKey = freezed,
    Object? rawApiResponse = freezed,
  }) {
    return _then(
      _$FriendImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String?,
        currentAvatarImageUrl: freezed == currentAvatarImageUrl
            ? _value.currentAvatarImageUrl
            : currentAvatarImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        statusDescription: freezed == statusDescription
            ? _value.statusDescription
            : statusDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        instanceId: freezed == instanceId
            ? _value.instanceId
            : instanceId // ignore: cast_nullable_to_non_nullable
                  as String?,
        worldId: freezed == worldId
            ? _value.worldId
            : worldId // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastLogin: freezed == lastLogin
            ? _value.lastLogin
            : lastLogin // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        platform: freezed == platform
            ? _value.platform
            : platform // ignore: cast_nullable_to_non_nullable
                  as String?,
        isOnline: null == isOnline
            ? _value.isOnline
            : isOnline // ignore: cast_nullable_to_non_nullable
                  as bool,
        developerType: freezed == developerType
            ? _value.developerType
            : developerType // ignore: cast_nullable_to_non_nullable
                  as String?,
        tags: freezed == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        friendKey: freezed == friendKey
            ? _value.friendKey
            : friendKey // ignore: cast_nullable_to_non_nullable
                  as String?,
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
    required this.username,
    required this.displayName,
    this.bio,
    this.currentAvatarImageUrl,
    this.status,
    this.statusDescription,
    this.location,
    this.instanceId,
    this.worldId,
    this.lastLogin,
    this.platform,
    this.isOnline = false,
    this.developerType,
    final List<String>? tags,
    this.friendKey,
    final Map<String, dynamic>? rawApiResponse,
  }) : _tags = tags,
       _rawApiResponse = rawApiResponse;

  factory _$FriendImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendImplFromJson(json);

  @override
  final String id;
  @override
  final String username;
  @override
  final String displayName;
  @override
  final String? bio;
  @override
  final String? currentAvatarImageUrl;
  @override
  final String? status;
  @override
  final String? statusDescription;
  @override
  final String? location;
  // world 또는 offline, private 등
  @override
  final String? instanceId;
  @override
  final String? worldId;
  @override
  final DateTime? lastLogin;
  @override
  final String? platform;
  @override
  @JsonKey()
  final bool isOnline;
  @override
  final String? developerType;
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
  final String? friendKey;
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
    return 'Friend(id: $id, username: $username, displayName: $displayName, bio: $bio, currentAvatarImageUrl: $currentAvatarImageUrl, status: $status, statusDescription: $statusDescription, location: $location, instanceId: $instanceId, worldId: $worldId, lastLogin: $lastLogin, platform: $platform, isOnline: $isOnline, developerType: $developerType, tags: $tags, friendKey: $friendKey, rawApiResponse: $rawApiResponse)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.currentAvatarImageUrl, currentAvatarImageUrl) ||
                other.currentAvatarImageUrl == currentAvatarImageUrl) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusDescription, statusDescription) ||
                other.statusDescription == statusDescription) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.instanceId, instanceId) ||
                other.instanceId == instanceId) &&
            (identical(other.worldId, worldId) || other.worldId == worldId) &&
            (identical(other.lastLogin, lastLogin) ||
                other.lastLogin == lastLogin) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.developerType, developerType) ||
                other.developerType == developerType) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.friendKey, friendKey) ||
                other.friendKey == friendKey) &&
            const DeepCollectionEquality().equals(
              other._rawApiResponse,
              _rawApiResponse,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    username,
    displayName,
    bio,
    currentAvatarImageUrl,
    status,
    statusDescription,
    location,
    instanceId,
    worldId,
    lastLogin,
    platform,
    isOnline,
    developerType,
    const DeepCollectionEquality().hash(_tags),
    friendKey,
    const DeepCollectionEquality().hash(_rawApiResponse),
  );

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
    required final String username,
    required final String displayName,
    final String? bio,
    final String? currentAvatarImageUrl,
    final String? status,
    final String? statusDescription,
    final String? location,
    final String? instanceId,
    final String? worldId,
    final DateTime? lastLogin,
    final String? platform,
    final bool isOnline,
    final String? developerType,
    final List<String>? tags,
    final String? friendKey,
    final Map<String, dynamic>? rawApiResponse,
  }) = _$FriendImpl;

  factory _Friend.fromJson(Map<String, dynamic> json) = _$FriendImpl.fromJson;

  @override
  String get id;
  @override
  String get username;
  @override
  String get displayName;
  @override
  String? get bio;
  @override
  String? get currentAvatarImageUrl;
  @override
  String? get status;
  @override
  String? get statusDescription;
  @override
  String? get location; // world 또는 offline, private 등
  @override
  String? get instanceId;
  @override
  String? get worldId;
  @override
  DateTime? get lastLogin;
  @override
  String? get platform;
  @override
  bool get isOnline;
  @override
  String? get developerType;
  @override
  List<String>? get tags;
  @override
  String? get friendKey; // VRChat API 원본 응답 저장
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
