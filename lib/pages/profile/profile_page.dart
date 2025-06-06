import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onescore/components/BackButtonWidget.dart';
import 'package:onescore/components/EditableAvatarWidget.dart';
import 'package:onescore/components/MusicItemsGrid.dart';
import 'package:onescore/components/StatisticsButton.dart';
import 'package:onescore/components/TitleWidget.dart';
import 'package:onescore/controllers/auth_controller.dart';
import 'profile_controller.dart';
import '../../components/BottomNavigationBar.dart';
import '../../controllers/bottom_navigation_controller.dart';

class ProfilePage extends StatelessWidget {
  ProfileController control = Get.put(ProfileController());
  AuthController authControl = Get.find<AuthController>();

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Asegurar que el navbar muestre profile como seleccionado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navController = Get.find<BottomNavigationController>();
      navController.updateSelectedIndex(2); // 2 = profile
    });

    Future.microtask(() => control.getUserMusicData());
    final user = authControl.user!;

    final RxString selectedOption = 'Albums'.obs;

    void onButtonChanged(List<Map<String, dynamic>> updatedButtons) {
      final selected = updatedButtons.firstWhere((btn) => btn['value'] == true);
      selectedOption.value = selected['label'];
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: null,
      bottomNavigationBar: const CustomMenuBar(),
      body: Obx(() {
        if (control.isLoading.value) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;

        return Container(
          color: Colors.white,
          child: SafeArea(
            child: Center(
              child: Container(
                margin: EdgeInsets.only(top: screenHeight * 0.05),
                width: screenWidth * 0.9,
                height: screenHeight * 0.90,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(overscroll: false),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const BackButtonWidget(),

                        const TitleWidget(text: "Perfil"),
                        const SizedBox(height: 50),

                        Center(
                          child: Column(
                            children: [
                              EditableAvatarWidget(
                                size: 190,
                                image: NetworkImage(user.photoUrl),
                                onEdit: () {
                                  print('Cambiar imagen');
                                },
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '@${user.nickname}',
                                style: const TextStyle(
                                  color: Color(0xFF535353),
                                  fontSize: 18,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${user.name} ${user.lastName}',
                                style: const TextStyle(fontFamily: 'Roboto'),
                              ),
                              const SizedBox(height: 25),
                              Wrap(
                                spacing: screenWidth * 0.08,
                                runSpacing: 12,
                                alignment: WrapAlignment.center,
                                children: [
                                  StatisticsButtonWidget(
                                    label: 'N° Artistas',
                                    numberLabel: control.artistCount.toString(),
                                  ),
                                  StatisticsButtonWidget(
                                    label: 'N° Albums',
                                    numberLabel: control.albumCount.toString(),
                                    backgroundColor: const Color(0xFF6E6E6E),
                                    textColor: Colors.white,
                                  ),
                                  StatisticsButtonWidget(
                                    label: 'N° Canciones',
                                    numberLabel: control.songCount.toString(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 70),
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
                                    final target =
                                        selectedOption.value == 'Albums'
                                            ? '/all_albums'
                                            : '/all_artists';

                                    print('El user es:');
                                    print(authControl.user);

                                    Get.offNamed(
                                      target,
                                      arguments: authControl.user,
                                    );
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
