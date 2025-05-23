import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/entities/user.dart';
import '../../services/user_service.dart';
import '../../models/httpresponse/service_http_response.dart';

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
      print('Login failed: Empty fields');
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
      final ServiceHttpResponse response = await _userService.logIn(
        identifier,
        password,
      );

      print('Login response status: ${response.status}');
      print('Login response body type: ${response.body.runtimeType}');

      if (response.status == 200 && response.body is User) {
        final user = response.body as User;
        print('Login successful for user: ${user.name} ${user.lastName}');

        Get.snackbar(
          'Bienvenido',
          'Hola ${user.name}',
          backgroundColor: const Color(0xFF524E4E),
          colorText: Colors.white,
        );

        mailController.clear();
        passwordController.clear();

        Get.offNamed('/home', arguments: user);
      } else {
        print('Login failed with response: ${response.body}');
        Get.snackbar(
          'Error',
          response.body.toString(),
          backgroundColor: const Color(0xFF524E4E),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Login exception: $e');
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

  Future<void> showAvailableUsers() async {
    await _userService.debugPrintUsers();
  }

  @override
  void onClose() {
    mailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
