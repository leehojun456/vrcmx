// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get avatarImageUrl => throw _privateConstructorUsedError;
  bool get isLoggedIn => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get statusDescription => throw _privateConstructorUsedError;
  String? get developerType => throw _privateConstructorUsedError;
  DateTime? get lastLogin => throw _privateConstructorUsedError;
  String? get platform =>
      throw _privateConstructorUsedError; // VRChat API 원본 응답을 저장
  Map<String, dynamic>? get rawApiResponse =>
      throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call({
    String id,
    String username,
    String displayName,
    String? email,
    String? avatarImageUrl,
    bool isLoggedIn,
    String? bio,
    String? status,
    String? statusDescription,
    String? developerType,
    DateTime? lastLogin,
    String? platform,
    Map<String, dynamic>? rawApiResponse,
  });
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? displayName = null,
    Object? email = freezed,
    Object? avatarImageUrl = freezed,
    Object? isLoggedIn = null,
    Object? bio = freezed,
    Object? status = freezed,
    Object? statusDescription = freezed,
    Object? developerType = freezed,
    Object? lastLogin = freezed,
    Object? platform = freezed,
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
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatarImageUrl: freezed == avatarImageUrl
                ? _value.avatarImageUrl
                : avatarImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            isLoggedIn: null == isLoggedIn
                ? _value.isLoggedIn
                : isLoggedIn // ignore: cast_nullable_to_non_nullable
                      as bool,
            bio: freezed == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            statusDescription: freezed == statusDescription
                ? _value.statusDescription
                : statusDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            developerType: freezed == developerType
                ? _value.developerType
                : developerType // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastLogin: freezed == lastLogin
                ? _value.lastLogin
                : lastLogin // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            platform: freezed == platform
                ? _value.platform
                : platform // ignore: cast_nullable_to_non_nullable
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
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
    _$UserImpl value,
    $Res Function(_$UserImpl) then,
  ) = __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String username,
    String displayName,
    String? email,
    String? avatarImageUrl,
    bool isLoggedIn,
    String? bio,
    String? status,
    String? statusDescription,
    String? developerType,
    DateTime? lastLogin,
    String? platform,
    Map<String, dynamic>? rawApiResponse,
  });
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
    : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? displayName = null,
    Object? email = freezed,
    Object? avatarImageUrl = freezed,
    Object? isLoggedIn = null,
    Object? bio = freezed,
    Object? status = freezed,
    Object? statusDescription = freezed,
    Object? developerType = freezed,
    Object? lastLogin = freezed,
    Object? platform = freezed,
    Object? rawApiResponse = freezed,
  }) {
    return _then(
      _$UserImpl(
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
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatarImageUrl: freezed == avatarImageUrl
            ? _value.avatarImageUrl
            : avatarImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        isLoggedIn: null == isLoggedIn
            ? _value.isLoggedIn
            : isLoggedIn // ignore: cast_nullable_to_non_nullable
                  as bool,
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        statusDescription: freezed == statusDescription
            ? _value.statusDescription
            : statusDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
        developerType: freezed == developerType
            ? _value.developerType
            : developerType // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastLogin: freezed == lastLogin
            ? _value.lastLogin
            : lastLogin // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        platform: freezed == platform
            ? _value.platform
            : platform // ignore: cast_nullable_to_non_nullable
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
class _$UserImpl implements _User {
  const _$UserImpl({
    required this.id,
    required this.username,
    required this.displayName,
    this.email,
    this.avatarImageUrl,
    this.isLoggedIn = false,
    this.bio,
    this.status,
    this.statusDescription,
    this.developerType,
    this.lastLogin,
    this.platform,
    final Map<String, dynamic>? rawApiResponse,
  }) : _rawApiResponse = rawApiResponse;

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String id;
  @override
  final String username;
  @override
  final String displayName;
  @override
  final String? email;
  @override
  final String? avatarImageUrl;
  @override
  @JsonKey()
  final bool isLoggedIn;
  @override
  final String? bio;
  @override
  final String? status;
  @override
  final String? statusDescription;
  @override
  final String? developerType;
  @override
  final DateTime? lastLogin;
  @override
  final String? platform;
  // VRChat API 원본 응답을 저장
  final Map<String, dynamic>? _rawApiResponse;
  // VRChat API 원본 응답을 저장
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
    return 'User(id: $id, username: $username, displayName: $displayName, email: $email, avatarImageUrl: $avatarImageUrl, isLoggedIn: $isLoggedIn, bio: $bio, status: $status, statusDescription: $statusDescription, developerType: $developerType, lastLogin: $lastLogin, platform: $platform, rawApiResponse: $rawApiResponse)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatarImageUrl, avatarImageUrl) ||
                other.avatarImageUrl == avatarImageUrl) &&
            (identical(other.isLoggedIn, isLoggedIn) ||
                other.isLoggedIn == isLoggedIn) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusDescription, statusDescription) ||
                other.statusDescription == statusDescription) &&
            (identical(other.developerType, developerType) ||
                other.developerType == developerType) &&
            (identical(other.lastLogin, lastLogin) ||
                other.lastLogin == lastLogin) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
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
    email,
    avatarImageUrl,
    isLoggedIn,
    bio,
    status,
    statusDescription,
    developerType,
    lastLogin,
    platform,
    const DeepCollectionEquality().hash(_rawApiResponse),
  );

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(this);
  }
}

