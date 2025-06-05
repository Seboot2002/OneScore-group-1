import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'edit_profile_controller.dart';
import 'package:onescore/controllers/auth_controller.dart';

class EditProfilePage extends StatelessWidget {
  EditProfileController control = Get.put(EditProfileController());

  AuthController authControl = Get.find<AuthController>();

  EditProfilePage({super.key});

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Here\'s the edit page', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Get.offNamed('/change-password', arguments: authControl.user);
              },
              child: const Text(
                'Cambiar contraseña',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: null,
        body: _buildBody(context),
      ),
    );
  }
}
