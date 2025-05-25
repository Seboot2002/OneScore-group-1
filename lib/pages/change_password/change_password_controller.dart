
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onescore/models/entities/user.dart';
import '../../services/user_service.dart';

class ChangePasswordController extends GetxController {
  late final User currentUser;
  @override
  void onInit() {
    super.onInit();
    currentUser = Get.arguments as User;
  }
  final TextEditingController txtContrasenaVieja = TextEditingController();
  final TextEditingController txtContrasenaNueva = TextEditingController();
  final TextEditingController txtRepiteContrasena = TextEditingController();

  final RxString message = ''.obs;

  final UserService _userService = UserService();

  // Asumimos que tienes el nickname o email disponible (por ejemplo desde sesión)
  String emailOrNickname = ''; // <-- debes asignarlo desde sesión o login

  goBack (BuildContext context){
    Navigator.pushNamed(context, '/profile', arguments:currentUser );
  }

  Future<void> changePassword() async {
    final contrasenaVieja = txtContrasenaVieja.text.trim();
    final contrasenaNueva = txtContrasenaNueva.text.trim();
    final repiteContrasena = txtRepiteContrasena.text.trim();

    if (contrasenaVieja.isEmpty || contrasenaNueva.isEmpty || repiteContrasena.isEmpty) {
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
          'Operacion exitosa',
          'Cambio de contraseña efectuado',
          backgroundColor: const Color(0xFF524E4E),
          colorText: Colors.white,
        );

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
