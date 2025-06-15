import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart'; // Importa el AuthController
import '../../models/entities/user.dart';
import '../../services/user_service.dart';

class LogInController extends GetxController {
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserService _userService = UserService();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _debugShowUsers();
  }

  Future<void> _debugShowUsers() async {
    print('=== DEBUG: Showing all users on controller init ===');
    await _userService.debugPrintUsers();
  }

  Future<void> logIn() async {
    final identifier = mailController.text.trim();
    final password = passwordController.text;

    print('=== LOGIN ATTEMPT ===');
    print('Identifier: "$identifier"');
    print('Password: "$password"');

    if (identifier.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Por favor ingresa tu email/nickname y contraseña',
        backgroundColor: const Color(0xFF524E4E),
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _userService.logIn(identifier, password);

      if (response.status == 200 && response.body is User) {
        final user = response.body as User;

        AuthController.to.login(user);

        Get.snackbar(
          'Bienvenido',
          'Hola ${user.name}',
          backgroundColor: const Color(0xFF524E4E),
          colorText: Colors.white,
        );

        mailController.clear();
        passwordController.clear();

        Get.offNamed('/home');
      } else {
        Get.snackbar(
          'Error',
          response.body.toString(),
          backgroundColor: const Color(0xFF524E4E),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error inesperado: $e',
        backgroundColor: const Color(0xFF524E4E),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    mailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
