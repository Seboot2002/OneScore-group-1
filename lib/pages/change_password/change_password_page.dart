import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onescore/components/BackButtonWidget.dart';
import 'package:onescore/components/ButtonWidget.dart';
import 'package:onescore/components/FieldTextWidget.dart';
import 'change_password_controller.dart';

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordController control = Get.put(ChangePasswordController());

  ChangePasswordPage({super.key});

  Widget _buildBody(BuildContext context) {

    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: (
            BackButtonWidget(
              onPressed: (){
                Navigator.pushNamed(context, routeName)
              },
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
            Column(children: [
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
              FieldTextWidget(
                label:'Contraseña Antigua', 
                controller: controller
              ),
              SizedBox(
                height: 20,
              ),
              FieldTextWidget(
                label:'Contraseña Nueva', 
                controller: controller
              ),
              SizedBox(
                height: 20,
              ),
              FieldTextWidget(
                label:'Repetir Contraseña Nueva', 
                controller: controller
              ),
              SizedBox(
                height: 20,
              ),
              ButtonWidget(
                text: 'Guardar Cambios',
                 onPressed: onPressed
              )

            ],)
          ),
        )

    ],);
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
