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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final AllAlbumsController controller = Get.put(AllAlbumsController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navController = Get.find<BottomNavigationController>();
      navController.updateSelectedIndex(0); // 0 = home
      controller.loadUserAlbums(user.userId);
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomMenuBar(),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: screenHeight * 0.05),
            width: screenWidth * 0.9,
            height: screenHeight * 0.90,
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.allAlbums.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    BackButtonWidget(),
                    TitleWidget(text: 'Albums'),
                    SizedBox(height: 40),
                    Expanded(
                      child: Center(
                        child: Text(
                          'No tienes albums en tu biblioteca',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return FutureBuilder<List<List<Widget>>>(
                future: _loadAlbumCardsWithRatings(controller, context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error cargando ratings de albums'),
                    );
                  }

                  final albumCards = snapshot.data!;

                  final buttonsData = [
                    {
                      'label': 'Albums',
                      'value': true,
                      'data': albumCards[0], // allAlbums cards
                    },
                    {
                      'label': 'Valorados',
                      'value': false,
                      'data': albumCards[1], // ratedAlbums cards
                    },
                    {
                      'label': 'Por valorar',
                      'value': false,
                      'data': albumCards[2], // pendingAlbums cards
                    },
                  ];

                  return ScrollConfiguration(
                    behavior: NoGlowScrollBehavior(),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const BackButtonWidget(),
                          const TitleWidget(text: 'Albums'),
                          const SizedBox(height: 40),
                          MusicItemsGridStructure(
                            buttonsData: buttonsData,
                            onButtonChanged: (newButtonsData) {},
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }

  Future<List<List<Widget>>> _loadAlbumCardsWithRatings(
    AllAlbumsController controller,
    BuildContext context,
  ) async {
    final allAlbumsCards = await _buildAlbumCards(
      controller.allAlbums,
      context,
    );
    final ratedAlbumsCards = await _buildAlbumCards(
      controller.ratedAlbums,
      context,
    );
    final pendingAlbumsCards = await _buildAlbumCards(
      controller.pendingAlbums,
      context,
    );

    return [allAlbumsCards, ratedAlbumsCards, pendingAlbumsCards];
  }

  Future<List<Widget>> _buildAlbumCards(
    List<Album> albums,
    BuildContext context,
  ) async {
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

    // Obtener el controlador para acceder al servicio
    final controller = Get.find<AllAlbumsController>();

    return await Future.wait(
      albums.map((album) async {
        double avgScore = 0.0;
        try {
          avgScore = await controller.getUserAlbumRating(
            album.albumId,
            user.userId,
          );
        } catch (e) {
          print('Error obteniendo score de álbum ${album.albumId}: $e');
        }

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
            rating: avgScore,
            albumId: album.albumId,
          ),
        );
      }),
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
