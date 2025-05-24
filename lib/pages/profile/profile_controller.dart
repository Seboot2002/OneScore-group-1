import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:onescore/components/album_card.dart';
import 'package:onescore/components/artist_card.dart';

class ProfileController extends GetxController {

  var isLoading = false.obs;
  var userData = <String, dynamic>{}.obs;

  var albums = <Widget>[].obs;
  var artists = <Widget>[].obs;

  final UserServiceTesting _userService = UserServiceTesting();
  final MusicServiceTesting _musicService = MusicServiceTesting();

  Future<void> getUserData() async {
    print("Iniciando carga de datos...");
    isLoading.value = true;

    try {
      userData.value = await _userService.fetchUserData();
      print("Datos del usuario cargados: ${userData.value}");

      final albumData = await _musicService.getAllAlbumsByUser();
      final artistData = await _musicService.getAllArtistsByUser();

      albums.value = albumData.map((album) => AlbumCard(
        name: album['name'],
        image: album['image'],
        rating: (album['rating'] as num).toDouble(),
      )).toList();

      artists.value = artistData.map((artist) => ArtistCard(
        name: artist['name'],
        image: artist['image'],
      )).toList();

      print("✅ Álbumes creados: ${albums.length}");
      print("✅ Artistas creados: ${artists.length}");

    } catch (e) {
      print("Error durante la carga de datos: $e");
    } finally {
      isLoading.value = false;
      print("Carga finalizada");
    }
  }
}

class UserServiceTesting {
  Future<Map<String, dynamic>> fetchUserData() async {
    await Future.delayed(Duration(seconds: 1)); // Simula un retraso de red/API

    return {
      'username': '@Seboot2002',
      'name': 'Sebastián Camayo',
      'avatar': 'assets/imgs/mod1_01.jpg',
      'statistics': {
        'artists': 22,
        'albums': 98,
        'songs': 1102,
      }
    };
  }
}

class MusicServiceTesting {
  Future<List<Map<String, dynamic>>> getAllAlbumsByUser() async {
    await Future.delayed(Duration(seconds: 1)); // Simula una llamada a API

    return [
      {'name': 'AAAA', 'image': 'https://via.placeholder.com/150', 'rating': 12},
      {'name': 'BBBB', 'image': 'https://via.placeholder.com/150', 'rating': 14},
      {'name': 'CCCC', 'image': 'https://via.placeholder.com/150', 'rating': 17},
      {'name': 'DDDD', 'image': 'https://via.placeholder.com/150', 'rating': 21},
      {'name': 'EEEE', 'image': 'https://via.placeholder.com/150', 'rating': 9},
      {'name': 'FFFF', 'image': 'https://via.placeholder.com/150', 'rating': 11},
    ];
  }

  Future<List<Map<String, dynamic>>> getAllArtistsByUser() async {
    await Future.delayed(Duration(seconds: 1)); // Simula una llamada a API

    return [
      {'name': 'GGGG', 'image': 'https://via.placeholder.com/150'},
      {'name': 'HHHH', 'image': 'https://via.placeholder.com/150'},
      {'name': 'IIII', 'image': 'https://via.placeholder.com/150'},
      {'name': 'JJJJ', 'image': 'https://via.placeholder.com/150'},
      {'name': 'KKKK', 'image': 'https://via.placeholder.com/150'},
      {'name': 'LLLL', 'image': 'https://via.placeholder.com/150'},
    ];
  }
}