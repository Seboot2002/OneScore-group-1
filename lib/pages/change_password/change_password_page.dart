import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onescore/components/BackButtonWidget.dart';
import 'package:onescore/components/ButtonWidget.dart';
import 'package:onescore/components/FieldTextWidget.dart';
import 'change_password_controller.dart';

class ChangePasswordPage extends StatelessWidget {
  final ChangePasswordController controller = Get.put(
    ChangePasswordController(),
  );

  ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackButtonWidget(
                onPressed: () => controller.goBack(context), // ✅ Importante
                width: 25,
                height: 25,
              ),
              const SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Edición',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 98,
                      child: Image.asset(
                        'assets/imgs/icon_password.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FieldTextWidget(
                      label: 'Contraseña Antigua',
                      controller: controller.txtContrasenaVieja,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    FieldTextWidget(
                      label: 'Contraseña Nueva',
                      controller: controller.txtContrasenaNueva,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    FieldTextWidget(
                      label: 'Repetir Contraseña Nueva',
                      controller: controller.txtRepiteContrasena,
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),
                    ButtonWidget(
                      text: 'Guardar Cambios',
                      onPressed: controller.changePassword,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
