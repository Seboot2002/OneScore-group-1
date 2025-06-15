import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/user_service.dart';
import '../../models/entities/user.dart';

class SignUpController extends GetxController {
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final nicknameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  final UserService _userService = UserService();
  var isLoading = false.obs;

  void signUp() async {
    final name = nameController.text.trim();
    final lastname = lastnameController.text.trim();
    final nickname = nicknameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final repeatPassword = repeatPasswordController.text;

    if (name.isEmpty ||
        lastname.isEmpty ||
        nickname.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      Get.snackbar('Error', 'Todos los campos son obligatorios');
      return;
    }

    if (password != repeatPassword) {
      Get.snackbar('Error', 'Las contraseñas no coinciden');
      return;
    }

    if (password.length < 6) {
      Get.snackbar('Error', 'La contraseña debe tener al menos 6 caracteres');
      return;
    }

    isLoading.value = true;

    User newUser = User(
      userId: 0,
      name: name,
      lastName: lastname,
      nickname: nickname,
      mail: email,
      password: password,
      photoUrl:
          'https://www.shutterstock.com/image-vector/sakura-cherry-tree-blossom-enso-600nw-2442234723.jpg',
    );

    final response = await _userService.registerUser(newUser);

    isLoading.value = false;

    if (response.status == 200) {
      Get.snackbar(
        'Éxito',
        'Usuario registrado correctamente',
        backgroundColor: Color(0xFF524E4E),
        colorText: Colors.white,
      );

      _clearFields();

      Get.offNamed('/log-in');
    } else {
      Get.snackbar(
        'Error',
        response.body.toString(),
        backgroundColor: Color(0xFF524E4E),
        colorText: Colors.white,
      );
    }
  }

  void _clearFields() {
    nameController.clear();
    lastnameController.clear();
    nicknameController.clear();
    emailController.clear();
    passwordController.clear();
    repeatPasswordController.clear();
  }

  @override
  void onClose() {
    nameController.dispose();
    lastnameController.dispose();
    nicknameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.onClose();
  }
}
