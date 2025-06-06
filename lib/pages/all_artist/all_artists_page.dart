import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onescore/components/TitleWidget.dart';
import 'package:onescore/components/BottomNavigationBar.dart';
import '../../controllers/bottom_navigation_controller.dart';
import '../../components/artist_card.dart';
import '../../components/BackButtonWidget.dart';
import '../../components/MusicItemsGrid.dart';
import '../../models/entities/user.dart';
import '../../models/entities/artist.dart';
import 'all_artists_controller.dart';

class AllArtistsPage extends StatelessWidget {
  final User user;
  AllArtistsPage({super.key}) : user = Get.arguments as User;

  @override
  Widget build(BuildContext context) {
    // Inicializar el controlador
    final AllArtistsController controller = Get.put(AllArtistsController());

    // Cargar artistas del usuario
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navController = Get.find<BottomNavigationController>();
      navController.updateSelectedIndex(0); // 0 = home
      controller.loadUserArtists(user.userId);
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: null,
      bottomNavigationBar: const CustomMenuBar(),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // Verificar si el usuario tiene artistas
          if (controller.allArtists.isEmpty) {
            return SafeArea(
              top: true,
              bottom: true,
              left: true,
              right: true,
              minimum: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: BackButtonWidget(
                      onPressed: () => Navigator.pop(context),
                      width: 25,
                      height: 25,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(child: TitleWidget(text: 'Artistas')),
                  const SizedBox(height: 40),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No tienes artistas en tu biblioteca',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Configurar los datos de los botones
          final buttonsData = [
            {
              'label': 'Todos',
              'value': true,
              'data': _buildArtistCards(controller.allArtists, context),
            },
            {
              'label': 'Escuchados',
              'value': false,
              'data': _buildArtistCards(controller.listenedArtists, context),
            },
            {
              'label': 'Por valorar',
              'value': false,
              'data': _buildArtistCards(controller.pendingArtists, context),
            },
          ];

          return SafeArea(
            top: true,
            bottom: true,
            left: true,
            right: true,
            minimum: const EdgeInsets.all(15),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: BackButtonWidget(
                    onPressed: () => Navigator.pop(context),
                    width: 25,
                    height: 25,
                  ),
                ),
                const SizedBox(height: 20),
                const Center(child: TitleWidget(text: 'Artistas')),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: MusicItemsGridStructure(
                      buttonsData: buttonsData,
                      onButtonChanged: (newButtonsData) {
                        // Lógica si se desea reaccionar al cambio
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  List<Widget> _buildArtistCards(List<Artist> artists, BuildContext context) {
    if (artists.isEmpty) {
      return [
        const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'No hay artistas en esta categoría',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ),
      ];
    }

    return artists.map((artist) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/artistResult',
            arguments: artist.artistId,
          );
        },
        child: ArtistCard(
          name: artist.name,
          image: artist.pictureUrl,
          artistId: artist.artistId,
        ),
      );
    }).toList();
  }
}
