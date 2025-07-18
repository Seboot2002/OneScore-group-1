import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/CoverAlbumWidget.dart';
import '../../components/TrackListItemWidget.dart';
import '../../components/StatisticsButton.dart';
import '../../components/BottomNavigationBar.dart';
import '../../components/BackButtonWidget.dart';
import '../../components/TitleWidget.dart';
import '../../components/ButtonWidget.dart';
import '../../controllers/bottom_navigation_controller.dart';
import 'album_result_controller.dart';

class AlbumResultPage extends StatelessWidget {
  late final AlbumResultController control;

  AlbumResultPage({super.key}) {
    final albumId = Get.arguments as int; // ✅ obtener argumento
    control = Get.put(AlbumResultController(albumId)); // ✅ pasarlo
  }

  Widget _buildBody(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navController = Get.find<BottomNavigationController>();
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
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const BackButtonWidget(),

                        Center(child: TitleWidget(text: album.title)),

                        const SizedBox(height: 40),

                        Center(
                          child: CoverAlbumWidget(
                            image: NetworkImage(album.coverUrl),
                          ),
                        ),

                        const SizedBox(height: 20),
                        const SizedBox(height: 30),

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

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: control.songs.length,
                            itemBuilder: (context, index) {
                              final song = control.songs[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: TrackListItemWidget(
                                  trackName: song.title,
                                  ratingController: TextEditingController(),
                                ),
                              );
                            },
                          );
                        }),

                        const SizedBox(height: 30),

                        Obx(() {
                          final isFollowing =
                              control.isUserFollowingAlbum.value;
                          final rankState = control.albumRankState.value;

                          String buttonLabel = 'Agregar álbum';
                          VoidCallback onPressed = control.toggleFollowAlbum;

                          if (isFollowing) {
                            if (rankState == 'Por valorar') {
                              buttonLabel = 'Valorar álbum';
                              onPressed = () {
                                print('⭐ Acción: Valorar álbum');
                                // TODO: Aquí llamas a la función de valorar
                              };
                            } else if (rankState == 'Valorado') {
                              buttonLabel = 'Actualizar álbum';
                              onPressed = () {
                                print('🔁 Acción: Actualizar álbum');
                                // TODO: Aquí llamas a la función de revalorar
                              };
                            }
                          } else {
                            buttonLabel = 'Agregar álbum';
                            onPressed =
                                control
                                    .toggleFollowAlbum; // la función de agregar
                          }

                          return Center(
                            child: ButtonWidget(
                              text: buttonLabel,
                              onPressed: onPressed,
                            ),
                          );
                        }),

                        Obx(() {
                          if (control.isUserFollowingAlbum.value) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Center(
                                child: GestureDetector(
                                  onTap: control.removeAlbum,
                                  child: Text(
                                    'eliminar álbum',
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
              ),
            );
          }),
        ),
      ),
      bottomNavigationBar: const CustomMenuBar(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }
}
