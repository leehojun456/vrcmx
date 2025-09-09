import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_state.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'api_response_view.dart';
import 'login_page.dart';

class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: authState.when(
        initial: () => const Center(
          child: Text('로그인이 필요합니다.'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        authenticated: (user) => _buildSettingsContent(context, ref, user),
        requires2FA: (methods) => const Center(
          child: Text('2차 인증이 필요합니다.'),
        ),
        error: (message) => Center(
          child: Text('오류: $message'),
        ),
      ),
    );
  }

  Widget _buildSettingsContent(BuildContext context, WidgetRef ref, user) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 사용자 정보 카드
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    if (user.avatarImageUrl != null)
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(user.avatarImageUrl!),
                        onBackgroundImageError: (_, __) {},
                      )
                    else
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue[200],
                        child: const Icon(Icons.person, size: 30, color: Colors.white),
                      ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.displayName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user.username,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (user.id.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              'ID: ${user.id}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // 설정 메뉴들
        const Text(
          '계정',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        Card(
          child: Column(
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
                title: Text(
                  '로그아웃',
                  style: TextStyle(color: Colors.red[600]),
                ),
                subtitle: const Text('저장된 로그인 정보를 삭제합니다'),
                onTap: () {
                  _showLogoutDialog(context, ref);
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          '앱 정보',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        Card(
          child: Column(
            children: [
              const ListTile(
                leading: Icon(Icons.info),
                title: Text('버전'),
                subtitle: Text('v0.1.0'),
              ),
              const Divider(height: 1),
              const ListTile(
                leading: Icon(Icons.description),
                title: Text('앱 정보'),
                subtitle: Text('VRChat Mobile eXperience - 친구 관리 도구'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
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
                ref.read(authViewModelProvider.notifier).logout();
                
                // 로그인 페이지로 이동
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('로그아웃'),
            ),
          ],
        );
      },
    );
  }
}