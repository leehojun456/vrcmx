class User {
  final String id;
  final String username;
  final String displayName;
  final String? email;
  final String? avatarImageUrl;
  final bool isLoggedIn;
  final String? bio;
  final String? status;
  final String? statusDescription;
  final String? developerType;
  final DateTime? lastLogin;
  final String? platform;
  final Map<String, dynamic>? rawApiResponse;

  const User({
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
    this.rawApiResponse,
  });
}

class LoginRequest {
  final String username;
  final String password;
  const LoginRequest({required this.username, required this.password});
}

class LoginResponse {
  final bool success;
  final String? message;
  final User? user;
  final String? token;
  final bool requires2FA;
  final List<String> twoFactorMethods;
  final Map<String, dynamic>? rawApiResponse;

  const LoginResponse({
    required this.success,
    this.message,
    this.user,
    this.token,
    this.requires2FA = false,
    this.twoFactorMethods = const [],
    this.rawApiResponse,
  });
}

