import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onescore/components/BackButtonWidget.dart';
import 'package:onescore/components/ButtonWidget.dart';
import 'package:onescore/components/FieldTextWidget.dart';
import 'package:onescore/components/TitleWidget.dart';
import 'package:onescore/components/BottomNavigationBar.dart';
import 'change_password_controller.dart';

class ChangePasswordPage extends StatelessWidget {
  final ChangePasswordController controller = Get.put(
    ChangePasswordController(),
  );

  ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Center(
            child: Container(
              margin: EdgeInsets.only(top: screenHeight * 0.05),
              width: screenWidth * 0.9,
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      // Back button alineado a la izquierda
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => controller.goBack(context),
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, bottom: 10),
                            width: 20,
                            height: 30,
                            child: Image.asset(
                              'assets/imgs/BackButtonImage.png',
                            ),
                          ),
                        ),
                      ),

                      const TitleWidget(text: "Edición"),

                      SizedBox(
                        width: screenWidth * 0.35,
                        height: screenHeight * 0.25,
                        child: Image.asset(
                          'assets/imgs/icon_password.png',
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: FieldTextWidget(
                          label: 'Contraseña antigua',
                          hintText: '{ Escribe aquí }',
                          controller: controller.txtContrasenaVieja,
                          obscureText: true,
                        ),
                      ),

                      const SizedBox(height: 30), // Espaciado entre campos
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: FieldTextWidget(
                          label: 'Contraseña nueva',
                          hintText: '{ Escribe aquí }',
                          controller: controller.txtContrasenaNueva,
                          obscureText: true,
                        ),
                      ),

                      const SizedBox(height: 30), // Espaciado entre campos
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: FieldTextWidget(
                          label: 'Repetir contraseña nueva',
                          hintText: '{ Escribe aquí }',
                          controller: controller.txtRepiteContrasena,
                          obscureText: true,
                        ),
                      ),

                      const SizedBox(height: 40),

                      ButtonWidget(
                        text: 'Guardar cambios',
                        onPressed: controller.changePassword,
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomMenuBar(),
    );
  }
}
