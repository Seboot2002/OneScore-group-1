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

  AlbumResultController(this.albumId); // 👈 AÑADIDO

  var isLoading = true.obs;
  var album = Rxn<Album>();
  var songs = <Song>[].obs;
  var listenYear = 0.obs;
  var artistName = ''.obs;
  var genreName = ''.obs;
  var albumRating = 0.0.obs;
  var isUserFollowingAlbum = false.obs;
  var albumRankState = RxnString(); // 👈 Para saber si está valorado o no
  var songCount = 0.obs;

  final AuthController _authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();

    try {
      Get.find<BottomNavigationController>();
    } catch (e) {
      Get.put(BottomNavigationController());
    }

    loadAlbumData(); // ✅ ahora funciona porque albumId ya está disponible
  }

  Future<void> loadAlbumData() async {
    try {
      isUserFollowingAlbum.value = false;
      listenYear.value = 0;

      isLoading.value = true;

      await loadAlbum(albumId); // ✅ usamos la propiedad directamente
      await loadSongs(albumId);
      await loadUserAlbumData(albumId);

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
        albumRating.value = 0.0; // si luego tu API lo tiene, lo colocamos

        // Llamamos al género luego de obtener el album
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

        // Adaptamos los campos a lo que espera el modelo Song
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

        // Ordenar por número de track
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
            albumRankState.value = state; // ✅ GUARDAMOS el estado
          }

          listenYear.value = 2024; // dummy
        } else {
          print('ℹ️ Álbum NO está en la biblioteca del usuario');
          isUserFollowingAlbum.value = false;
          albumRankState.value = null; // ✨ BORRAMOS cualquier estado previo
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
