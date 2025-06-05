import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onescore/components/BackButtonWidget.dart';
import 'package:onescore/components/ButtonWidget.dart';
import 'package:onescore/components/MusicItemsGrid.dart';
import 'package:onescore/components/TitleWidget.dart';
import 'package:onescore/controllers/auth_controller.dart';
import 'suggest_controller.dart';
import '../../components/BottomNavigationBar.dart';
import '../../controllers/bottom_navigation_controller.dart';

class SuggestPage extends StatefulWidget {
  const SuggestPage({super.key});

  @override
  _SuggestPageState createState() => _SuggestPageState();
}

class _SuggestPageState extends State<SuggestPage> {
  SuggestController control = Get.put(SuggestController());
  AuthController authControl = Get.find<AuthController>();

  late RxString selectedOption;
  late RxList<Widget> albums;
  late RxList<dynamic> artists;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navController = Get.find<BottomNavigationController>();
      navController.updateSelectedIndex(3); // 3 = suggest
    });

    Future.microtask(() => control.getUserMusicData());

    selectedOption = 'Albums'.obs;
    albums = control.albums;
    artists = control.artists;
  }

  @override
  Widget build(BuildContext context) {
    final user = authControl.user!;

    void onButtonChanged(List<Map<String, dynamic>> updatedButtons) {
      final selected = updatedButtons.firstWhere((btn) => btn['value'] == true);
      setState(() {
        selectedOption.value = selected['label'];
      });
    }

    void onButtonRecomend() {
      setState(() {
        control.getUserMusicData();
      });
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

        return ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.all(34),
              color: Colors.white,
              child: SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      const BackButtonWidget(),

                      const TitleWidget(text: "Recomendaciones", fontSize: 30),

                      const SizedBox(height: 60),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: Text(
                          'Hola, @${user.nickname}. Analizando tu biblioteca musical '
                          'y últimas valoraciones realizadas. Te recomendamos.',
                          style: const TextStyle(
                            color: Color(0xFF535353),
                            fontSize: 13,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        '¡2 albums y 1 artista!',
                        style: TextStyle(
                          color: Color(0xFF535353),
                          fontSize: 13,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                        ),
                      ),

                      const SizedBox(height: 60),

                      MusicItemsGridStructure(
                        buttonsData: [
                          {'value': true, 'label': 'Albums', 'data': albums},
                          {
                            'value': false,
                            'label': 'Artistas',
                            'data': artists,
                          },
                        ],
                        onButtonChanged: onButtonChanged,
                        isStatic: true,
                      ),

                      const SizedBox(height: 60),

                      ButtonWidget(
                        text: 'Vuele a recordarme',
                        onPressed: onButtonRecomend,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        hasBorder: true,
                      ),

                      const SizedBox(height: 40),
                    ],
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
