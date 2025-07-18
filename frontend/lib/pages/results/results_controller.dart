import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/entities/album.dart';
import '../../models/entities/artist.dart';
import '../../models/entities/user.dart';
import '../../components/album_card.dart';
import '../../components/artist_card.dart';
import '../../components/user_card.dart';
import '../../controllers/auth_controller.dart';
import '../../services/userMusicData_service.dart';

class ResultsController extends GetxController {
  List<dynamic> results = [];
  String searchType = '';
  String searchQuery = '';

  final UserMusicDataService _musicService = UserMusicDataService();
  late AuthController authControl;
  late int userId;

  @override
  void onInit() {
    super.onInit();
    authControl = Get.find<AuthController>();
    userId = authControl.user!.userId;
    _loadArguments();
  }

  @override
  void onReady() {
    super.onReady();
    _loadArguments();
    update();
  }

  void _loadArguments() {
    final arguments = Get.arguments;

    results.clear();
    searchType = '';
    searchQuery = '';

    if (arguments != null) {
      results = List<dynamic>.from(arguments['results'] ?? []);
      searchType = arguments['searchType'] ?? '';
      searchQuery = arguments['searchQuery'] ?? '';

      print("🔍 Tipo de búsqueda: $searchType");
      print("📝 Query de búsqueda: $searchQuery");
      print("📦 Cantidad de resultados: ${results.length}");
    } else {
      print("⚠️ No se recibieron argumentos en ResultsController");
    }
  }

  @override
  void onClose() {
    results.clear();
    searchType = '';
    searchQuery = '';
    super.onClose();
  }

  String get displaySearchType {
    switch (searchType) {
      case 'Albums':
        return 'Albums';
      case 'Artistas':
        return 'Artistas';
      case 'Usuarios':
        return 'Usuarios';
      case 'Todos':
        return 'Todos';
      default:
        return searchType;
    }
  }

  List<Widget> get albumWidgets {
    List<dynamic> albumItems;
    if (searchType == 'Todos') {
      albumItems = results.where((item) => item['type'] == 'album').toList();
    } else if (searchType == 'Albums') {
      albumItems = results;
    } else {
      albumItems = [];
    }

    return albumItems.map<Widget>((item) {
      final album = Album.fromSearchJson(item['data']);

      return FutureBuilder<double>(
        future: _musicService.getUserAlbumRating(album.albumId, userId),
        builder: (context, snapshot) {
          final rating =
              snapshot.hasData
                  ? double.parse(snapshot.data!.toStringAsFixed(2))
                  : 0.0;

          return AlbumCard(
            name: album.title,
            image: album.coverUrl ?? '',
            rating: rating,
            albumId: album.albumId,
          );
        },
      );
    }).toList();
  }

  List<Widget> get artistWidgets {
    List<Artist> artists;
    if (searchType == 'Todos') {
      artists =
          results
              .where((item) => item['type'] == 'artist')
              .map((item) => item['data'] as Artist)
              .toList();
    } else if (searchType == 'Artistas') {
      artists = results.cast<Artist>();
    } else {
      artists = [];
    }

    return artists
        .map(
          (artist) => ArtistCard(
            name: artist.name,
            image: artist.pictureUrl ?? '',
            artistId: artist.artistId,
          ),
        )
        .toList();
  }

  List<Widget> get userWidgets {
    List<User> users;
    if (searchType == 'Todos') {
      users =
          results
              .where((item) => item['type'] == 'user')
              .map((item) => item['data'] as User)
              .toList();
    } else if (searchType == 'Usuarios') {
      users = results.cast<User>();
    } else {
      users = [];
    }

    return users
        .map(
          (user) => UserCard(
            name: '${user.name} ${user.lastName}',
            image: user.photoUrl ?? '',
            userId: user.userId,
          ),
        )
        .toList();
  }

  List<Map<String, dynamic>> get buttonsData {
    List<Map<String, dynamic>> buttons = [];

    if (searchType == 'Todos') {
      buttons = [
        {
          'value': true,
          'label': 'Todos',
          'data': [...albumWidgets, ...artistWidgets, ...userWidgets],
        },
        {'value': false, 'label': 'Albums', 'data': albumWidgets},
        {'value': false, 'label': 'Artistas', 'data': artistWidgets},
        {'value': false, 'label': 'Usuarios', 'data': userWidgets},
      ];
    } else if (searchType == 'Albums') {
      buttons = [
        {'value': true, 'label': 'Albums', 'data': albumWidgets},
      ];
    } else if (searchType == 'Artistas') {
      buttons = [
        {'value': true, 'label': 'Artistas', 'data': artistWidgets},
      ];
    } else if (searchType == 'Usuarios') {
      buttons = [
        {'value': true, 'label': 'Usuarios', 'data': userWidgets},
      ];
    }

    return buttons;
  }

  bool get hasResults => results.isNotEmpty;
  int get totalResults => results.length;
}
