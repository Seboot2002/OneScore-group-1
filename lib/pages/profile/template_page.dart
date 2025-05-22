import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'template_controller.dart';

class TemplatePage extends StatelessWidget {
  TemplateController control = Get.put(TemplateController());

  TemplatePage({super.key});

  Widget _buildBody(BuildContext context) {
    return SafeArea(child: Text('Template Page'));
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
