import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onescore/components/BackButtonWidget.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final RxString selectedOption = 'Albums'.obs;

    void onButtonChanged(List<Map<String, dynamic>> updatedButtons) {
      final selected = updatedButtons.firstWhere((btn) => btn['value'] == true);
      selectedOption.value = selected['label'];
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: const CustomMenuBar(),
      body: Obx(() {
        if (control.isLoading.value) {
          return const Scaffold(
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
                  const Text('Usuario no encontrado'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: const Text('Volver'),
                  ),
                ],
              ),
            ),
          );
        }

        final user = control.user.value!;

        return Container(
          color: Colors.white,
          child: SafeArea(
            child: Center(
              child: Container(
                margin: EdgeInsets.only(top: screenHeight * 0.05),
                width: screenWidth * 0.9,
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

                        const SizedBox(height: 40),

                        Center(
                          child: Container(
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
                              padding: const EdgeInsets.all(11),
                              decoration: const BoxDecoration(
                                color: Color(0xFF6E6E6E),
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Opacity(
                                  opacity: 0.7,
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
                          ),
                        ),

                        const SizedBox(height: 16),

                        Center(
                          child: Text(
                            '@${user.nickname}',
                            style: const TextStyle(
                              color: Color(0xFF535353),
                              fontSize: 18,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        Center(
                          child: Text(
                            '${user.name} ${user.lastName}',
                            style: const TextStyle(fontFamily: 'Roboto'),
                          ),
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
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
                                Get.offNamed('/all_albums', arguments: user);
                              } else {
                                Get.offNamed('/all_artists', arguments: user);
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
            ),
          ),
        );
      }),
    );
  }
}
