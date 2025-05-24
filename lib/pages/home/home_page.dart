import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../components/BottomNavigationBar.dart';
import '../../controllers/bottom_navigation_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  Widget _buildWelcomeSection() {
    return GetBuilder<AuthController>(
      builder: (authController) {
        if (!authController.isLoggedIn) {
          return const SizedBox.shrink();
        }
        final user = authController.user!;
        return Column(
          children: [
            const SizedBox(height: 20),
            if (user.photoUrl.isNotEmpty)
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user.photoUrl),
              ),
            const SizedBox(height: 16),
            Text(
              '¡Bienvenido a OneScore!',
              style: Get.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${user.name} ${user.lastName}',
              style: Get.textTheme.titleMedium,
            ),
            Text(
              '@${user.nickname}',
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildWelcomeSection(),
            // Resto de tu contenido...
            const Text('Página de inicio de OneScore'),
            const SizedBox(height: 80), // Espacio para el navbar
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Asegurar que el navbar muestre el home como seleccionado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navController = Get.find<BottomNavigationController>();
      navController.updateSelectedIndex(0); // 0 = home
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildBody(context),
      bottomNavigationBar: const CustomMenuBar(),
    );
  }
}
