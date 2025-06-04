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
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(34),
            color: Colors.white,
            child: SafeArea(
              child: Center(
                child: Column(
                  children: [
                    const BackButtonWidget(),

                    TitleWidget(text: "Perfil"),

                    SizedBox(height: 50),

                    EditableAvatarWidget(
                      size: 190,
                      image: NetworkImage(user.photoUrl),
                      onEdit: () {
                        // aquí hay poner el código para dirigir al cambio de contraseñas
                        print('Cambiar imagen');
                      },
                    ),

                    SizedBox(height: 16),

                    Text(
                      '@${user.nickname}' ?? '',
                      style: TextStyle(
                        color: Color(0xFF535353),
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${user.name} ${user.lastName}' ?? '',
                      style: TextStyle(fontFamily: 'Roboto'),
                    ),

                    SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        spacing: MediaQuery.of(context).size.width * 0.08,
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
                            backgroundColor: Color(0xFF6E6E6E),
                            textColor: Colors.white,
                          ),
                          StatisticsButtonWidget(
                            label: 'N° Canciones',
                            numberLabel: control.songCount.toString(),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 70),

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
                    ),

                    SizedBox(height: 2),

                    Container(
                      padding: EdgeInsets.only(
                        top: 25,
                        bottom: 50,
                        left: 50,
                        right: 25,
                      ),
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          if (selectedOption.value == 'Albums') {
                            print('El user es:');
                            print(authControl.user);
                            Get.offNamed(
                              '/all_albums',
                              arguments: authControl.user,
                            );
                          } else {
                            print('El user es:');
                            print(authControl.user);
                            Get.offNamed(
                              '/all_artists',
                              arguments: authControl.user,
                            );
                          }
                        },
                        child: Text(
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
        );
      }),
    );
  }
}
