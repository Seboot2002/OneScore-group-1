import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sign_up_controller.dart';
import '../../components/TitleWidget.dart';
import '../../components/FieldTextWidget.dart';
import '../../components/ButtonWidget.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  final SignUpController control = Get.put(SignUpController());

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
              height: screenHeight * 0.90,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, bottom: 10),
                          width: 20,
                          height: 30,
                          child: Image.asset('assets/imgs/BackButtonImage.png'),
                        ),
                      ),
                    ),

                    const TitleWidget(text: "OneScore"),
                    const SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 8,
                      ),
                      child: FieldTextWidget(
                        label: 'Nombre',
                        hintText: 'Escriba aquí',
                        controller: control.nameController,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 8,
                      ),
                      child: FieldTextWidget(
                        label: 'Apellido',
                        hintText: 'Escriba aquí',
                        controller: control.lastnameController,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 8,
                      ),
                      child: FieldTextWidget(
                        label: 'Nickname',
                        hintText: 'Escriba aquí',
                        controller: control.nicknameController,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 8,
                      ),
                      child: FieldTextWidget(
                        label: 'Correo',
                        hintText: 'ejemplo@correo.com',
                        controller: control.emailController,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 8,
                      ),
                      child: FieldTextWidget(
                        label: 'Contraseña',
                        hintText: 'Mínimo 6 caracteres',
                        obscureText: true,
                        controller: control.passwordController,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 8,
                      ),
                      child: FieldTextWidget(
                        label: 'Repetir contraseña',
                        hintText: 'Confirma tu contraseña',
                        obscureText: true,
                        controller: control.repeatPasswordController,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Obx(
                      () =>
                          control.isLoading.value
                              ? const CircularProgressIndicator()
                              : ButtonWidget(
                                text: 'Registrarse',
                                onPressed: control.signUp,
                              ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
