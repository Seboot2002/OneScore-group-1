import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'results_controller.dart';

class ResultsPage extends StatelessWidget {
  ResultsController control = Get.put(ResultsController());

  ResultsPage({super.key});

  Widget _buildBody(BuildContext context) {
    return SafeArea(child: Text('Aquí los resultados'));
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
