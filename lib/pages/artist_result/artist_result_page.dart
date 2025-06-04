import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onescore/components/BackButtonWidget.dart';
import 'package:onescore/components/MusicItemsGrid.dart';
import 'package:onescore/components/StatisticsButton.dart';
import 'package:onescore/components/TitleWidget.dart';
import 'artist_result_controller.dart';
import '../../components/BottomNavigationBar.dart';

class ArtistResultPage extends StatelessWidget {
  ArtistResultController control = Get.put(ArtistResultController());

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
          return Scaffold(
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
                  Text('Artista no encontrado'),
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

        final artist = control.artist.value!;

        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(34),
            color: Colors.white,
            child: SafeArea(
              child: Center(
                child: Column(
                  children: [
                    const BackButtonWidget(),

                    TitleWidget(text: "Artista"),

                    SizedBox(height: 50),

                    // Avatar del artista con 70% opacidad
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
                          child: Opacity(
                            opacity: 0.7, // 70% de opacidad
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

                    SizedBox(height: 16),

                    // Nombre del artista - Roboto Medium 18px equivalente
                    Text(
                      artist['name'],
                      style: TextStyle(
                        color: Color(0xFF535353),
                        fontSize:
                            MediaQuery.of(context).size.width *
                            0.045, // ~18px equivalente
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500, // Medium
                      ),
                    ),

                    SizedBox(height: 4),

                    // Género - Roboto Extra Light 12px equivalente
                    Text(
                      artist['genre'],
                      style: TextStyle(
                        color: Color(0xFF524E4E),
                        fontSize:
                            MediaQuery.of(context).size.width *
                            0.03, // ~12px equivalente
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w200, // Extra Light
                      ),
                    ),

                    SizedBox(height: 25),

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

                    // Grid de álbumes
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

                    SizedBox(height: 20),

                    // Botón Agregar/Eliminar Artista
                    // Botón Agregar/Eliminar Artista
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20),
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
                              horizontal: 10,
                            ),
                            side:
                                control.isUserFollowingArtist.value
                                    ? const BorderSide(
                                      color: Color(0xFF6E6E6E),
                                      width: 1,
                                    )
                                    : BorderSide
                                        .none, // Sin borde para "Agregar"
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
                                  MediaQuery.of(context).size.width *
                                  0.035, // ~14px
                              fontFamily: 'Roboto',
                              fontWeight:
                                  control.isUserFollowingArtist.value
                                      ? FontWeight
                                          .w200 // Extra Light
                                      : FontWeight.w500, // Medium
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
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
