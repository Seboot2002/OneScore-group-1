import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/TitleWidget.dart';
import '../../components/SearchingBarWidget.dart';
import '../../components/OneScoreCheckbox.dart';
import '../../components/BottomNavigationBar.dart';
import '../../components/BackButtonWidget.dart';
import '../../controllers/bottom_navigation_controller.dart';
import 'search_bar_controller.dart';

class SearchBarPage extends StatelessWidget {
  SearchBarPage({super.key});
  final SearchBarController control = Get.put(SearchBarController());

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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BackButtonWidget(),

                    const TitleWidget(text: "Búsqueda"),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: SearchingBarWidget(
                        controller: control.searchController,
                        onSearch: control.onSearchPressed,
                      ),
                    ),
                    const SizedBox(height: 30),

                    GetBuilder<SearchBarController>(
                      builder:
                          (ctrl) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(
                                ctrl.checkboxes.length,
                                (index) => OneScoreCheckBox(
                                  value: ctrl.checkboxes[index]['value'],
                                  label: ctrl.checkboxes[index]['label'],
                                  onChanged: (_) => ctrl.selectCheckbox(index),
                                ),
                              ),
                            ),
                          ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomMenuBar(),
    );
  }
}
