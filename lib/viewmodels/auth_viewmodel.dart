import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/auth_state.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

part 'auth_viewmodel.g.dart';

@riverpod
AuthService authService(AuthServiceRef ref) {
  return AuthService();
}

@riverpod
class AuthViewModel extends _$AuthViewModel {
  AuthService? _authService; // AuthService 인스턴스 유지

  @override
  AuthState build() {
    return const AuthState.initial();
  }

  AuthService get authService {
    _authService ??= AuthService();
    return _authService!;
  }

  Future<void> login(String username, String password) async {
    state = const AuthState.loading();
    
    final request = LoginRequest(username: username, password: password);
    
    try {
      final response = await authService.login(request);
      
      if (response.success && response.user != null) {
        state = AuthState.authenticated(response.user!);
      } else if (response.message == '2FA_REQUIRED') {
        state = AuthState.requires2FA(response.twoFactorMethods);
      } else {
        state = AuthState.error(response.message ?? 'Login failed');
      }
    } catch (e) {
      state = AuthState.error('An error occurred: ${e.toString()}');
    }
  }

  Future<void> tryAutoLogin() async {
    state = const AuthState.loading();
    
    try {
      final response = await authService.tryAutoLogin();
      
      if (response.success && response.user != null) {
        state = AuthState.authenticated(response.user!);
      } else {
        state = const AuthState.initial();
      }
    } catch (e) {
      state = const AuthState.initial();
    }
  }

  Future<void> verify2FA(String code, String method) async {
    state = const AuthState.loading();
    
    try {
      final response = await authService.verify2FA(code, method);
      
      if (response.success && response.user != null) {
        state = AuthState.authenticated(response.user!);
      } else {
        state = AuthState.error(response.message ?? '2FA verification failed');
      }
    } catch (e) {
      state = AuthState.error('2FA error: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    await authService.logout();
    _authService = null; // AuthService 인스턴스 초기화
    state = const AuthState.initial();
  }

  void clearError() {
    state.whenOrNull(
      error: (_) => state = const AuthState.initial(),
    );
  }
}