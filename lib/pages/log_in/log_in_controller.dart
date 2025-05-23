import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogInController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() {
    final username = usernameController.text;
    final password = passwordController.text;

    // Aquí iría la lógica de autenticación
    print("Username: $username");
    print("Password: $password");
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
