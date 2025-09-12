import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../services/websocket_service.dart';
import '../controllers/friends_controller.dart';
import '../controllers/auth_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Core services
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<WebSocketService>(
      WebSocketService(Get.find<AuthService>()),
      permanent: true,
    );

    // Feature controllers
    Get.put<FriendsController>(FriendsController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}
