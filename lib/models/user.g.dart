// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: json['id'] as String,
  username: json['username'] as String,
  displayName: json['displayName'] as String,
  email: json['email'] as String?,
  avatarImageUrl: json['avatarImageUrl'] as String?,
  isLoggedIn: json['isLoggedIn'] as bool? ?? false,
  bio: json['bio'] as String?,
  status: json['status'] as String?,
  statusDescription: json['statusDescription'] as String?,
  developerType: json['developerType'] as String?,
  lastLogin: json['lastLogin'] == null
      ? null
      : DateTime.parse(json['lastLogin'] as String),
  platform: json['platform'] as String?,
  rawApiResponse: json['rawApiResponse'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'displayName': instance.displayName,
      'email': instance.email,
      'avatarImageUrl': instance.avatarImageUrl,
      'isLoggedIn': instance.isLoggedIn,
      'bio': instance.bio,
      'status': instance.status,
      'statusDescription': instance.statusDescription,
      'developerType': instance.developerType,
      'lastLogin': instance.lastLogin?.toIso8601String(),
      'platform': instance.platform,
      'rawApiResponse': instance.rawApiResponse,
    };

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(
      username: json['username'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$LoginRequestImplToJson(_$LoginRequestImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

_$TwoFactorAuthRequestImpl _$$TwoFactorAuthRequestImplFromJson(
  Map<String, dynamic> json,
) => _$TwoFactorAuthRequestImpl(
  code: json['code'] as String,
  method: json['method'] as String,
);

Map<String, dynamic> _$$TwoFactorAuthRequestImplToJson(
  _$TwoFactorAuthRequestImpl instance,
) => <String, dynamic>{'code': instance.code, 'method': instance.method};

_$LoginResponseImpl _$$LoginResponseImplFromJson(Map<String, dynamic> json) =>
    _$LoginResponseImpl(
      success: json['success'] as bool,
      message: json['message'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String?,
      requires2FA: json['requires2FA'] as bool? ?? false,
      twoFactorMethods:
          (json['twoFactorMethods'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      rawApiResponse: json['rawApiResponse'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$LoginResponseImplToJson(_$LoginResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'user': instance.user,
      'token': instance.token,
      'requires2FA': instance.requires2FA,
      'twoFactorMethods': instance.twoFactorMethods,
      'rawApiResponse': instance.rawApiResponse,
    };
