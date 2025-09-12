import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/friends_controller.dart';
import 'friends_tab.dart';
import 'profile_tab.dart';
import 'settings_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  Timer? _refreshTimer; // debouncing용 타이머

  @override
  void initState() {
    super.initState();
    // 앱 시작 시 친구 목록 초기 로딩
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final friendsController = Get.find<FriendsController>();
      friendsController.bootstrap();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel(); // 타이머 정리
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthController>().authService;

    final List<Widget> pages = [
      FriendsTab(authService: authService),
      const ProfileTab(),
      const SettingsTab(),
    ];

    return Scaffold(
      extendBody: false,
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: SafeArea(
        top: false,
        bottom: true,
        child: Container(
          color: Colors.white,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });

              // 친구 탭(index 0)으로 전환될 때마다 친구 리스트 새로고침
              if (index == 0) {
                final friendsController = Get.find<FriendsController>();

                // 이미 로딩 중이거나 쿨다운 중이면 새로고침 하지 않음
                if (friendsController.loading.value ||
                    !friendsController.canRefresh.value) {
                  // .value 추가
                  print('새로고침이 불가능한 상태입니다.');
                  return;
                }

                // 기존 타이머 취소
                _refreshTimer?.cancel();

                // 300ms 후에 새로고침 실행 (debouncing)
                _refreshTimer = Timer(const Duration(milliseconds: 300), () {
                  // 다시 한 번 로딩 상태 및 쿨다운 확인
                  if (!friendsController.loading.value &&
                      friendsController.canRefresh.value) {
                    // .value 추가
                    print('친구 탭 클릭으로 새로고침 실행');
                    friendsController.refreshFriends();
                  } else {
                    print('타이머 실행 시점에 새로고침 조건이 맞지 않습니다.');
                  }
                });
              }
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue[700],
            unselectedItemColor: Colors.grey[600],
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.people), label: '친구'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
            ],
          ),
        ),
      ),
    );
  }
}
