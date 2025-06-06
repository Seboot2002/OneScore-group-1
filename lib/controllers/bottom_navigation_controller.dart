import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class BottomNavigationController extends GetxController {
  int selectedIndex = 0;

  final List<String> routes = ['/home', '/searching', '/profile', '/suggest'];

  final List<String> excludedRoutes = ['/log-in', '/sign-up'];

  @override
  void onInit() {
    super.onInit();
    updateSelectedIndexFromRoute();

    ever(Get.routing.obs, (_) {
      String currentRoute = Get.currentRoute;
      int index = routes.indexOf(currentRoute);
      if (index != -1 && index != selectedIndex) {
        selectedIndex = index;
        update();
      }
    });
  }

  void updateSelectedIndexFromRoute() {
    String currentRoute = Get.currentRoute;
    int index = routes.indexOf(currentRoute);
    if (index != -1 && index != selectedIndex) {
      selectedIndex = index;
      update();
      print("🔄 Navbar actualizado a índice $index para ruta: $currentRoute");
    }
  }

  void updateSelectedIndex(int index) {
    if (index >= 0 && index < routes.length) {
      selectedIndex = index;
      update();
    }
  }

  bool shouldShowNavBar() {
    String currentRoute = Get.currentRoute;
    return !excludedRoutes.contains(currentRoute);
  }

  void navigateToPage(int index) {
    if (index >= 0 && index < routes.length) {
      selectedIndex = index;
      update();
      Get.toNamed(routes[index]);
    }
  }

  void handleLogout() {
    final authController = Get.find<AuthController>();
    authController.logout();

    Get.offAllNamed('/log-in');
  }

  void onItemTapped(int index) {
    if (index == 4) {
      handleLogout();
    } else {
      navigateToPage(index);
    }
  }
}
