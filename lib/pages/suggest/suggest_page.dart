import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'suggest_controller.dart';
import '../../components/BottomNavigationBar.dart';
import '../../controllers/bottom_navigation_controller.dart';

class SuggestPage extends StatelessWidget {
  SuggestController control = Get.put(SuggestController());
  SuggestPage({super.key});

  Widget _buildBody(BuildContext context) {
    return SafeArea(child: Text('Este es SUGGEST'));
  }

  @override
  Widget build(BuildContext context) {
    // Asegurar que el navbar muestre suggest como seleccionado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navController = Get.find<BottomNavigationController>();
      navController.updateSelectedIndex(3); // 3 = suggest
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: null,
      body: _buildBody(context),
      bottomNavigationBar: const CustomMenuBar(),
    );
  }
}
