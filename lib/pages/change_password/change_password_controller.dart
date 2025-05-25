import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:onescore/models/entities/user.dart';
import 'package:onescore/models/httpResponse/service_http_response.dart';
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

  void changePassword(BuildContext context) async {
    final contrasenaVieja = txtContrasenaVieja.text.trim();
    final contrasenaNueva = txtContrasenaNueva.text.trim();
    final repiteContrasena = txtRepiteContrasena.text.trim();

    if (contrasenaVieja.isEmpty || contrasenaNueva.isEmpty || repiteContrasena.isEmpty) {
      message.value = 'Favor de llenar todos los campos';
      return;
    }

    if (contrasenaNueva != repiteContrasena) {
      message.value = 'Las contraseñas nuevas no coinciden';
      return;
    }

    try {
      final response = await _userService.changePassword(
        usuario: currentUser,
        currentPassword: contrasenaVieja,
        newPassword: contrasenaNueva,
      );

      if (response.status == 200) {
        message.value = 'Cambio de contraseña efectuado';
      } else {
        message.value = response.body ?? 'Cambio de contraseña negado';
      }
    } catch (e) {
      message.value = 'Error al cambiar la contraseña: $e';
    }
  }
}
