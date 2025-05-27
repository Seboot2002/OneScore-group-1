import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onescore/components/BackButtonWidget.dart';
import 'package:onescore/components/ButtonWidget.dart';
import 'package:onescore/components/FieldTextWidget.dart';
import 'change_password_controller.dart';

class ChangePasswordPage extends StatelessWidget {
  
  final ChangePasswordController controller = Get.put(ChangePasswordController());

  ChangePasswordPage({super.key});

  Widget _buildBody(BuildContext context) {

    return SafeArea(child: Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: (
            BackButtonWidget(
              onPressed:controller.goBack(context),
              width: 25,
              height: 25,
            )
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Align(
          alignment: Alignment.center,
          child: (
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(
                'Edición', 
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 98,
                child:SizedBox(
                  width: 122,
                  height: 98,
                  child: Image.asset('assets/icon_password.png',
                  fit: BoxFit.cover,),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FieldTextWidget(
                label:'Contraseña Antigua', 
                controller: controller.txtContrasenaVieja,
                obscureText: true,
              ),
              SizedBox(
                height: 20,
              ),
              FieldTextWidget(
                label:'Contraseña Nueva', 
                controller: controller.txtContrasenaNueva,
                obscureText: true ,
              ),
              SizedBox(
                height: 20,
              ),
              FieldTextWidget(
                label:'Repetir Contraseña Nueva',
                controller: controller.txtRepiteContrasena,
                obscureText: true,
              ),
              SizedBox(
                height: 20,
              ),
              ButtonWidget(
                text: 'Guardar Cambios',
                 onPressed: controller.changePassword,
              )

            ],)
          ),
        )

    ],)
    );
    
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: null,
            body: _buildBody(context)));
  }
}
