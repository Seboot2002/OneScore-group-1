import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:onescore/components/album_card.dart';
import 'package:onescore/controllers/auth_controller.dart';
import 'package:onescore/services/artist_service.dart';
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
  final ArtistService _artistService = ArtistService();
  final AuthController _authController = Get.find<AuthController>();
  late int artistId;
  late int userId;

  @override
  void onInit() {
    super.onInit();
    artistId = (Get.arguments as Map<String, dynamic>)['artistId'];
    userId = _authController.user!.userId;
    print('ArtistResultController inicializado con artistId: $artistId');
    getArtistData();
    print("artistId: $artistId");
  }

  Future<void> getArtistData() async {
    artist.value = {};
    albums.clear();
    albumCount.value = 0;
    songCount.value = 0;
    foundationYear.value = '';
    isLoading.value = true;

    try {
      final artistData = await _artistService.getArtistById(artistId);
      final statsData = await _artistService.getArtistStats(artistId);
      final albumList = await _artistService.getAlbumsByArtist(artistId);

      artist.value = {
        'artistId': artistData?['id'],
        'name': artistData?['name'],
        'pictureUrl': artistData?['picture_url'],
        'genre': artistData?['genre_name'],
        'foundationYear': artistData?['debut_year'].toString(),
      };

      foundationYear.value = artistData!['debut_year'].toString();
      albumCount.value = statsData?['album_count'] ?? 0;
      songCount.value = statsData?['song_count'] ?? 0;

      // 👇 Cargar ratings para cada álbum individualmente
      final List<Widget> albumWidgets = [];

      for (var album in albumList) {
        final albumId = album['id'];
        double rating = await _artistService.getAlbumAverageRating(userId, albumId);

        albumWidgets.add(
          AlbumCard(
            name: album['title'] ?? '',
            image: album['cover_url'] ?? '',
            rating: rating,
            albumId: albumId,
          ),
        );
      }

      albums.value = albumWidgets;

      print("✅ Artista cargado: ${artist.value?['name']}");
      print("- Álbumes: ${albumCount.value}");
      print("- Canciones: ${songCount.value}");
    } catch (e) {
      print("❌ Error al cargar datos del artista: $e");
      Get.snackbar(
        'Error',
        'No se pudieron cargar los datos del artista',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFollowArtist() async {
    final currentUserId = _authController.userId;
    final currentArtistId = artist.value?['artistId'];

    if (currentUserId == null || currentArtistId == null) return;

    final artistName = artist.value?['name'];

    try {
      if (isUserFollowingArtist.value) {
        print("👎 Usuario con ID $currentUserId dejó de seguir a $artistName");
        await _artistService.unfollowArtist(currentArtistId, currentUserId);
      } else {
        print("👍 Usuario con ID $currentUserId empezó a seguir a $artistName");
        await _artistService.followArtist(currentArtistId, currentUserId);
      }

      isUserFollowingArtist.value = !isUserFollowingArtist.value;
    } catch (e) {
      print("❌ Error al actualizar el estado de seguimiento: $e");
      Get.snackbar(
        'Error',
        'No se pudo actualizar el seguimiento del artista',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    print('ArtistResultController cerrado para artista ID: $artistId');
    super.onClose();
  }
}
