import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String username,
    required String displayName,
    String? email,
    String? avatarImageUrl,
    @Default(false) bool isLoggedIn,
    String? bio,
    String? status,
    String? statusDescription,
    String? developerType,
    DateTime? lastLogin,
    String? platform,
    // VRChat API 원본 응답을 저장
    Map<String, dynamic>? rawApiResponse,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String username,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
}

@freezed
class TwoFactorAuthRequest with _$TwoFactorAuthRequest {
  const factory TwoFactorAuthRequest({
    required String code,
    required String method, // 'totp', 'email', 'recovery'
  }) = _TwoFactorAuthRequest;

  factory TwoFactorAuthRequest.fromJson(Map<String, dynamic> json) => 
      _$TwoFactorAuthRequestFromJson(json);
}

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required bool success,
    String? message,
    User? user,
    String? token,
    @Default(false) bool requires2FA,
    @Default([]) List<String> twoFactorMethods,
    Map<String, dynamic>? rawApiResponse,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
}