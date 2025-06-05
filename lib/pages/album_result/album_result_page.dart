import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/CoverAlbumWidget.dart';
import '../../components/TrackListItemWidget.dart';
import '../../components/StatisticsButton.dart';
import '../../components/BottomNavigationBar.dart';
import '../../components/BackButtonWidget.dart';
import '../../components/TitleWidget.dart';
import '../../controllers/bottom_navigation_controller.dart';
import 'album_result_controller.dart';

class AlbumResultPage extends StatelessWidget {
  final AlbumResultController control = Get.put(AlbumResultController());

  AlbumResultPage({super.key});

  Widget _buildBody(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Asegurar que el navbar se actualice correctamente al entrar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navController = Get.find<BottomNavigationController>();
      // Si necesitas establecer un índice específico para esta página, hazlo aquí
      // Por ejemplo, si esta página corresponde al índice 2 (perfil):
      // if (navController.selectedIndex != 2) {
      //   navController.selectedIndex = 2;
      //   navController.update();
      // }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Obx(() {
            if (control.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final album = control.album.value;
            if (album == null) {
              return const Center(child: Text('Álbum no encontrado'));
            }

            return Center(
              child: Container(
                margin: EdgeInsets.only(top: screenHeight * 0.05),
                width: screenWidth * 0.9,
                height: screenHeight * 0.90,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Usar el componente BackButtonWidget
                      const BackButtonWidget(),

                      // Usar el componente TitleWidget
                      TitleWidget(text: album.title),
                      const SizedBox(height: 40),
                      // Imagen del álbum
                      Center(
                        child: CoverAlbumWidget(
                          image: NetworkImage(album.coverUrl),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Nombre del artista
                      Obx(
                        () => Center(
                          child: Text(
                            control.artistName.value,
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF535353),
                              fontFamily: 'Roboto',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Género
                      Obx(
                        () => Center(
                          child: Text(
                            control.genreName.value,
                            style: TextStyle(
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFF524E4E),
                              fontFamily: 'Roboto',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Stats usando StatisticsButtonWidget
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: MediaQuery.of(context).size.width * 0.08,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            StatisticsButtonWidget(
                              label: 'Año (Salida)',
                              numberLabel: album.releaseYear.toString(),
                            ),
                            StatisticsButtonWidget(
                              label: 'Rating',
                              numberLabel:
                                  control.isUserFollowingAlbum.value
                                      ? control.albumRating.value.toString()
                                      : '—',
                              backgroundColor: const Color(0xFF6E6E6E),
                              textColor: Colors.white,
                            ),
                            StatisticsButtonWidget(
                              label: 'Año (Escucha)',
                              numberLabel:
                                  control.listenYear.value > 0
                                      ? control.listenYear.value.toString()
                                      : '—',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Tracklist
                      Center(
                        child: Text(
                          'Tracklist',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF535353),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Lista de canciones
                      Obx(() {
                        if (control.songs.isEmpty) {
                          return const Text(
                            'No se encontraron canciones para este álbum.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: control.songs.length,
                          separatorBuilder:
                              (context, index) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final song = control.songs[index];
                            return TrackListItemWidget(
                              trackName: song.title,
                              ratingController: TextEditingController(),
                            );
                          },
                        );
                      }),

                      const SizedBox(height: 30),

                      // Botón Agregar/Guardar Album
                      Obx(
                        () => Center(
                          child: SizedBox(
                            width: screenWidth * 0.5,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: control.toggleFollowAlbum,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD32F2F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                control.isUserFollowingAlbum.value
                                    ? 'Guardar album'
                                    : 'Agregar album',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Texto "eliminar album" si el usuario ya sigue el álbum
                      Obx(() {
                        if (control.isUserFollowingAlbum.value) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Center(
                              child: GestureDetector(
                                onTap: control.removeAlbum,
                                child: Text(
                                  'eliminar album',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    fontWeight: FontWeight.w300,
                                    color: const Color(0xFF6E6E6E),
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      }),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
      // Usar el componente CustomMenuBar en lugar del navbar personalizado
      bottomNavigationBar: const CustomMenuBar(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }
}
