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
  final ResultsController control = Get.put(ResultsController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Asegurar que el navbar se mantenga en la posición correcta
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
                builder:
                    (ctrl) => SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back button
                          const BackButtonWidget(),

                          // Title
                          const TitleWidget(text: "Búsqueda"),

                          // 60px spacing (approximately 7.5% of screen height for responsive design)
                          SizedBox(height: screenHeight * 0.006),

                          // Results content
                          if (ctrl.hasResults) ...[
                            _buildResultsContent(ctrl, context),
                          ] else ...[
                            _buildNoResults(),
                          ],

                          const SizedBox(height: 30),
                        ],
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
        // Search info text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Music Items Grid Structure
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
