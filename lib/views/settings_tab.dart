import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'api_response_view.dart';
import 'login_page.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final authState = auth.state.value;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '설정',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
        elevation: 0,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: authState.when(
        initial: () => const Center(child: Text('로그인이 필요합니다.')),
        loading: () => const Center(child: CircularProgressIndicator()),
        authenticated: (user) => _buildSettingsContent(context, user),
        requires2FA: (methods) => const Center(child: Text('2차 인증이 필요합니다.')),
        error: (message) => Center(child: Text('오류: $message')),
      ),
    );
  }

  Widget _buildSettingsContent(BuildContext context, user) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.api),
          title: const Text('VRChat API 응답 보기'),
          subtitle: const Text('로그인 시 받은 원본 데이터 확인'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ApiResponseView(user: user),
              ),
            );
          },
        ),
        const Divider(height: 1),
        ListTile(
          leading: Icon(Icons.logout, color: Colors.red[600]),
          title: Text('로그아웃', style: TextStyle(color: Colors.red[600])),
          subtitle: const Text('저장된 로그인 정보를 삭제합니다'),
          onTap: () {
            _showLogoutDialog(context);
          },
        ),
        const Divider(height: 24),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('버전'),
          subtitle: const Text('v0.1.0'),
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('앱 정보'),
          subtitle: const Text('VRChat Mobile eXperience - 친구 관리 도구'),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('정말 로그아웃하시겠습니까?\n저장된 로그인 정보가 삭제됩니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                final auth = Get.find<AuthController>();
                auth.logout();

                // 로그인 페이지로 이동
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('로그아웃'),
            ),
          ],
        );
      },
    );
  }
}
