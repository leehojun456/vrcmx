import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vrcmx/models/auth_state.dart';
import '../controllers/auth_controller.dart';
import 'login_page.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final AuthController _auth;
  Worker? _worker;
  @override
  void initState() {
    super.initState();
    _auth = Get.find<AuthController>();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    // 스플래시 화면을 최소 1초간 표시
    await Future.delayed(const Duration(milliseconds: 1000));
    // 자동 로그인 시도
    _worker ??= ever<AuthState>(_auth.state, (next) {
      if (!mounted) return;
      next.whenOrNull(
        initial: () {
          // 자동 로그인 실패 - 로그인 페이지로 이동
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        },
        authenticated: (user) {
          // 자동 로그인 성공 - 홈 화면으로 이동 (친구 탭이 기본)
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        },
      );
    });

    await _auth.tryAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    final authState = _auth.state.value;

    return Scaffold(
      backgroundColor: Colors.blue[700],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // VRCMX 로고
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(Icons.people, size: 60, color: Colors.blue),
            ),

            const SizedBox(height: 32),

            // 앱 이름
            const Text(
              'VRCMX',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'VRChat Mobile eXperience',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
