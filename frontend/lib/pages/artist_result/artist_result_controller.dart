import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:onescore/components/album_card.dart';
import 'package:onescore/controllers/auth_controller.dart';
import 'package:onescore/services/userMusicData_service.dart';

class ArtistResultController extends GetxController {
  var isLoading = false.obs;
  var artist = Rxn<Map<String, dynamic>>();
  var albums = <Widget>[].obs;
  var albumCount = 0.obs;
  var songCount = 0.obs;
  var foundationYear = ''.obs;
  var isUserFollowingArtist = false.obs;

  final UserMusicDataService _musicService = UserMusicDataService();
  final AuthController _authController = Get.find<AuthController>();
  late int artistId;

  @override
  void onInit() {
    super.onInit();
    artistId = (Get.arguments as Map<String, dynamic>)['artistId'];
    print('ArtistResultController inicializado con artistId: $artistId');
    getArtistData();
  }

  Future<void> getArtistData() async {
    artist.value = null;
    albums.clear();
    albumCount.value = 0;
    songCount.value = 0;
    foundationYear.value = '';
    isUserFollowingArtist.value = false;
    print("Iniciando carga de datos del artista con ID: $artistId");
    isLoading.value = true;

    try {
      final artistJson = await rootBundle.loadString(
        'assets/jsons/artist.json',
      );
      final genreJson = await rootBundle.loadString('assets/jsons/genre.json');
      final List<dynamic> allArtists = json.decode(artistJson);
      final List<dynamic> allGenres = json.decode(genreJson);

      final artistData = allArtists.firstWhere(
        (artist) => artist['artistId'] == artistId,
        orElse: () => null,
      );

      if (artistData == null) {
        print("❌ Artista con ID $artistId no encontrado");
        Get.snackbar(
          'Error',
          'Artista no encontrado',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final genreId = artistData['genreId'];
      final genreData = allGenres.firstWhere(
        (genre) => genre['genreId'] == genreId,
        orElse: () => null,
      );

      final genreName = genreData != null ? genreData['name'] : 'Sin género';
      final debutYear = artistData['debutYear']?.toString() ?? '';

      artist.value = {
        'artistId': artistData['artistId'],
        'name': artistData['name'] ?? '',
        'pictureUrl': artistData['pictureUrl'] ?? '',
        'genre': genreName,
        'foundationYear': debutYear,
      };

      foundationYear.value = debutYear;

      print("✅ Artista cargado: ${artist.value!['name']}");
      print("- Género: $genreName");
      print("- Año de fundación: $debutYear");

      await checkIfUserFollowsArtist();

      await getArtistMusicData();
    } catch (e) {
      print("Error al obtener datos del artista: $e");
      Get.snackbar(
        'Error',
        'No se pudieron cargar los datos del artista',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      print("Carga finalizada para artista ID: $artistId");
    }
  }

  Future<void> checkIfUserFollowsArtist() async {
    try {
      final artistUserJson = await rootBundle.loadString(
        'assets/jsons/artistUser.json',
      );
      final List<dynamic> artistUserRelations = json.decode(artistUserJson);

      final currentUserId = _authController.userId;
      if (currentUserId == null) return;

      final relation = artistUserRelations.firstWhere(
        (relation) =>
            relation['userId'] == currentUserId &&
            relation['artistId'] == artistId,
        orElse: () => null,
      );

      isUserFollowingArtist.value = relation != null;
      print(
        "Usuario $currentUserId ${isUserFollowingArtist.value ? 'sigue' : 'no sigue'} al artista $artistId",
      );
    } catch (e) {
      print("Error al verificar si el usuario sigue al artista: $e");
    }
  }

  Future<void> getArtistMusicData() async {
    print("Iniciando carga de datos musicales para artista ID: $artistId");

    try {
      final albumJson = await rootBundle.loadString('assets/jsons/album.json');
      final songJson = await rootBundle.loadString('assets/jsons/song.json');

      final List<dynamic> allAlbums = json.decode(albumJson);
      final List<dynamic> allSongs = json.decode(songJson);

      final artistAlbums =
          allAlbums.where((album) => album['artistId'] == artistId).toList();
      albumCount.value = artistAlbums.length;

      final artistSongs =
          allSongs
              .where(
                (song) => artistAlbums.any(
                  (album) => album['albumId'] == song['albumId'],
                ),
              )
              .toList();
      songCount.value = artistSongs.length;

      albums.value =
          artistAlbums.map((album) {
            final albumSongs =
                allSongs
                    .where((song) => song['albumId'] == album['albumId'])
                    .toList();
            double avgRating = 0.0;
            if (albumSongs.isNotEmpty) {
              avgRating = (album['rating'] ?? 0).toDouble();
            }

            return AlbumCard(
              name: album['title'] ?? '',
              image: album['coverUrl'] ?? '',
              rating: avgRating,
              albumId: album['albumId'],
            );
          }).toList();

      print("Datos musicales del artista cargados exitosamente:");
      print("- Albums: ${albumCount.value}");
      print("- Canciones: ${songCount.value}");
    } catch (e) {
      print("Error durante la carga de datos musicales del artista: $e");
      Get.snackbar(
        'Error',
        'No se pudieron cargar los datos musicales del artista',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void toggleFollowArtist() {
    final currentUserId = _authController.userId;
    if (currentUserId == null || artist.value == null) return;

    final artistName = artist.value!['name'];

    if (isUserFollowingArtist.value) {
      print("Usuario con ID $currentUserId eliminó al artista $artistName");
    } else {
      print("Usuario con ID $currentUserId agregó al artista $artistName");
    }

    isUserFollowingArtist.value = !isUserFollowingArtist.value;
  }

  @override
  void onClose() {
    print('ArtistResultController cerrado para artista ID: $artistId');
    super.onClose();
  }
}
