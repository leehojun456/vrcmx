import 'package:get/get.dart';
import '../models/auth_state.dart';
import '../models/user.dart' as models;
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _auth = Get.find<AuthService>();

  final Rx<AuthState> state = const AuthState.initial().obs;

  AuthService get authService => _auth;

  Future<void> tryAutoLogin() async {
    state.value = const AuthState.loading();
    try {
      final resp = await _auth.tryAutoLogin();
      if (resp.success && resp.user != null) {
        state.value = AuthState.authenticated(resp.user!);
      } else {
        state.value = const AuthState.initial();
      }
    } catch (_) {
      state.value = const AuthState.initial();
    }
  }

  Future<void> login(String username, String password) async {
    state.value = const AuthState.loading();
    try {
      final req = models.LoginRequest(username: username, password: password);
      final resp = await _auth.login(req);
      if (resp.success && resp.user != null) {
        state.value = AuthState.authenticated(resp.user!);
      } else if (resp.message == '2FA_REQUIRED') {
        state.value = AuthState.requires2FA(resp.twoFactorMethods);
      } else {
        state.value = AuthState.error(resp.message ?? 'Login failed');
      }
    } catch (e) {
      state.value = AuthState.error('An error occurred: ${e.toString()}');
    }
  }

  Future<void> verify2FA(String code, String method) async {
    state.value = const AuthState.loading();
    try {
      final resp = await _auth.verify2FA(code, method);
      if (resp.success && resp.user != null) {
        state.value = AuthState.authenticated(resp.user!);
      } else {
        state.value = AuthState.error(
          resp.message ?? '2FA verification failed',
        );
      }
    } catch (e) {
      state.value = AuthState.error('2FA error: ${e.toString()}');
    }
  }

  Future<void> verifyTOTP(String code) async {
    state.value = const AuthState.loading();
    try {
      final resp = await _auth.verifyTOTP(code);
      if (resp.success) {
        final user = await _auth.fetchUser();
        if (user != null) {
          state.value = AuthState.authenticated(user);
        } else {
          state.value = AuthState.error('유저 정보 조회 실패');
        }
      } else {
        state.value = AuthState.error(resp.message ?? 'TOTP 인증 실패');
      }
    } catch (e) {
      state.value = AuthState.error('TOTP 인증 에러: ${e.toString()}');
    }
  }

  Future<void> verifyEmailOTP(String code) async {
    state.value = const AuthState.loading();
    try {
      final resp = await _auth.verifyEmailOTP(code);
      if (resp.success) {
        final user = await _auth.fetchUser();
        if (user != null) {
          state.value = AuthState.authenticated(user);
        } else {
          state.value = AuthState.error('유저 정보 조회 실패');
        }
      } else {
        state.value = AuthState.error(resp.message ?? 'Email OTP 인증 실패');
      }
    } catch (e) {
      state.value = AuthState.error('Email OTP 인증 에러: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    await _auth.logout();
    state.value = const AuthState.initial();
  }

  void clearError() {
    state.update((val) {
      if (val != null && val.isError) {
        state.value = const AuthState.initial();
      }
    });
  }
}
