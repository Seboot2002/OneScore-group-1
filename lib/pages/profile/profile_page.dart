import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';
import '../../components/BottomNavigationBar.dart';
import '../../controllers/bottom_navigation_controller.dart';

class ProfilePage extends StatelessWidget {
  ProfileController control = Get.put(ProfileController());
  ProfilePage({super.key});

  Widget _buildBody(BuildContext context) {
    return SafeArea(child: Text('Este es PROFILE'));
  }

  @override
  Widget build(BuildContext context) {
    // Asegurar que el navbar muestre profile como seleccionado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navController = Get.find<BottomNavigationController>();
      navController.updateSelectedIndex(2); // 2 = profile
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: null,
      body: _buildBody(context),
      bottomNavigationBar: const CustomMenuBar(),
    );
  }
}
