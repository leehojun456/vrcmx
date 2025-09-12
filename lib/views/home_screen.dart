import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
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
