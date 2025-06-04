import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:onescore/components/album_card.dart';
import 'package:onescore/components/artist_card.dart';
import 'package:onescore/services/userMusicData_service.dart';
import 'package:onescore/services/user_service.dart';
import '../../models/entities/user.dart';

class UserResultController extends GetxController {
  var isLoading = false.obs;
  var user = Rxn<User>();
  var userData = <String, dynamic>{}.obs;
  var albums = <Widget>[].obs;
  var artists = <Widget>[].obs;
  var albumCount = 0.obs;
  var artistCount = 0.obs;
  var songCount = 0.obs;

  final UserMusicDataService _musicService = UserMusicDataService();
  final UserService _userService = UserService();
  late int userId;

  @override
  void onInit() {
    super.onInit();
    // Obtener el userId de los argumentos
    userId = Get.arguments as int;
    print('UserResultController inicializado con userId: $userId');
    getUserData();
  }

  Future<void> getUserData() async {
    print("Iniciando carga de datos del usuario con ID: $userId");
    isLoading.value = true;

    try {
      // Obtener usuario real usando tu servicio
      final userData = await _userService.getUserById(userId);

      if (userData == null) {
        print("❌ Usuario con ID $userId no encontrado");
        Get.snackbar(
          'Error',
          'Usuario no encontrado',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      user.value = userData;
      print("✅ Usuario cargado: ${userData.nickname}");

      // Una vez que tengas los datos del usuario, obtén sus datos musicales
      await getUserMusicData();
    } catch (e) {
      print("Error al obtener datos del usuario: $e");
      Get.snackbar(
        'Error',
        'No se pudieron cargar los datos del usuario',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      print("Carga finalizada para usuario ID: $userId");
    }
  }

  Future<void> getUserMusicData() async {
    print("Iniciando carga de datos musicales para usuario ID: $userId");

    try {
      final albumData = await _musicService.getAllAlbumsByUser(userId);
      final artistData = await _musicService.getAllArtistsByUser(userId);
      final songData = await _musicService.getAllSongsByUser(userId);

      albumCount.value = albumData.length;
      artistCount.value = artistData.length;
      songCount.value = songData.length;

      Map<int, List<double>> albumScores = {};

      albums.value =
          albumData.map((album) {
            final albumId = album['albumId'] as int;

            for (var song in songData) {
              final score = (song['score'] ?? 0).toDouble();

              if (!albumScores.containsKey(albumId)) {
                albumScores[albumId] = [];
              }
              albumScores[albumId]!.add(score);
            }
            final scores = albumScores[albumId] ?? [];
            final avgScore =
                scores.isNotEmpty
                    ? scores.reduce((a, b) => a + b) / scores.length
                    : 0.0;

            return AlbumCard(
              name: album['name'],
              image: album['image'],
              rating: avgScore,
              albumId: album['albumId'],
            );
          }).toList();

      artists.value =
          artistData
              .map(
                (artist) => ArtistCard(
                  name: artist['name'],
                  image: artist['image'],
                  artistId: artist['artistId'],
                ),
              )
              .toList();

      print("Datos musicales cargados exitosamente:");
      print("- Albums: ${albumCount.value}");
      print("- Artistas: ${artistCount.value}");
      print("- Canciones: ${songCount.value}");
    } catch (e) {
      print("Error durante la carga de datos musicales: $e");
      // Opcional: mostrar un snackbar de error
      Get.snackbar(
        'Error',
        'No se pudieron cargar los datos musicales del usuario',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    // Limpiar datos cuando se cierre el controller
    print('UserResultController cerrado para usuario ID: $userId');
    super.onClose();
  }
}
