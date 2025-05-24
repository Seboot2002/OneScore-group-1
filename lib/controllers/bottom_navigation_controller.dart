import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class BottomNavigationController extends GetxController {
  int selectedIndex = 0;

  // Lista de rutas que corresponden a cada índice del navbar
  final List<String> routes = ['/home', '/searching', '/profile', '/suggest'];

  // Rutas donde NO debe aparecer el navbar
  final List<String> excludedRoutes = ['/log-in', '/sign-up'];

  @override
  void onInit() {
    super.onInit();
    // Detectar la ruta actual al inicializar
    updateSelectedIndexFromRoute();

    // Agregar listener para detectar cambios de ruta automáticamente
    // (pero solo para navegación hacia adelante, no hacia atrás)
    ever(Get.routing.obs, (_) {
      String currentRoute = Get.currentRoute;
      int index = routes.indexOf(currentRoute);
      if (index != -1 && index != selectedIndex) {
        // Solo actualizar si es diferente al actual
        selectedIndex = index;
        update();
      }
    });
  }

  // Actualizar el índice basado en la ruta actual (ahora público)
  void updateSelectedIndexFromRoute() {
    String currentRoute = Get.currentRoute;
    int index = routes.indexOf(currentRoute);
    if (index != -1 && index != selectedIndex) {
      selectedIndex = index;
      update();
      print("🔄 Navbar actualizado a índice $index para ruta: $currentRoute");
    }
  }

  // Método para actualizar el índice desde cualquier página
  void updateSelectedIndex(int index) {
    if (index >= 0 && index < routes.length) {
      selectedIndex = index;
      update();
    }
  }

  // Verificar si el navbar debe mostrarse en la ruta actual
  bool shouldShowNavBar() {
    String currentRoute = Get.currentRoute;
    return !excludedRoutes.contains(currentRoute);
  }

  // Navegar a una página específica
  void navigateToPage(int index) {
    if (index >= 0 && index < routes.length) {
      selectedIndex = index;
      update();
      Get.toNamed(routes[index]);
    }
  }

  // Función especial para logout (último ítem del navbar)
  void handleLogout() {
    // Usar el AuthController para hacer logout
    final authController = Get.find<AuthController>();
    authController.logout();

    // Limpiar toda la pila de navegación y ir al login
    Get.offAllNamed('/log-in');
  }

  // Manejar el tap en cada ítem del navbar
  void onItemTapped(int index) {
    // Si es el último ítem (índice 4), hacer logout
    if (index == 4) {
      handleLogout();
    } else {
      navigateToPage(index);
    }
  }
}
