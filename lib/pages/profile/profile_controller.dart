import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:onescore/components/album_card.dart';
import 'package:onescore/components/artist_card.dart';
import 'package:onescore/controllers/auth_controller.dart';
import 'package:onescore/services/userMusicData_service.dart';

class ProfileController extends GetxController {

  var isLoading = false.obs;
  var userData = <String, dynamic>{}.obs;

  var albums = <Widget>[].obs;
  var artists = <Widget>[].obs;

  var albumCount = 0.obs;
  var artistCount = 0.obs;
  var songCount = 0.obs;

  final UserMusicDataService _musicService = UserMusicDataService();

  late AuthController authControl;
  late int userId;

  @override
  void onInit() {
    super.onInit();
    authControl = Get.put(AuthController());
    userId = authControl.user!.userId;

    getUserMusicData();
  }

  Future<void> getUserMusicData() async {
    print("Iniciando carga de datos...");
    isLoading.value = true;

    try {

      final albumData = await _musicService.getAllAlbumsByUser(userId);
      final artistData = await _musicService.getAllArtistsByUser(userId);
      final songData = await _musicService.getAllSongsByUser(userId);

      albumCount.value = albumData.length;
      artistCount.value = artistData.length;
      songCount.value = songData.length;

      albums.value = albumData.map((album) => AlbumCard(
        name: album['name'],
        image: album['image'],
        rating: (album['rating'] as num).toDouble(),
      )).toList();

      artists.value = artistData.map((artist) => ArtistCard(
        name: artist['name'],
        image: artist['image'],
      )).toList();

    } catch (e) {
      print("Error durante la carga de datos: $e");
    } finally {
      isLoading.value = false;
      print("Carga finalizada");
    }
  }
}