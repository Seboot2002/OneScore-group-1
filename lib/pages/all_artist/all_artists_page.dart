import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../components/artist_card.dart';
import 'package:onescore/components/BottomNavigationBar.dart';
import '../../controllers/bottom_navigation_controller.dart';
import '../../components/BackButtonWidget.dart';
import '../../components/MusicItemsGrid.dart';
import '../../models/entities/user.dart';
import '../../models/entities/artist.dart';
import 'package:get/get.dart';


class AllArtistsPage extends StatelessWidget {
  AllArtistsPage({Key? key}) : super(key: key);

  Future<Map<String, List<Artist>>> loadArtists(int currentUserId) async {
    final artistsJson = await rootBundle.loadString('assets/jsons/user.json');
    final artistUserJson = await rootBundle.loadString('assets/jsons/artistUser.json');

    final List<dynamic> artistsData = json.decode(artistsJson);
    final List<dynamic> artistUserData = json.decode(artistUserJson);

    final allArtists = artistsData.map((e) => Artist.fromJson(e)).toList();

    final favoriteArtistIds = artistUserData
        .where((e) => e['userId'] == currentUserId)
        .map<int>((e) => e['artistId'])
        .toSet();

    final favoriteArtists = allArtists
        .where((artist) => favoriteArtistIds.contains(artist.artistId))
        .toList();

    return {
      'allArtists': allArtists,
      'favoriteArtists': favoriteArtists,
    };
  }

  List<Widget> buildArtistCards(List<Artist> artists, BuildContext context) {
    return artists.map((artist) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/artistResult', arguments: artist.artistId);
        },
        child:( ArtistCard(name: artist.name , image: artist.pictureUrl)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Get.arguments as User;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navController = Get.find<BottomNavigationController>();
      navController.updateSelectedIndex(0); // 0 = home
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: null,
      bottomNavigationBar: const CustomMenuBar(),
      body: SafeArea(
        child: FutureBuilder<Map<String, List<Artist>>>(
          future: loadArtists(user.userId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final allArtists = snapshot.data!['allArtists']!;
            final favoriteArtists = snapshot.data!['favoriteArtists']!;

            final buttonsData = [
              {
                'label': 'Todos',
                'value': true,
                'data': buildArtistCards(allArtists, context),
              },
              {
                'label': 'Favoritos',
                'value': false,
                'data': buildArtistCards(favoriteArtists, context),
              },
            ];

            return Column(
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
                const Center(
                  child: Text(
                    'Artistas',
                    style: TextStyle(fontSize: 36, color: Color.fromRGBO(110, 110, 110, 1)),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: MusicItemsGridStructure(
                    buttonsData: buttonsData,
                    onButtonChanged: (newButtonsData) {
                      // Aquí va la lógica opcional si deseas reaccionar al cambio
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
