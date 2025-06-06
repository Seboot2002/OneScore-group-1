import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onescore/components/BackButtonWidget.dart';
import 'package:onescore/components/MusicItemsGrid.dart';
import 'package:onescore/components/StatisticsButton.dart';
import 'package:onescore/components/TitleWidget.dart';
import 'artist_result_controller.dart';
import '../../components/BottomNavigationBar.dart';

class ArtistResultPage extends StatelessWidget {
  final ArtistResultController control = Get.put(ArtistResultController());

  ArtistResultPage({super.key});

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
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (control.artist.value == null) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Artista no encontrado'),
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

        final artist = control.artist.value!;

        return ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Container(
              color: Colors.white,
              child: SafeArea(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05,
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // BackButtonWidget igual que en SearchBarPage
                        const BackButtonWidget(),

                        // Eliminar SizedBox entre BackButton y título para que estén pegados
                        // Luego colocar título
                        const TitleWidget(text: "Artista"),

                        // Espacio igual al SearchBarPage (40)
                        const SizedBox(height: 40),

                        // 🎤 Imagen del artista
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
                                    artist['pictureUrl'],
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
                            artist['name'],
                            style: TextStyle(
                              color: const Color(0xFF535353),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.045,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(height: 4),

                        Center(
                          child: Text(
                            artist['genre'],
                            style: TextStyle(
                              color: const Color(0xFF524E4E),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Estadísticas
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            spacing: MediaQuery.of(context).size.width * 0.08,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: [
                              StatisticsButtonWidget(
                                label: 'N° Albums',
                                numberLabel: control.albumCount.toString(),
                              ),
                              StatisticsButtonWidget(
                                label: 'Año fundación',
                                numberLabel: control.foundationYear.value,
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

                        // Selector de categorías
                        MusicItemsGridStructure(
                          buttonsData: [
                            {
                              'value': true,
                              'label': 'Albums',
                              'data': control.albums,
                            },
                          ],
                          onButtonChanged: onButtonChanged,
                        ),

                        const SizedBox(height: 20),

                        // Botón seguir/eliminar artista
                        Center(
                          child: Obx(
                            () => ElevatedButton(
                              onPressed: () => control.toggleFollowArtist(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    control.isUserFollowingArtist.value
                                        ? Colors.transparent
                                        : const Color(0xFFBF4141),
                                elevation:
                                    control.isUserFollowingArtist.value ? 0 : 2,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 20,
                                ),
                                side:
                                    control.isUserFollowingArtist.value
                                        ? const BorderSide(
                                          color: Color(0xFF6E6E6E),
                                          width: 1,
                                        )
                                        : BorderSide.none,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                control.isUserFollowingArtist.value
                                    ? 'Eliminar artista'
                                    : 'Agregar artista',
                                style: TextStyle(
                                  color:
                                      control.isUserFollowingArtist.value
                                          ? const Color(0xFF6E6E6E)
                                          : Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.035,
                                  fontFamily: 'Roboto',
                                  fontWeight:
                                      control.isUserFollowingArtist.value
                                          ? FontWeight.w200
                                          : FontWeight.w500,
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
        );
      }),
    );
  }
}
