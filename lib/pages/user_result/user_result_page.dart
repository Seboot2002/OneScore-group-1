import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onescore/components/BackButtonWidget.dart';
import 'package:onescore/components/EditableAvatarWidget.dart';
import 'package:onescore/components/MusicItemsGrid.dart';
import 'package:onescore/components/StatisticsButton.dart';
import 'package:onescore/components/TitleWidget.dart';
import 'user_result_controller.dart';
import '../../components/BottomNavigationBar.dart';

class UserResultPage extends StatelessWidget {
  UserResultController control = Get.put(UserResultController());

  UserResultPage({super.key});

  @override
  Widget build(BuildContext context) {
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

        if (control.user.value == null) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Usuario no encontrado'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: Text('Volver'),
                  ),
                ],
              ),
            ),
          );
        }

        final user = control.user.value!;

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

                    // Avatar del usuario (sin funcionalidad de editar, pero mismo estilo)
                    Container(
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(11), // separación interna
                        decoration: BoxDecoration(
                          color: Color(0xFF6E6E6E), // color de fondo (corona)
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.network(
                            user.photoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade200,
                                child: Icon(
                                  Icons.person,
                                  size: 100,
                                  color: Colors.grey.shade400,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    Text(
                      '@${user.nickname}',
                      style: TextStyle(
                        color: Color(0xFF535353),
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${user.name} ${user.lastName}',
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
                            print(user);
                            Get.offNamed('/all_albums', arguments: user);
                          } else {
                            print('El user es:');
                            print(user);
                            Get.offNamed('/all_artists', arguments: user);
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
