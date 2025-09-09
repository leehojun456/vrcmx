import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_state.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'login_page.dart';
import 'home_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    // 스플래시 화면을 최소 1초간 표시
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // 자동 로그인 시도
    await ref.read(authViewModelProvider.notifier).tryAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    // 자동 로그인 결과에 따른 페이지 전환
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      next.whenOrNull(
        initial: () {
          // 자동 로그인 실패 - 로그인 페이지로 이동
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
        authenticated: (user) {
          // 자동 로그인 성공 - 홈 화면으로 이동 (친구 탭이 기본)
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        },
      );
    });

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
              child: const Icon(
                Icons.people,
                size: 60,
                color: Colors.blue,
              ),
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
            
            // 로딩 인디케이터
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),
            
            const SizedBox(height: 16),
            
            authState.when(
              initial: () => const Text(
                'Initializing...',
                style: TextStyle(color: Colors.white),
              ),
              loading: () => const Text(
                'Checking saved session...',
                style: TextStyle(color: Colors.white),
              ),
              authenticated: (user) => Text(
                'Welcome back, ${user.displayName}!',
                style: const TextStyle(color: Colors.white),
              ),
              requires2FA: (methods) => const Text(
                'Loading...',
                style: TextStyle(color: Colors.white),
              ),
              error: (message) => const Text(
                'Loading...',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}