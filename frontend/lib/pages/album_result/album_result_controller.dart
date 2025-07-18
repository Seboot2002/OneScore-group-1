import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/entities/album.dart';
import '../../models/entities/song.dart';
import '../../models/entities/albumUser.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/bottom_navigation_controller.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';

class AlbumResultController extends GetxController {
  final int albumId;

  AlbumResultController(this.albumId);

  var isLoading = true.obs;
  var album = Rxn<Album>();
  var songs = <Song>[].obs;
  var listenYear = 0.obs;
  var artistName = ''.obs;
  var genreName = ''.obs;
  var albumRating = 0.0.obs;
  var isUserFollowingAlbum = false.obs;
  var albumRankState = RxnString();
  var songCount = 0.obs;

  // 🆕 NUEVO: Mapa para almacenar los ratings de cada canción
  var songRatings = <int, int>{}.obs; // songId -> rating
  var isRatingAlbum = false.obs; // Para mostrar loading durante el rating

  final AuthController _authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();

    try {
      Get.find<BottomNavigationController>();
    } catch (e) {
      Get.put(BottomNavigationController());
    }

    loadAlbumData();
  }

  // 🆕 NUEVO: Método para actualizar el rating de una canción
  void updateSongRating(int songId, int rating) {
    print('📝 Actualizando rating de canción $songId: $rating');

    if (rating < 0 || rating > 100) {
      print('❌ Rating inválido: $rating. Debe estar entre 0 y 100');
      Get.snackbar('Error', 'El rating debe estar entre 0 y 100');
      return;
    }

    songRatings[songId] = rating;
    print('🎵 Ratings actuales: $songRatings');
  }

  // 🆕 NUEVO: Método para obtener el rating de una canción
  int getSongRating(int songId) {
    return songRatings[songId] ?? 0;
  }

  // 🆕 NUEVO: Método para verificar si todas las canciones tienen rating
  bool areAllSongsRated() {
    print('🔍 Verificando si todas las canciones tienen rating...');
    print('💿 Total de canciones: ${songs.length}');
    print('⭐ Canciones con rating: ${songRatings.length}');

    for (var song in songs) {
      if (!songRatings.containsKey(song.songId) ||
          songRatings[song.songId] == 0) {
        print('❌ Canción ${song.title} (ID: ${song.songId}) sin rating');
        return false;
      }
    }

    print('✅ Todas las canciones tienen rating');
    return true;
  }

  // 🆕 NUEVO: Método para valorar el álbum completo
  Future<void> rateAlbum() async {
    print('🎯 Iniciando proceso de valoración de álbum...');

    final currentUserId = _authController.userId;
    if (currentUserId == null) {
      print('❌ No hay usuario autenticado');
      Get.snackbar('Error', 'No hay usuario autenticado');
      return;
    }

    if (album.value == null) {
      print('❌ No hay álbum cargado');
      Get.snackbar('Error', 'No hay álbum cargado');
      return;
    }

    // Verificar que todas las canciones tengan rating
    if (!areAllSongsRated()) {
      print('❌ No todas las canciones tienen rating');
      Get.snackbar('Error', 'Debes valorar todas las canciones');
      return;
    }

    try {
      isRatingAlbum.value = true;
      print('⏳ Enviando valoración al servidor...');

      // Construir el array de songRatings para la API
      final List<Map<String, dynamic>> songRatingsForApi = [];

      for (var song in songs) {
        final rating = songRatings[song.songId] ?? 0;
        songRatingsForApi.add({'songId': song.songId, 'score': rating});
        print(
          '🎵 Canción: ${song.title} (ID: ${song.songId}) - Rating: $rating',
        );
      }

      // Construir el body de la petición
      final Map<String, dynamic> requestBody = {
        'albumId': albumId,
        'userId': currentUserId,
        'songRatings': songRatingsForApi,
      };

      print('📤 Body de la petición:');
      print(jsonEncode(requestBody));

      final Uri url = Uri.parse('${Config.baseUrl}/api/albums/rate');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print('📥 Respuesta del servidor - Status: ${response.statusCode}');
      print('📥 Respuesta del servidor - Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Álbum valorado exitosamente!');
        print('📊 Resultado: ${jsonEncode(data)}');

        // Actualizar el estado local
        if (data['result'] != null) {
          final result = data['result'];
          albumRating.value = (result['average_score'] ?? 0.0).toDouble();
          albumRankState.value = result['rank_state'] ?? 'Valorado';

          print('⭐ Nuevo rating promedio: ${albumRating.value}');
          print('📌 Nuevo estado: ${albumRankState.value}');
        }

        Get.snackbar(
          'Éxito',
          'Álbum valorado correctamente',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        print('❌ Error al valorar álbum. Status: ${response.statusCode}');
        print('❌ Response body: ${response.body}');
        Get.snackbar('Error', 'No se pudo valorar el álbum');
      }
    } catch (e) {
      print('❌ Error en rateAlbum: $e');
      Get.snackbar('Error', 'Error de red al valorar álbum');
    } finally {
      isRatingAlbum.value = false;
      print('🏁 Proceso de valoración terminado');
    }
  }

  // 🆕 NUEVO: Método para cargar ratings existentes del usuario
  Future<void> loadExistingSongRatings() async {
    print('🔄 Cargando ratings existentes...');

    final currentUserId = _authController.userId;
    if (currentUserId == null) return;

    try {
      // Aquí puedes implementar la carga de ratings existentes si tu API lo permite
      // Por ahora, inicializamos con 0
      songRatings.clear();
      for (var song in songs) {
        songRatings[song.songId] = 0;
      }
      print('📝 Ratings inicializados para ${songs.length} canciones');
    } catch (e) {
      print('❌ Error cargando ratings existentes: $e');
    }
  }

  Future<void> loadAlbumData() async {
    try {
      isUserFollowingAlbum.value = false;
      listenYear.value = 0;

      isLoading.value = true;

      await loadAlbum(albumId);
      await loadSongs(albumId);
      await loadUserAlbumData(albumId);

      // 🆕 NUEVO: Cargar ratings existentes después de cargar las canciones
      await loadExistingSongRatings();

      isLoading.value = false;
    } catch (e) {
      print('Error loading album data: $e');
      isLoading.value = false;
    }
  }

  Future<void> loadAlbum(int albumId) async {
    try {
      final Uri url = Uri.parse('${Config.baseUrl}/api/albums/$albumId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final adapted = {
          'albumId': data['id'],
          'title': data['title'],
          'releaseYear': data['release_year'],
          'genreId': data['genre_id'],
          'coverUrl': data['cover_url'],
          'artistId': data['artist_id'],
        };

        print('🎵 AlbumData (adapted): ${jsonEncode(adapted)}');

        album.value = Album.fromJson(adapted);
        albumRating.value = 0.0;

        await loadGenre(data['genre_id']);
      } else {
        print('❌ Error loading album. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error loading album: $e');
    }
  }

  Future<void> loadGenre(int genreId) async {
    try {
      final Uri url = Uri.parse('${Config.baseUrl}/api/genres/$genreId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final adapted = {'genreId': data['id'], 'name': data['name']};

        print('🎼 Genre (adapted): ${jsonEncode(adapted)}');
        genreName.value = adapted['name'] ?? '';
      } else {
        print('❌ Error loading genre. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error loading genre: $e');
    }
  }

  Future<void> loadSongs(int albumId) async {
    try {
      final Uri url = Uri.parse(
        '${Config.baseUrl}/api/albums/album-songs/$albumId',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final List<Song> albumSongs =
            data.map((item) {
              final adapted = {
                'songId': item['id'],
                'title': item['title'],
                'nTrack': item['n_track'],
                'albumId': item['album_id'],
              };
              return Song.fromJson(adapted);
            }).toList();

        albumSongs.sort((a, b) => a.nTrack.compareTo(b.nTrack));

        songs.value = albumSongs;
        songCount.value = albumSongs.length;

        print('🎶 Songs loaded from backend (${albumSongs.length}):');
        for (var song in albumSongs) {
          print(song.toJson());
        }
      } else {
        print('❌ Failed to load songs. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching songs: $e');
    }
  }

  Future<void> loadUserAlbumData(int albumId) async {
    try {
      final currentUserId = _authController.userId;
      if (currentUserId == null) return;

      final Uri url = Uri.parse(
        '${Config.baseUrl}/api/albums/check-user-album/$currentUserId/$albumId',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['exists'] == true) {
          print('✅ Álbum está en la biblioteca del usuario');
          isUserFollowingAlbum.value = true;
          await fetchUserAlbumRating(currentUserId, albumId);

          if (data.containsKey('rank_state')) {
            final state = data['rank_state'];
            print('📌 Estado del álbum: $state');
            albumRankState.value = state;
          }

          listenYear.value = 2024;
        } else {
          print('ℹ️ Álbum NO está en la biblioteca del usuario');
          isUserFollowingAlbum.value = false;
          albumRankState.value = null;
          listenYear.value = 0;
        }
      } else {
        print('❌ Error consultando user-album. Status: ${response.statusCode}');
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

  Future<void> fetchUserAlbumRating(int userId, int albumId) async {
    try {
      final Uri url = Uri.parse(
        '${Config.baseUrl}/api/albums/average-rating/$userId/$albumId',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final double avg = (data['average'] ?? 0).toDouble();
        print('⭐️ Álbum rating promedio del usuario: $avg');
        albumRating.value = avg;
      } else {
        print(
          '❌ Error obteniendo rating del álbum. Status: ${response.statusCode}',
        );
        albumRating.value = 0.0;
      }
    } catch (e) {
      print('❌ Error en fetchUserAlbumRating: $e');
      albumRating.value = 0.0;
    }
  }

  Future<void> addAlbumToUser() async {
    final currentUserId = _authController.userId;
    if (currentUserId == null || album.value == null) return;

    final int albumId = album.value!.albumId;
    final Uri url = Uri.parse(
      '${Config.baseUrl}/api/albums/user/$currentUserId/$albumId',
    );

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        print('✅ Álbum agregado con éxito a la biblioteca');
        isUserFollowingAlbum.value = true;
        albumRankState.value = 'Por valorar';

        await fetchUserAlbumRating(currentUserId, albumId);
      } else {
        print('❌ Error al agregar álbum. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error al agregar álbum: $e');
    }
  }

  Future<void> deleteAlbumFromUser() async {
    final currentUserId = _authController.userId;
    if (currentUserId == null || album.value == null) return;

    final int albumId = album.value!.albumId;
    final Uri url = Uri.parse(
      '${Config.baseUrl}/api/albums/user/$currentUserId/$albumId',
    );

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print('🗑 Álbum eliminado con éxito de la biblioteca');
        isUserFollowingAlbum.value = false;
        albumRankState.value = null;
        listenYear.value = 0;
        albumRating.value = 0.0;

        // 🆕 NUEVO: Limpiar ratings al eliminar álbum
        songRatings.clear();

        Get.snackbar('Eliminado', 'Álbum eliminado correctamente');
      } else {
        print('❌ Error al eliminar álbum. Status: ${response.statusCode}');
        Get.snackbar('Error', 'No se pudo eliminar el álbum');
      }
    } catch (e) {
      print('❌ Error al eliminar álbum: $e');
      Get.snackbar('Error', 'Error de red al eliminar álbum');
    }
  }
}
