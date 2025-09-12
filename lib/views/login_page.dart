import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vrcmx/models/auth_state.dart';
import '../controllers/auth_controller.dart';
import 'two_factor_page.dart';
import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late final AuthController _auth;
  Worker? _worker;

  @override
  void initState() {
    super.initState();
    _auth = Get.find<AuthController>();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _worker?.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      _auth.login(_usernameController.text.trim(), _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    _worker ??= ever<AuthState>(_auth.state, (next) {
      next.when(
        initial: () {},
        loading: () {},
        authenticated: (user) {
          // 로그인 성공 시 홈 화면으로 이동 (친구 리스트는 친구 탭에서 로드)
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        },
        requires2FA: (methods) {
          String selected;
          if (methods.length == 1) {
            selected = methods.first;
          } else if (methods.contains('otp')) {
            selected = 'otp';
          } else if (methods.contains('emailOtp')) {
            selected = 'emailOtp';
          } else {
            selected = methods.first;
          }
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TwoFactorPage(
                availableMethods: methods,
                initialMethod: selected,
              ),
            ),
          );
        },
        error: (message) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      resizeToAvoidBottomInset: true,
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    final authState = _auth.state.value;

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight:
              MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 상단 여백 (빈 박스)
              const SizedBox(height: 40),

              // 중간: 로고 + 입력 박스 그룹
              Column(
                children: [
                  // 로고 섹션
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'VRC',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 72,
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
                                fontSize: 72,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'VRChat Mobile eXperience',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.left,
                  ),

                  // 폼 섹션
                  const SizedBox(height: 72),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: WidgetStateTextStyle.resolveWith((
                              states,
                            ) {
                              if (states.contains(WidgetState.focused)) {
                                return const TextStyle(color: Colors.black);
                              }
                              return TextStyle(color: Colors.grey[400]);
                            }),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.grey[400],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[400]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[400]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIconColor: Colors.grey[400],
                            focusColor: Colors.black,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '아이디를 입력하세요';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: WidgetStateTextStyle.resolveWith((
                              states,
                            ) {
                              if (states.contains(WidgetState.focused)) {
                                return const TextStyle(color: Colors.black);
                              }
                              return TextStyle(color: Colors.grey[400]);
                            }),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.grey[400],
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey[400],
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[400]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[400]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIconColor: Colors.grey[400],
                            focusColor: Colors.black,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '비밀번호를 입력하세요';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _handleLogin(),
                        ),
                        const SizedBox(height: 24),
                        authState.when(
                          initial: () => _buildLoginButton(),
                          loading: () => _buildLoadingButton(),
                          authenticated: (user) => _buildLoginButton(),
                          requires2FA: (methods) => _buildLoginButton(),
                          error: (message) => _buildLoginButton(),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => _auth.clearError(),
                          child: const Text('Forgot Password?'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // 하단 안내문
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 12,
                ),
                child: Text(
                  'VRCMX는 친구 관계에 도움을 줄 만한 정보를 \n제공하는 보조 어플리케이션입니다.\n\nVRChat은 VRChat Inc.의 상표입니다. VRChat © VRChat Inc',
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0, // 그림자 제거
        shadowColor: Colors.transparent, // 그림자 완전 제거
      ),
      child: const Text(
        'Login',
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
          Text('Logging in...', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
