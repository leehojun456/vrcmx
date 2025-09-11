import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/auth_state.dart';
import '../controllers/auth_controller.dart';
import 'home_screen.dart';

class TwoFactorPage extends StatefulWidget {
  final List<String> availableMethods;
  final String? initialMethod;

  const TwoFactorPage({
    super.key,
    required this.availableMethods,
    this.initialMethod,
  });

  @override
  State<TwoFactorPage> createState() => _TwoFactorPageState();
}

class _TwoFactorPageState extends State<TwoFactorPage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  late final AuthController _auth;
  Worker? _worker;

  @override
  void initState() {
    super.initState();
    _auth = Get.find<AuthController>();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _worker?.dispose();
    super.dispose();
  }

  void _handle2FA() {
    if (_formKey.currentState?.validate() ?? false) {
      final code = _controllers.map((c) => c.text).join();
      final method = (widget.initialMethod ?? 'totp').toLowerCase();
      switch (method) {
        case 'email':
          _auth.verifyEmailOTP(code);
        case 'emailotp':
          // 이메일/OTP 인증 처리
          _auth.verifyEmailOTP(code);
        case 'otp':
          _auth.verifyTOTP(code);
          break;
        case 'totp':
          _auth.verifyTOTP(code);
        case 'recovery':
          // 복구코드 인증 처리
          //_auth.verifyRecoveryCode(code);
          break;
        default:
          // 기본 인증 처리(기존 방식)
          _auth.verify2FA(code, method);
      }
    }
  }

  String _getMethodDescription(String method) {
    switch (method.toLowerCase()) {
      case 'totp':
      case 'authenticator':
        return '인증 앱에서 생성된 6자리 코드를 입력하세요';
      case 'otp':
        return '인증 앱에서 생성된 6자리 코드를 입력하세요';
      case 'emailotp':
      case 'email':
        return '이메일로 받은 인증번호 6자리를 입력하세요';
      case 'recovery':
        return '복구 코드를 입력하세요';
      default:
        return '인증번호를 입력하세요';
    }
  }

  @override
  Widget build(BuildContext context) {
    _worker ??= ever<AuthState>(_auth.state, (next) {
      next.when(
        initial: () {},
        loading: () {},
        authenticated: (user) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        },
        requires2FA: (methods) {},
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red),
          );
        },
      );
    });

    final authState = _auth.state.value;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'VRC',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 48,
                            ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(color: Colors.black),
                        child: Text(
                          'MX',
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 48,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '인증번호 6자리를 입력하세요',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getMethodDescription(widget.initialMethod ?? 'totp'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (i) {
                      return Container(
                        width: 44,
                        height: 48,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: TextFormField(
                          controller: _controllers[i],
                          focusNode: _focusNodes[i],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey[400]!,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey[400]!,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.blue[700]!,
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged: (v) {
                            if (v.isNotEmpty && i < 5) {
                              _focusNodes[i + 1].requestFocus();
                            } else if (v.isEmpty && i > 0) {
                              _focusNodes[i - 1].requestFocus();
                            }
                          },
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return '';
                            }
                            if (!RegExp(r'^[0-9]$').hasMatch(v)) {
                              return '';
                            }
                            return null;
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  authState.when(
                    initial: () => _buildSubmitButton(),
                    loading: () => _buildLoadingButton(),
                    authenticated: (user) => _buildSubmitButton(),
                    requires2FA: (methods) => _buildSubmitButton(),
                    error: (message) => _buildSubmitButton(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _handle2FA,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      child: const Text(
        '인증하기',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLoadingButton() {
    return ElevatedButton(
      onPressed: null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[400],
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(width: 12),
          Text('인증 중...', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
