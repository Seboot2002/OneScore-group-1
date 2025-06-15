import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onescore/models/entities/user.dart';
import '../../services/user_service.dart';

class ChangePasswordController extends GetxController {
  late final User currentUser;

  final TextEditingController txtContrasenaVieja = TextEditingController();
  final TextEditingController txtContrasenaNueva = TextEditingController();
  final TextEditingController txtRepiteContrasena = TextEditingController();

  final RxString message = ''.obs;
  final UserService _userService = UserService();

  @override
  void onInit() {
    super.onInit();
    currentUser = Get.arguments as User;
  }

  void goBack(BuildContext context) {
    Get.offNamed('/profile');
  }

  Future<void> changePassword() async {
    final contrasenaVieja = txtContrasenaVieja.text.trim();
    final contrasenaNueva = txtContrasenaNueva.text.trim();
    final repiteContrasena = txtRepiteContrasena.text.trim();

    if (contrasenaVieja.isEmpty ||
        contrasenaNueva.isEmpty ||
        repiteContrasena.isEmpty) {
      Get.snackbar(
        'Error',
        'Favor de llenar todos los campos',
        backgroundColor: const Color(0xFF524E4E),
        colorText: Colors.white,
      );
      return;
    }

    if (contrasenaNueva != repiteContrasena) {
      Get.snackbar(
        'Error',
        'Contraseñas no coinciden',
        backgroundColor: const Color(0xFF524E4E),
        colorText: Colors.white,
      );
      return;
    }

    try {
      final response = await _userService.changePassword(
        usuario: currentUser,
        currentPassword: contrasenaVieja,
        newPassword: contrasenaNueva,
      );

      if (response.status == 200) {
        Get.snackbar(
          'Operación exitosa',
          'Cambio de contraseña efectuado',
          backgroundColor: const Color(0xFF524E4E),
          colorText: Colors.white,
        );
        Get.offNamed('/profile');
      } else {
        Get.snackbar(
          'Error',
          'Cambio de contraseña negado',
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
    }
  }
}