abstract class _User implements User {
  const factory _User({
    required final String id,
    required final String username,
    required final String displayName,
    final String? email,
    final String? avatarImageUrl,
    final bool isLoggedIn,
    final String? bio,
    final String? status,
    final String? statusDescription,
    final String? developerType,
    final DateTime? lastLogin,
    final String? platform,
    final Map<String, dynamic>? rawApiResponse,
  }) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get id;
  @override
  String get username;
  @override
  String get displayName;
  @override
  String? get email;
  @override
  String? get avatarImageUrl;
  @override
  bool get isLoggedIn;
  @override
  String? get bio;
  @override
  String? get status;
  @override
  String? get statusDescription;
  @override
  String? get developerType;
  @override
  DateTime? get lastLogin;
  @override
  String? get platform; // VRChat API 원본 응답을 저장
  @override
  Map<String, dynamic>? get rawApiResponse;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) {
  return _LoginRequest.fromJson(json);
}

/// @nodoc
mixin _$LoginRequest {
  String get username => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  /// Serializes this LoginRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginRequestCopyWith<LoginRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginRequestCopyWith<$Res> {
  factory $LoginRequestCopyWith(
    LoginRequest value,
    $Res Function(LoginRequest) then,
  ) = _$LoginRequestCopyWithImpl<$Res, LoginRequest>;
  @useResult
  $Res call({String username, String password});
}

