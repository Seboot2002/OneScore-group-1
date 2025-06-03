import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:onescore/components/BottomNavigationBar.dart';
import 'package:onescore/components/TitleWidget.dart';
import '../../controllers/bottom_navigation_controller.dart';
import '../../components/album_card.dart';
import '../../components/BackButtonWidget.dart';
import '../../components/MusicItemsGrid.dart';
import '../../models/entities/user.dart';
import '../../models/entities/album.dart';

class AllAlbumsPage extends StatelessWidget {
  final User user;
  AllAlbumsPage({super.key}) : user = Get.arguments as User;

  Future<Map<String, List<Album>>> loadAlbums(int currentUserId) async {
    final albumsJson = await rootBundle.loadString('assets/jsons/album.json');
    final albumUserJson = await rootBundle.loadString(
      'assets/jsons/albumUser.json',
    );

    final List<dynamic> albumsData = json.decode(albumsJson);
    final List<dynamic> albumUserData = json.decode(albumUserJson);

    final allAlbums = albumsData.map((e) => Album.fromJson(e)).toList();

    final ratedAlbumIds =
        albumUserData
            .where(
              (e) => e['userId'] == currentUserId && e['rankState'] == 'valued',
            )
            .map<int>((e) => e['albumId'])
            .toSet();

    final ratedAlbums =
        allAlbums
            .where((album) => ratedAlbumIds.contains(album.albumId))
            .toList();
    final toRateAlbums =
        allAlbums
            .where((album) => !ratedAlbumIds.contains(album.albumId))
            .toList();

    return {
      'allAlbums': allAlbums,
      'ratedAlbums': ratedAlbums,
      'toRateAlbums': toRateAlbums,
    };
  }

  List<Widget> buildAlbumCards(List<Album> albums, BuildContext context) {
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
          rating: 5.0, // Cambia según tu lógica de puntuación
          albumId: album.albumId,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navController = Get.find<BottomNavigationController>();
      navController.updateSelectedIndex(0); // 0 = home
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: null,
      bottomNavigationBar: const CustomMenuBar(),
      body: SafeArea(
        child: FutureBuilder<Map<String, List<Album>>>(
          future: loadAlbums(user.userId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final allAlbums = snapshot.data!['allAlbums']!;
            final ratedAlbums = snapshot.data!['ratedAlbums']!;
            final toRateAlbums = snapshot.data!['toRateAlbums']!;

            final buttonsData = [
              {
                'label': 'Todos',
                'value': true,
                'data': buildAlbumCards(allAlbums, context),
              },
              {
                'label': 'Valorados',
                'value': false,
                'data': buildAlbumCards(ratedAlbums, context),
              },
              {
                'label': 'Por valorar',
                'value': false,
                'data': buildAlbumCards(toRateAlbums, context),
              },
            ];

            return SafeArea(
              top: true,
              bottom: true,
              left: true,
              right: true,
              minimum: EdgeInsets.all(15),
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
                  Container(
                    alignment: Alignment.center,
                    child: MusicItemsGridStructure(
                      buttonsData: buttonsData,
                      onButtonChanged: (newButtonsData) {
                        // Lógica si se desea reaccionar al cambio
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
