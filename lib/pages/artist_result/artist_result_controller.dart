import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/entities/artist.dart';
import '../../models/entities/album.dart';
import '../../models/entities/genre.dart';
import '../../models/entities/song.dart';

class ArtistResultController extends GetxController {
  var isLoading = true.obs;
  var artist = Rx<Artist?>(null);
  var genre = Rx<Genre?>(null);
  var albums = <Album>[].obs;
  var nAlbums = 0.obs;
  var nSongs = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadArtistData();
  }

  Future<void> loadArtistData() async {
    try {
      isLoading.value = true;

      // Obtener el artistId de los argumentos
      final arguments = Get.arguments;
      if (arguments == null || arguments['artistId'] == null) {
        print('Error: No se recibió artistId');
        return;
      }

      int artistId = arguments['artistId'];
      print('Cargando datos para artistId: $artistId');

      // Cargar todos los datos JSON
      final artistData = await rootBundle.loadString(
        'assets/jsons/artist.json',
      );
      final albumData = await rootBundle.loadString('assets/jsons/album.json');
      final genreData = await rootBundle.loadString('assets/jsons/genre.json');
      final songData = await rootBundle.loadString('assets/jsons/song.json');

      // Parsear JSON
      final List<dynamic> artistList = json.decode(artistData);
      final List<dynamic> albumList = json.decode(albumData);
      final List<dynamic> genreList = json.decode(genreData);
      final List<dynamic> songList = json.decode(songData);

      // Encontrar el artista específico
      final artistJson = artistList.firstWhere(
        (item) => item['artistId'] == artistId,
        orElse: () => null,
      );

      if (artistJson == null) {
        print('Error: Artista no encontrado con ID $artistId');
        return;
      }

      artist.value = Artist.fromJson(artistJson);
      print('Artista encontrado: ${artist.value!.name}');

      // Encontrar el género del artista
      final genreJson = genreList.firstWhere(
        (item) => item['genreId'] == artist.value!.genreId,
        orElse: () => null,
      );

      if (genreJson != null) {
        genre.value = Genre.fromJson(genreJson);
        print('Género encontrado: ${genre.value!.name}');
      }

      // Encontrar albums del artista
      final artistAlbums =
          albumList
              .where((item) => item['artistId'] == artistId)
              .map((item) => Album.fromJson(item))
              .toList();

      albums.value = artistAlbums;
      nAlbums.value = artistAlbums.length;
      print('Albums encontrados: ${nAlbums.value}');

      // Contar canciones del artista (a través de sus albums)
      final albumIds = artistAlbums.map((album) => album.albumId).toList();
      final artistSongs =
          songList.where((item) => albumIds.contains(item['albumId'])).toList();

      nSongs.value = artistSongs.length;
      print('Canciones encontradas: ${nSongs.value}');
    } catch (e) {
      print('Error cargando datos del artista: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
