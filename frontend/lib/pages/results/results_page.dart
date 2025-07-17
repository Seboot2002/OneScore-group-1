import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/TitleWidget.dart';
import '../../components/BottomNavigationBar.dart';
import '../../components/BackButtonWidget.dart';
import '../../components/MusicItemsGrid.dart';
import '../../controllers/bottom_navigation_controller.dart';
import 'results_controller.dart';

class ResultsPage extends StatelessWidget {
  ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navController = Get.find<BottomNavigationController>();
      if (navController.selectedIndex != 1) {
        navController.selectedIndex = 1;
        navController.update();
      }
    });

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
              child: GetBuilder<ResultsController>(
                init:
                    ResultsController(), // 👈 esto fuerza una nueva instancia con nuevos argumentos
                builder:
                    (ctrl) => ScrollConfiguration(
                      behavior: const ScrollBehavior().copyWith(
                        overscroll: false,
                      ),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BackButtonWidget(),
                            const TitleWidget(text: "Búsqueda"),
                            SizedBox(height: screenHeight * 0.006),
                            if (ctrl.hasResults)
                              _buildResultsContent(ctrl, context)
                            else
                              _buildNoResults(),
                            const SizedBox(height: 30),
                          ],
                        ),
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

  Widget _buildResultsContent(ResultsController ctrl, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontFamily: 'Roboto',
              ),
              text: '',
            ),
          ),
        ),
        const SizedBox(height: 20),
        MusicItemsGridStructure(
          buttonsData: ctrl.buttonsData,
          onButtonChanged: (updatedButtons) {
            print("🔄 Botones actualizados: $updatedButtons");
          },
        ),
      ],
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 100),
          Icon(Icons.search_off, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 20),
          Text(
            'No se encontraron resultados',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Intenta con otros términos de búsqueda',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
