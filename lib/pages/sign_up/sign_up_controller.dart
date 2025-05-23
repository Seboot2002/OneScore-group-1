import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/sign_up_service.dart';
import '../../models/entities/user.dart';

class SignUpController extends GetxController {
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final nicknameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  void signUp() async {
    final name = nameController.text.trim();
    final lastname = lastnameController.text.trim();
    final nickname = nicknameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final repeatPassword = repeatPasswordController.text;

    if (password != repeatPassword) {
      Get.snackbar('Error', 'Las contraseñas no coinciden');
      return;
    }

    User newUser = User(
      name: name,
      lastName: lastname,
      nickname: nickname,
      mail: email,
      password: password,
    );

    final response = await SignUpService().registerUser(newUser);

    if (response.status == 200) {
      Get.snackbar('Éxito', 'Usuario registrado correctamente');
      Get.offNamed('/log-in');
    } else {
      Get.snackbar('Error', 'No se pudo registrar el usuario');
    }
  }
}
