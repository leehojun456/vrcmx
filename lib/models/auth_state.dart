import 'user.dart';

enum AuthStatus { initial, loading, authenticated, requires2FA, error }

class AuthState {
  final AuthStatus status;
  final User? user;
  final List<String> methods;
  final String? message;

  const AuthState._({
    required this.status,
    this.user,
    this.methods = const [],
    this.message,
  });

  const AuthState.initial() : this._(status: AuthStatus.initial);
  const AuthState.loading() : this._(status: AuthStatus.loading);
  const AuthState.authenticated(User user)
      : this._(status: AuthStatus.authenticated, user: user);
  const AuthState.requires2FA(List<String> methods)
      : this._(status: AuthStatus.requires2FA, methods: methods);
  const AuthState.error(String message)
      : this._(status: AuthStatus.error, message: message);

  bool get isInitial => status == AuthStatus.initial;
  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isRequires2FA => status == AuthStatus.requires2FA;
  bool get isError => status == AuthStatus.error;

  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(User user) authenticated,
    required T Function(List<String> methods) requires2FA,
    required T Function(String message) error,
  }) {
    switch (status) {
      case AuthStatus.initial:
        return initial();
      case AuthStatus.loading:
        return loading();
      case AuthStatus.authenticated:
        return authenticated(user as User);
      case AuthStatus.requires2FA:
        return requires2FA(methods);
      case AuthStatus.error:
        return error(message ?? '');
    }
  }

  T? whenOrNull<T>({
    T Function()? initial,
    T Function()? loading,
    T Function(User user)? authenticated,
    T Function(List<String> methods)? requires2FA,
    T Function(String message)? error,
  }) {
    switch (status) {
      case AuthStatus.initial:
        return initial?.call();
      case AuthStatus.loading:
        return loading?.call();
      case AuthStatus.authenticated:
        return authenticated?.call(user as User);
      case AuthStatus.requires2FA:
        return requires2FA?.call(methods);
      case AuthStatus.error:
        return error?.call(message ?? '');
    }
  }
}

