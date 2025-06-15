import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottom_navigation_controller.dart';

class BackButtonWidget extends StatelessWidget {
  final String? imagePath;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onPressed;

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
          if (onPressed != null) {
            onPressed!();
          }

          try {
            final navController = Get.find<BottomNavigationController>();

            if (Get.routing.previous.isNotEmpty) {
              String previousRoute = Get.routing.previous;
              int targetIndex = navController.routes.indexOf(previousRoute);

              if (targetIndex != -1) {
                navController.selectedIndex = targetIndex;
                navController.update();
              }
            }

            Get.back();
          } catch (e) {
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
