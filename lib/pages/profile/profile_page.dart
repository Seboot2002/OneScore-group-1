import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onescore/components/BackButtonWidget.dart';
import 'package:onescore/components/EditableAvatarWidget.dart';
import 'package:onescore/components/MusicItemsGrid.dart';
import 'package:onescore/components/StatisticsButton.dart';
import 'package:onescore/components/TitleWidget.dart';
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

    Future.microtask(() => control.getUserData());

    void onButtonChanged(List<Map<String, dynamic>> updatedButtons) {
      print(updatedButtons);
    }

    /*return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: null,
      body: _buildBody(context),
      bottomNavigationBar: const CustomMenuBar(),
    );*/

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: null,
      bottomNavigationBar: const CustomMenuBar(),
      body: Obx(() {
        if (control.isLoading.value) {
          return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                  child: CircularProgressIndicator()
              )
          );
        }

        final data = control.userData;

        return SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(34),
              color: Colors.white,
              child: SafeArea(
                child: Center(
                  child: Column(
                    children: [

                      const BackButtonWidget(),

                      TitleWidget(
                        text: "Perfil",
                      ),

                      SizedBox(height: 50),

                      EditableAvatarWidget(
                          size: 190,
                          image: const AssetImage('assets/imgs/mod1_01.jpg'),
                          onEdit: () {
                            print('Cambiar imagen');
                          }),

                      SizedBox(height: 16),

                      Text(
                        data['username'] ?? '',
                        style: TextStyle(
                            color: Color(0xFF535353),
                            fontSize: 18,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      Text(
                        data['name'] ?? '',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                        ),
                      ),

                      SizedBox(height: 25),

                      Container(
                        width: double.infinity,
                        child: Wrap(
                          spacing: MediaQuery
                              .of(context)
                              .size
                              .width * 0.08,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            StatisticsButtonWidget(
                                label: 'N° Artistas',
                                numberLabel: data['statistics']?['artists']
                                    ?.toString() ?? '0'
                            ),
                            StatisticsButtonWidget(
                              label: 'N° Albums',
                              numberLabel: data['statistics']?['albums']
                                  ?.toString() ?? '0',
                              backgroundColor: Color(0xFF6E6E6E),
                              textColor: Colors.white,
                            ),
                            StatisticsButtonWidget(
                                label: 'N° Canciones',
                                numberLabel: data['statistics']?['songs']
                                    ?.toString() ?? '0'
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 70),

                      MusicItemsGridStructure(
                        buttonsData: [
                          {'value': true, 'label': 'Albums', 'data': control
                              .albums},
                          {'value': false, 'label': 'Artistas', 'data': control
                              .artists},
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
                            print("Haz hecho clic en 'Ver todos'");
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
                      )

                    ],
                  ),
                ),
              )
          ),
        );
      })
    );
  }
}
