import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/splash_screen.dart';
import 'providers/websocket_provider.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 웹소켓 자동 연결 시작
    ref.watch(webSocketAutoConnectProvider);
    
    return MaterialApp(
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
