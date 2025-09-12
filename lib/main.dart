import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/splash_screen.dart';
import 'bindings/app_bindings.dart';
import 'services/push_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 로컬 알림 채널 초기화만 수행 (FCM 미사용)
  await PushService().init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // GetX 초기 바인딩 (AuthService, WebSocketService, FriendsController)
    return GetMaterialApp(
      initialBinding: AppBindings(),
      title: 'VRCMX',
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
        canvasColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        dialogTheme: DialogThemeData(backgroundColor: Colors.white),
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.black54,
          surface: Colors.white,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
