import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onescore/components/BottomNavigationBar.dart';
import 'package:onescore/components/TitleWidget.dart';
import '../../controllers/bottom_navigation_controller.dart';
import '../../components/album_card.dart';
import '../../components/BackButtonWidget.dart';
import '../../components/MusicItemsGrid.dart';
import '../../models/entities/user.dart';
import '../../models/entities/album.dart';
import 'all_albums_controller.dart';

class AllAlbumsPage extends StatelessWidget {
  final User user;
  AllAlbumsPage({super.key}) : user = Get.arguments as User;

  @override
  Widget build(BuildContext context) {
    // Inicializar el controlador
    final AllAlbumsController controller = Get.put(AllAlbumsController());

    // Cargar albums del usuario
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navController = Get.find<BottomNavigationController>();
      navController.updateSelectedIndex(0); // 0 = home
      controller.loadUserAlbums(user.userId);
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

          // Verificar si el usuario tiene albums
          if (controller.allAlbums.isEmpty) {
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
                  const TitleWidget(text: 'Albums'),
                  const SizedBox(height: 40),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No tienes albums en tu biblioteca',
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
              'label': 'Albums',
              'value': true,
              'data': _buildAlbumCards(controller.allAlbums, context),
            },
            {
              'label': 'Escuchados',
              'value': false,
              'data': _buildAlbumCards(controller.ratedAlbums, context),
            },
            {
              'label': 'Por valorar',
              'value': false,
              'data': _buildAlbumCards(controller.pendingAlbums, context),
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
                const TitleWidget(text: 'Albums'),
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

  List<Widget> _buildAlbumCards(List<Album> albums, BuildContext context) {
    if (albums.isEmpty) {
      return [
        const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'No hay albums en esta categoría',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ),
      ];
    }

    return albums.map((album) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/albumResult',
            arguments: album.albumId,
          );
        },
        child: AlbumCard(
          name: album.title,
          image: album.coverUrl,
          rating: 5.0, // Puedes cambiar según tu lógica de puntuación
          albumId: album.albumId,
        ),
      );
    }).toList();
  }
}
