import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/user_service.dart';
import '../../models/entities/user.dart';
import 'package:onescore/controllers/auth_controller.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();

  final UserService _userService = UserService();
  final AuthController _authController = Get.find<AuthController>();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() {
    if (_authController.user != null) {
      nameController.text = _authController.user!.name;
      lastNameController.text = _authController.user!.lastName;
      emailController.text = _authController.user!.mail;
    }
  }

  void updateProfile() async {
    final name = nameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();

    // Check if at least one field has content
    if (name.isEmpty && lastName.isEmpty && email.isEmpty) {
      Get.snackbar(
        'Error',
        'Debe completar al menos un campo para actualizar',
        backgroundColor: const Color(0xFF524E4E),
        colorText: Colors.white,
      );
      return;
    }

    // Validate email format only if email is provided
    if (email.isNotEmpty && !GetUtils.isEmail(email)) {
      Get.snackbar(
        'Error',
        'Por favor ingrese un correo válido',
        backgroundColor: const Color(0xFF524E4E),
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    // Create updated user object using current values or keeping original ones
    User updatedUser = User(
      userId: _authController.user!.userId,
      name: name.isNotEmpty ? name : _authController.user!.name,
      lastName: lastName.isNotEmpty ? lastName : _authController.user!.lastName,
      nickname: _authController.user!.nickname,
      mail: email.isNotEmpty ? email : _authController.user!.mail,
      password: _authController.user!.password,
      photoUrl: _authController.user!.photoUrl,
    );

    final response = await _userService.updateUser(
      updatedUser,
      _authController.user!,
    );

    isLoading.value = false;

    if (response.status == 200) {
      _authController.updateUserProfileWithEmail(
        name: name.isNotEmpty ? name : _authController.user!.name,
        lastName:
            lastName.isNotEmpty ? lastName : _authController.user!.lastName,
        email: email.isNotEmpty ? email : _authController.user!.mail,
      );

      // Return true to indicate success
      Get.back(result: true);

      Future.delayed(const Duration(milliseconds: 100), () {
        Get.snackbar(
          'Éxito',
          'Cambios confirmados',
          backgroundColor: const Color(0xFF524E4E),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        );
      });
    } else {
      Get.snackbar(
        'Error',
        response.body.toString(),
        backgroundColor: const Color(0xFF524E4E),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
