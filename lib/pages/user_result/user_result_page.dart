import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_result_controller.dart';

class UserResultPage extends StatelessWidget {
  UserResultController control = Get.put(UserResultController());

  UserResultPage({super.key});

  Widget _buildBody(BuildContext context) {
    return SafeArea(child: Text('Un usuario… ¿qué tal su perfil?'));
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
