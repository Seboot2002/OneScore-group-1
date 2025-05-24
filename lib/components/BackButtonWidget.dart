import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottom_navigation_controller.dart';

class BackButtonWidget extends StatelessWidget {
  final String? imagePath;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onPressed; // Callback opcional para lógica adicional

  const BackButtonWidget({
    super.key,
    this.imagePath = 'assets/imgs/BackButtonImage.png',
    this.width = 20,
    this.height = 30,
    this.margin = const EdgeInsets.only(left: 10, bottom: 10),
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          // Ejecutar callback personalizado si existe
          if (onPressed != null) {
            onPressed!();
          }

          try {
            final navController = Get.find<BottomNavigationController>();

            // Obtener la ruta anterior de la pila de navegación
            if (Get.routing.previous.isNotEmpty) {
              String previousRoute = Get.routing.previous;
              int targetIndex = navController.routes.indexOf(previousRoute);

              // Si la ruta anterior está en el navbar, actualizar ANTES de retroceder
              if (targetIndex != -1) {
                navController.selectedIndex = targetIndex;
                navController.update();
              }
            }

            // Ahora retroceder
            Get.back();
          } catch (e) {
            // Si hay error, solo retroceder normalmente
            print("⚠️ Error en BackButtonWidget: $e");
            Get.back();
          }
        },
        child: Container(
          margin: margin,
          width: width,
          height: height,
          child: Image.asset(imagePath!),
        ),
      ),
    );
  }
}
