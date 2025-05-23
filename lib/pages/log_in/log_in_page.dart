import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'log_in_controller.dart';
import '../../components/TitleWidget.dart';
import '../../components/FieldTextWidget.dart';
import '../../components/ButtonWidget.dart';

class LogInPage extends StatelessWidget {
  LogInPage({super.key});
  final LogInController control = Get.put(LogInController());

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
              margin: EdgeInsets.only(top: screenHeight * 0.10),
              width: screenWidth * 0.9,
              height: screenHeight * 0.80,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const TitleWidget(text: "OneScore"),
                    const SizedBox(height: 30),

                    // Logo
                    SizedBox(
                      width: screenWidth * 0.35,
                      height: screenWidth * 0.35,
                      child: Image.asset(
                        'assets/imgs/icon_onescore.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Usuario
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 8,
                      ),
                      child: FieldTextWidget(
                        label: 'Nickname / Correo',
                        hintText: 'Escriba aquí',
                        controller: control.mailController,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Contraseña
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 8,
                      ),
                      child: FieldTextWidget(
                        label: 'Contraseña',
                        hintText: 'Escriba aquí',
                        controller: control.passwordController,
                        obscureText: true,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Botón de inicio de sesión
                    ButtonWidget(
                      text: 'Iniciar sesión',
                      onPressed: control.logIn,
                    ),

                    const SizedBox(height: 30),

                    // Texto de registro
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sign-up');
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w200,
                            fontSize: 14,
                            color: Color(0xFF524E4E),
                          ),
                          children: const [
                            TextSpan(text: 'Crea una cuenta '),
                            TextSpan(
                              text: 'aquí',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
