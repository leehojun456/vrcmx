import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/auth_state.dart';
import '../controllers/auth_controller.dart';
import '../widgets/vrchat_network_image.dart';
import 'api_response_view.dart';
import 'login_page.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final authState = auth.state.value;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '프로필',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: authState.when(
        initial: () => const Center(child: Text('로그인이 필요합니다.')),
        loading: () => const Center(child: CircularProgressIndicator()),
        authenticated: (user) => _buildProfileContent(context, user),
        requires2FA: (methods) => const Center(child: Text('2차 인증이 필요합니다.')),
        error: (message) => Center(child: Text('오류: $message')),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, user) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 프로필 헤더 섹션
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // 아바타와 기본 정보
                Center(
                  child: Column(
                    children: [
                      VRChatCircleAvatar(
                        radius: 60,
                        imageUrl: user.avatarImageUrl,
                        child: const Icon(Icons.person, size: 60),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.displayName,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '@${user.username}',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.id,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 세부 정보 섹션
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),

                // 상태 정보
                if (user.status != null) ...[
                  _buildDetailRow('Status', user.status!),
                  const SizedBox(height: 8),
                ],
                if (user.statusDescription != null &&
                    user.statusDescription!.isNotEmpty) ...[
                  _buildDetailRow('Status Message', user.statusDescription!),
                  const SizedBox(height: 8),
                ],

                // Bio 정보
                if (user.bio != null && user.bio!.isNotEmpty) ...[
                  _buildDetailRow('Bio', user.bio!),
                  const SizedBox(height: 8),
                ],

                // 계정 정보
                _buildDetailRow('Username', user.username),
                const SizedBox(height: 8),
                _buildDetailRow('User ID', user.id),
                const SizedBox(height: 8),

                // 이메일 정보
                if (user.email != null && user.email!.isNotEmpty) ...[
                  _buildDetailRow('Email', user.email!),
                  const SizedBox(height: 8),
                ],

                // 개발자 타입
                if (user.developerType != null &&
                    user.developerType!.isNotEmpty) ...[
                  _buildDetailRow('Developer Type', user.developerType!),
                  const SizedBox(height: 8),
                ],

                // 플랫폼 정보
                if (user.platform != null && user.platform!.isNotEmpty) ...[
                  _buildDetailRow('Platform', user.platform!),
                  const SizedBox(height: 8),
                ],

                // 마지막 로그인
                if (user.lastLogin != null) ...[
                  _buildDetailRow(
                    'Last Login',
                    _formatDateTime(user.lastLogin!),
                  ),
                  const SizedBox(height: 8),
                ],

                const SizedBox(height: 24),

                // 액션 버튼들
                const Text(
                  'Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),

                // API 응답 보기 버튼
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 8,
                    ),
                    leading: const Icon(Icons.api, color: Colors.black54),
                    title: const Text(
                      'VRChat API 응답 보기',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      '로그인 시 받은 원본 데이터 확인',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.black54,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ApiResponseView(user: user),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'monospace',
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showLogoutDialog(BuildContext context) {
    final auth = Get.find<AuthController>();
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
              onPressed: () async {
                Navigator.of(context).pop();
                await auth.logout();

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
