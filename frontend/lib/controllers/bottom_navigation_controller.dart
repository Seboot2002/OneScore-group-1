import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
// ✅ Importar el ResultsController para poder eliminarlo
import '../pages/results/results_controller.dart';

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

  // ✅ REEMPLAZAR el método navigateToPage con la versión robusta
  void navigateToPage(int index) {
    if (index >= 0 && index < routes.length) {
      selectedIndex = index;
      update();

      String targetRoute = routes[index];

      // ✅ Para rutas específicas, hacer limpieza completa
      if (targetRoute == '/searching') {
        // Limpiar TODOS los controladores relacionados con búsqueda
        try {
          if (Get.isRegistered<ResultsController>()) {
            Get.delete<ResultsController>();
            print(
              "🧹 ResultsController eliminado antes de navegar a /searching",
            );
          }
        } catch (e) {
          print("⚠️ Error al limpiar controladores: $e");
        }

        // ✅ Navegar limpiando el stack completo
        Get.offAllNamed(targetRoute);
      } else if (targetRoute == '/home') {
        // También limpiar cuando vamos a home desde resultados
        try {
          if (Get.isRegistered<ResultsController>()) {
            Get.delete<ResultsController>();
            print("🧹 ResultsController eliminado antes de navegar a /home");
          }
        } catch (e) {
          print("⚠️ Error al limpiar controladores: $e");
        }

        // Para home, usar navegación normal
        Get.toNamed(targetRoute);
      } else {
        // Para otras rutas, navegación normal
        Get.toNamed(targetRoute);
      }
    }
  }

  void handleLogout() {
    final authController = Get.find<AuthController>();
    authController.logout();
    Get.offAllNamed('/log-in');
  }

  // ✅ onItemTapped se mantiene igual - ya usa navigateToPage
  void onItemTapped(int index) {
    if (index == 4) {
      handleLogout();
    } else {
      navigateToPage(index);
    }
  }
}
