import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/entities/album.dart';
import '../../models/entities/song.dart';
import '../../models/entities/albumUser.dart';
import '../../controllers/auth_controller.dart';

class AlbumResultController extends GetxController {
  var isLoading = true.obs;
  var album = Rxn<Album>();
  var songs = <Song>[].obs;
  var listenYear = 0.obs;
  var artistName = ''.obs;
  var genreName = ''.obs;
  var albumRating = 0.0.obs;
  var isUserFollowingAlbum = false.obs;
  var songCount = 0.obs;

  final AuthController _authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    loadAlbumData();
  }

  Future<void> loadAlbumData() async {
    try {
      isLoading.value = true;

      // Obtener el albumId de los argumentos de navegación
      int albumId = Get.arguments ?? 1;

      // Cargar datos del álbum
      await loadAlbum(albumId);

      // Cargar canciones del álbum
      await loadSongs(albumId);

      // Cargar datos del artista
      await loadArtistData();

      // Cargar año de escucha y verificar si el usuario sigue el álbum
      await loadUserAlbumData(albumId);

      isLoading.value = false;
    } catch (e) {
      print('Error loading album data: $e');
      isLoading.value = false;
    }
  }

  Future<void> loadAlbum(int albumId) async {
    try {
      final String response = await rootBundle.loadString(
        'assets/jsons/album.json',
      );
      final List<dynamic> data = json.decode(response);

      final albumData = data.firstWhere(
        (item) => item['albumId'] == albumId,
        orElse: () => null,
      );

      if (albumData != null) {
        album.value = Album.fromJson(albumData);
        albumRating.value = (albumData['rating'] ?? 0.0).toDouble();
      }
    } catch (e) {
      print('Error loading album: $e');
    }
  }

  Future<void> loadSongs(int albumId) async {
    try {
      final String response = await rootBundle.loadString(
        'assets/jsons/song.json',
      );
      final List<dynamic> data = json.decode(response);

      final albumSongs =
          data
              .where((item) => item['albumId'] == albumId)
              .map((item) => Song.fromJson(item))
              .toList();

      // Ordenar por número de track
      albumSongs.sort((a, b) => a.nTrack.compareTo(b.nTrack));

      songs.value = albumSongs;
      songCount.value = albumSongs.length;
    } catch (e) {
      print('Error loading songs: $e');
    }
  }

  Future<void> loadArtistData() async {
    try {
      if (album.value == null) return;

      // Cargar datos del artista
      final String artistResponse = await rootBundle.loadString(
        'assets/jsons/artist.json',
      );
      final List<dynamic> artistData = json.decode(artistResponse);

      final artist = artistData.firstWhere(
        (item) => item['artistId'] == album.value!.artistId,
        orElse: () => null,
      );

      if (artist != null) {
        artistName.value = artist['name'] ?? '';

        // Cargar género
        final String genreResponse = await rootBundle.loadString(
          'assets/jsons/genre.json',
        );
        final List<dynamic> genreData = json.decode(genreResponse);

        final genre = genreData.firstWhere(
          (item) => item['genreId'] == artist['genreId'],
          orElse: () => null,
        );

        if (genre != null) {
          genreName.value = genre['name'] ?? '';
        }
      }
    } catch (e) {
      print('Error loading artist data: $e');
    }
  }

  Future<void> loadUserAlbumData(int albumId) async {
    try {
      final String response = await rootBundle.loadString(
        'assets/jsons/albumUser.json',
      );
      final List<dynamic> data = json.decode(response);

      final currentUserId = _authController.userId;
      if (currentUserId == null) return;

      final albumUserData = data.firstWhere(
        (item) => item['albumId'] == albumId && item['userId'] == currentUserId,
        orElse: () => null,
      );

      if (albumUserData != null) {
        final albumUser = AlbumUser.fromJson(albumUserData);
        listenYear.value = albumUser.listenYear;
        isUserFollowingAlbum.value = true;
      } else {
        listenYear.value = 0;
        isUserFollowingAlbum.value = false;
      }
    } catch (e) {
      print('Error loading user album data: $e');
    }
  }

  void toggleFollowAlbum() {
    final currentUserId = _authController.userId;
    if (currentUserId == null || album.value == null) return;

    final albumName = album.value!.title;

    if (isUserFollowingAlbum.value) {
      print("Usuario con ID $currentUserId a guardado al album $albumName");
    } else {
      print("Usuario con ID $currentUserId agrego al album $albumName");
    }

    // Toggle del estado (en una implementación real, esto se haría después de la operación exitosa)
    isUserFollowingAlbum.value = !isUserFollowingAlbum.value;
  }

  void removeAlbum() {
    final currentUserId = _authController.userId;
    if (currentUserId == null || album.value == null) return;

    final albumName = album.value!.title;
    print("Usuario con ID $currentUserId eliminó el album $albumName");

    isUserFollowingAlbum.value = false;
    listenYear.value = 0;
  }
}
