import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onescore/components/BackButtonWidget.dart';
import 'package:onescore/components/EditableAvatarWidget.dart';
import 'package:onescore/components/MusicItemsGrid.dart';
import 'package:onescore/components/StatisticsButton.dart';
import 'package:onescore/components/TitleWidget.dart';
import 'package:onescore/pages/home/home_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../components/BottomNavigationBar.dart';
import '../../controllers/bottom_navigation_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final HomeController control = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final AuthController authControl = Get.find<AuthController>();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navController = Get.find<BottomNavigationController>();
      if (navController.selectedIndex != 0) {
        navController.selectedIndex = 0;
        navController.update();
      }
    });

    final user = authControl.user!;
    final RxString selectedOption = 'Albums'.obs;

    void onButtonChanged(List<Map<String, dynamic>> updatedButtons) {
      final selected = updatedButtons.firstWhere((btn) => btn['value'] == true);
      selectedOption.value = selected['label'];
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: null,
      bottomNavigationBar: const CustomMenuBar(),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Obx(() {
            if (control.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(
                overscroll: false,
              ), // Remove bounce effect
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: screenHeight * 0.05),
                      width: screenWidth * 0.9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const BackButtonWidget(),
                          const TitleWidget(text: "Onescore"),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),

                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(right: 62),
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFF6E6E6E),
                        border: Border.fromBorderSide(
                          BorderSide(color: Color(0xFF6E6E6E), width: 2.5),
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Bienvenido, ${user.nickname}",
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          color: Color(0xFFF1F1F1),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.white,
                      child: SafeArea(
                        child: Center(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  EditableAvatarWidget(
                                    size: 150,
                                    image: NetworkImage(user.photoUrl),
                                    onEdit: () {
                                      print('Cambiar imagen');
                                    },
                                    canEdit: false,
                                  ),

                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.08,
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      StatisticsButtonWidget(
                                        label: 'N° Artistas',
                                        numberLabel:
                                            control.artistCount.toString(),
                                        screenWidthPorcent: 0.18,
                                      ),
                                      const SizedBox(width: 18),
                                      StatisticsButtonWidget(
                                        label: 'N° Albums',
                                        numberLabel:
                                            control.albumCount.toString(),
                                        backgroundColor: const Color(
                                          0xFF6E6E6E,
                                        ),
                                        textColor: Colors.white,
                                        screenWidthPorcent: 0.18,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(left: 62),
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFF6E6E6E),
                        border: Border.fromBorderSide(
                          BorderSide(color: Color(0xFF6E6E6E), width: 2.5),
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(0),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(0),
                        ),
                      ),
                      child: const Text(
                        "Biblioteca musical",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Color(0xFFF1F1F1),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(34),
                      color: Colors.white,
                      child: SafeArea(
                        child: Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),

                              MusicItemsGridStructure(
                                buttonsData: [
                                  {
                                    'value': true,
                                    'label': 'Albums',
                                    'data': control.albums,
                                  },
                                  {
                                    'value': false,
                                    'label': 'Artistas',
                                    'data': control.artists,
                                  },
                                ],
                                onButtonChanged: onButtonChanged,
                                isStatic: true,
                              ),

                              const SizedBox(height: 2),

                              Container(
                                padding: const EdgeInsets.only(
                                  top: 25,
                                  bottom: 50,
                                  left: 50,
                                  right: 25,
                                ),
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    if (selectedOption.value == 'Albums') {
                                      Get.toNamed(
                                        '/all_albums',
                                        arguments: user,
                                      );
                                    } else {
                                      Get.toNamed(
                                        '/all_artists',
                                        arguments: user,
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'Ver todos',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6E6E6E),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
