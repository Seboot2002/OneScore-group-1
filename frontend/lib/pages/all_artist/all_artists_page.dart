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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final AllArtistsController controller = Get.put(AllArtistsController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navController = Get.find<BottomNavigationController>();
      navController.updateSelectedIndex(0); // 0 = home
      controller.loadUserArtists(user.userId);
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

              if (controller.allArtists.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    BackButtonWidget(),
                    TitleWidget(text: 'Artistas'),
                    SizedBox(height: 40),
                    Expanded(
                      child: Center(
                        child: Text(
                          'No tienes artistas en tu biblioteca',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                );
              }

              final buttonsData = [
                {
                  'label': 'Todos',
                  'value': true,
                  'data': _buildArtistCards(controller.allArtists, context),
                },
                {
                  'label': 'Escuchados',
                  'value': false,
                  'data': _buildArtistCards(
                    controller.listenedArtists,
                    context,
                  ),
                },
                {
                  'label': 'Por valorar',
                  'value': false,
                  'data': _buildArtistCards(controller.pendingArtists, context),
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
                      const TitleWidget(text: 'Artistas'),
                      const SizedBox(height: 40),
                      MusicItemsGridStructure(
                        buttonsData: buttonsData,
                        onButtonChanged: (newButtonsData) {
                          // No acción requerida aquí por ahora
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
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