/// @nodoc
class _$LoginRequestCopyWithImpl<$Res, $Val extends LoginRequest>
    implements $LoginRequestCopyWith<$Res> {
  _$LoginRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? username = null, Object? password = null}) {
    return _then(
      _value.copyWith(
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoginRequestImplCopyWith<$Res>
    implements $LoginRequestCopyWith<$Res> {
  factory _$$LoginRequestImplCopyWith(
    _$LoginRequestImpl value,
    $Res Function(_$LoginRequestImpl) then,
  ) = __$$LoginRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String username, String password});
}

/// @nodoc
class __$$LoginRequestImplCopyWithImpl<$Res>
    extends _$LoginRequestCopyWithImpl<$Res, _$LoginRequestImpl>
    implements _$$LoginRequestImplCopyWith<$Res> {
  __$$LoginRequestImplCopyWithImpl(
    _$LoginRequestImpl _value,
    $Res Function(_$LoginRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? username = null, Object? password = null}) {
    return _then(
      _$LoginRequestImpl(
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginRequestImpl implements _LoginRequest {
  const _$LoginRequestImpl({required this.username, required this.password});

  factory _$LoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginRequestImplFromJson(json);

  @override
  final String username;
  @override
  final String password;

  @override
  String toString() {
    return 'LoginRequest(username: $username, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginRequestImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, username, password);

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      __$$LoginRequestImplCopyWithImpl<_$LoginRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginRequestImplToJson(this);
  }
}

abstract class _LoginRequest implements LoginRequest {
  const factory _LoginRequest({
    required final String username,
    required final String password,
  }) = _$LoginRequestImpl;

  factory _LoginRequest.fromJson(Map<String, dynamic> json) =
      _$LoginRequestImpl.fromJson;

  @override
  String get username;
  @override
  String get password;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TwoFactorAuthRequest _$TwoFactorAuthRequestFromJson(Map<String, dynamic> json) {
  return _TwoFactorAuthRequest.fromJson(json);
}

/// @nodoc
mixin _$TwoFactorAuthRequest {
  String get code => throw _privateConstructorUsedError;
  String get method => throw _privateConstructorUsedError;

  /// Serializes this TwoFactorAuthRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TwoFactorAuthRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TwoFactorAuthRequestCopyWith<TwoFactorAuthRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TwoFactorAuthRequestCopyWith<$Res> {
  factory $TwoFactorAuthRequestCopyWith(
    TwoFactorAuthRequest value,
    $Res Function(TwoFactorAuthRequest) then,
  ) = _$TwoFactorAuthRequestCopyWithImpl<$Res, TwoFactorAuthRequest>;
  @useResult
  $Res call({String code, String method});
}

/// @nodoc
class _$TwoFactorAuthRequestCopyWithImpl<
  $Res,
  $Val extends TwoFactorAuthRequest
>
    implements $TwoFactorAuthRequestCopyWith<$Res> {
  _$TwoFactorAuthRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TwoFactorAuthRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? code = null, Object? method = null}) {
    return _then(
      _value.copyWith(
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            method: null == method
                ? _value.method
                : method // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TwoFactorAuthRequestImplCopyWith<$Res>
    implements $TwoFactorAuthRequestCopyWith<$Res> {
  factory _$$TwoFactorAuthRequestImplCopyWith(
    _$TwoFactorAuthRequestImpl value,
    $Res Function(_$TwoFactorAuthRequestImpl) then,
  ) = __$$TwoFactorAuthRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String code, String method});
}

/// @nodoc
class __$$TwoFactorAuthRequestImplCopyWithImpl<$Res>
    extends _$TwoFactorAuthRequestCopyWithImpl<$Res, _$TwoFactorAuthRequestImpl>
    implements _$$TwoFactorAuthRequestImplCopyWith<$Res> {
  __$$TwoFactorAuthRequestImplCopyWithImpl(
    _$TwoFactorAuthRequestImpl _value,
    $Res Function(_$TwoFactorAuthRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TwoFactorAuthRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? code = null, Object? method = null}) {
    return _then(
      _$TwoFactorAuthRequestImpl(
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        method: null == method
            ? _value.method
            : method // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TwoFactorAuthRequestImpl implements _TwoFactorAuthRequest {
  const _$TwoFactorAuthRequestImpl({required this.code, required this.method});

  factory _$TwoFactorAuthRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$TwoFactorAuthRequestImplFromJson(json);

  @override
  final String code;
  @override
  final String method;

  @override
  String toString() {
    return 'TwoFactorAuthRequest(code: $code, method: $method)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TwoFactorAuthRequestImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.method, method) || other.method == method));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, method);

  /// Create a copy of TwoFactorAuthRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TwoFactorAuthRequestImplCopyWith<_$TwoFactorAuthRequestImpl>
  get copyWith =>
      __$$TwoFactorAuthRequestImplCopyWithImpl<_$TwoFactorAuthRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TwoFactorAuthRequestImplToJson(this);
  }
}

abstract class _TwoFactorAuthRequest implements TwoFactorAuthRequest {
  const factory _TwoFactorAuthRequest({
    required final String code,
    required final String method,
  }) = _$TwoFactorAuthRequestImpl;

  factory _TwoFactorAuthRequest.fromJson(Map<String, dynamic> json) =
      _$TwoFactorAuthRequestImpl.fromJson;

  @override
  String get code;
  @override
  String get method;

  /// Create a copy of TwoFactorAuthRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TwoFactorAuthRequestImplCopyWith<_$TwoFactorAuthRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return _LoginResponse.fromJson(json);
}

/// @nodoc
mixin _$LoginResponse {
  bool get success => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;
  String? get token => throw _privateConstructorUsedError;
  bool get requires2FA => throw _privateConstructorUsedError;
  List<String> get twoFactorMethods => throw _privateConstructorUsedError;
  Map<String, dynamic>? get rawApiResponse =>
      throw _privateConstructorUsedError;

  /// Serializes this LoginResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginResponseCopyWith<LoginResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginResponseCopyWith<$Res> {
  factory $LoginResponseCopyWith(
    LoginResponse value,
    $Res Function(LoginResponse) then,
  ) = _$LoginResponseCopyWithImpl<$Res, LoginResponse>;
  @useResult
  $Res call({
    bool success,
    String? message,
    User? user,
    String? token,
    bool requires2FA,
    List<String> twoFactorMethods,
    Map<String, dynamic>? rawApiResponse,
  });

  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class _$LoginResponseCopyWithImpl<$Res, $Val extends LoginResponse>
    implements $LoginResponseCopyWith<$Res> {
  _$LoginResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? user = freezed,
    Object? token = freezed,
    Object? requires2FA = null,
    Object? twoFactorMethods = null,
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
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as User?,
            token: freezed == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String?,
            requires2FA: null == requires2FA
                ? _value.requires2FA
                : requires2FA // ignore: cast_nullable_to_non_nullable
                      as bool,
            twoFactorMethods: null == twoFactorMethods
                ? _value.twoFactorMethods
                : twoFactorMethods // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            rawApiResponse: freezed == rawApiResponse
                ? _value.rawApiResponse
                : rawApiResponse // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LoginResponseImplCopyWith<$Res>
    implements $LoginResponseCopyWith<$Res> {
  factory _$$LoginResponseImplCopyWith(
    _$LoginResponseImpl value,
    $Res Function(_$LoginResponseImpl) then,
  ) = __$$LoginResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool success,
    String? message,
    User? user,
    String? token,
    bool requires2FA,
    List<String> twoFactorMethods,
    Map<String, dynamic>? rawApiResponse,
  });

  @override
  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class __$$LoginResponseImplCopyWithImpl<$Res>
    extends _$LoginResponseCopyWithImpl<$Res, _$LoginResponseImpl>
    implements _$$LoginResponseImplCopyWith<$Res> {
  __$$LoginResponseImplCopyWithImpl(
    _$LoginResponseImpl _value,
    $Res Function(_$LoginResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? user = freezed,
    Object? token = freezed,
    Object? requires2FA = null,
    Object? twoFactorMethods = null,
    Object? rawApiResponse = freezed,
  }) {
    return _then(
      _$LoginResponseImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User?,
        token: freezed == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String?,
        requires2FA: null == requires2FA
            ? _value.requires2FA
            : requires2FA // ignore: cast_nullable_to_non_nullable
                  as bool,
        twoFactorMethods: null == twoFactorMethods
            ? _value._twoFactorMethods
            : twoFactorMethods // ignore: cast_nullable_to_non_nullable
                  as List<String>,
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
class _$LoginResponseImpl implements _LoginResponse {
  const _$LoginResponseImpl({
    required this.success,
    this.message,
    this.user,
    this.token,
    this.requires2FA = false,
    final List<String> twoFactorMethods = const [],
    final Map<String, dynamic>? rawApiResponse,
  }) : _twoFactorMethods = twoFactorMethods,
       _rawApiResponse = rawApiResponse;

  factory _$LoginResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String? message;
  @override
  final User? user;
  @override
  final String? token;
  @override
  @JsonKey()
  final bool requires2FA;
  final List<String> _twoFactorMethods;
  @override
  @JsonKey()
  List<String> get twoFactorMethods {
    if (_twoFactorMethods is EqualUnmodifiableListView)
      return _twoFactorMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_twoFactorMethods);
  }

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
    return 'LoginResponse(success: $success, message: $message, user: $user, token: $token, requires2FA: $requires2FA, twoFactorMethods: $twoFactorMethods, rawApiResponse: $rawApiResponse)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.requires2FA, requires2FA) ||
                other.requires2FA == requires2FA) &&
            const DeepCollectionEquality().equals(
              other._twoFactorMethods,
              _twoFactorMethods,
            ) &&
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
    user,
    token,
    requires2FA,
    const DeepCollectionEquality().hash(_twoFactorMethods),
    const DeepCollectionEquality().hash(_rawApiResponse),
  );

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginResponseImplCopyWith<_$LoginResponseImpl> get copyWith =>
      __$$LoginResponseImplCopyWithImpl<_$LoginResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginResponseImplToJson(this);
  }
}

abstract class _LoginResponse implements LoginResponse {
  const factory _LoginResponse({
    required final bool success,
    final String? message,
    final User? user,
    final String? token,
    final bool requires2FA,
    final List<String> twoFactorMethods,
    final Map<String, dynamic>? rawApiResponse,
  }) = _$LoginResponseImpl;

  factory _LoginResponse.fromJson(Map<String, dynamic> json) =
      _$LoginResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String? get message;
  @override
  User? get user;
  @override
  String? get token;
  @override
  bool get requires2FA;
  @override
  List<String> get twoFactorMethods;
  @override
  Map<String, dynamic>? get rawApiResponse;

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginResponseImplCopyWith<_$LoginResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
