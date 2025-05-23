import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/entities/user.dart';
import '../../services/log_in_service.dart';
import '../../models/httpresponse/service_http_response.dart';

class LogInController extends GetxController {
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LogInService _logInService = LogInService();

  var isLoading = false.obs;

  Future<void> logIn() async {
    isLoading.value = true;

    final mail = mailController.text.trim();
    final password = passwordController.text;

    final ServiceHttpResponse response = await _logInService.logIn(
      mail,
      password,
    );

    isLoading.value = false;

    if (response.status == 200 && response.body is User) {
      final user = response.body as User;
      Get.snackbar('Bienvenido', 'Hola ${user.name}');
      Get.offNamed('/home', arguments: user);
    } else {
      Get.snackbar(
        'Error',
        response.body.toString(),
        backgroundColor: Colors.red.shade300,
        colorText: Colors.white,
      );
    }
  }
}
