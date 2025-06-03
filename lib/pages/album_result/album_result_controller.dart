import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/entities/album.dart';
import '../../models/entities/song.dart';
import '../../models/entities/albumUser.dart';

class AlbumResultController extends GetxController {
  var isLoading = true.obs;
  var album = Rxn<Album>();
  var songs = <Song>[].obs;
  var listenYear = 0.obs;

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

      // Cargar año de escucha
      await loadListenYear(albumId);

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
    } catch (e) {
      print('Error loading songs: $e');
    }
  }

  Future<void> loadListenYear(int albumId) async {
    try {
      final String response = await rootBundle.loadString(
        'assets/jsons/albumUser.json',
      );
      final List<dynamic> data = json.decode(response);

      final albumUserData = data.firstWhere(
        (item) => item['albumId'] == albumId,
        orElse: () => null,
      );

      if (albumUserData != null) {
        final albumUser = AlbumUser.fromJson(albumUserData);
        listenYear.value = albumUser.listenYear;
      }
    } catch (e) {
      print('Error loading listen year: $e');
    }
  }
}
