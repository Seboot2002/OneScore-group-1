import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:onescore/models/entities/album.dart';
import 'package:onescore/models/entities/artist.dart';

class UserMusicDataService {
  Future<List<Map<String, dynamic>>> getAllAlbumsByUser(int userId) async {
    final albumJson = await rootBundle.loadString('assets/jsons/album.json');
    final userAlbumJson = await rootBundle.loadString(
      'assets/jsons/albumUser.json',
    );

    final List<dynamic> allAlbums = json.decode(albumJson);
    final List<dynamic> userAlbumsRelations = json.decode(userAlbumJson);

    print('📦 Todos los albums: $allAlbums');
    print('🔗 Relaciones usuario-album: $userAlbumsRelations');

    final userAlbumIds =
        userAlbumsRelations
            .where((relation) => relation['userId'] == userId)
            .map((relation) => relation['albumId'])
            .toSet();

    print('🆔 AlbumIds del usuario $userId: $userAlbumIds');

    final filteredAlbums =
        allAlbums
            .where((album) => userAlbumIds.contains(album['albumId']))
            .toList();

    print('🎯 Albums filtrados para el usuario: $filteredAlbums');

    return filteredAlbums
        .map<Map<String, dynamic>>(
          (album) => {
            'albumId': album['albumId'] ?? 0,
            'name': album['title'] ?? '',
            'image': album['coverUrl'] ?? '',
            'rating': album['rating'] ?? 0,
          },
        )
        .toList();
  }

  Future<List<Map<String, dynamic>>> getAllArtistsByUser(int userId) async {
    final artistJson = await rootBundle.loadString('assets/jsons/artist.json');
    final userArtistJson = await rootBundle.loadString(
      'assets/jsons/artistUser.json',
    );

    final List<dynamic> allArtists = json.decode(artistJson);
    final List<dynamic> userArtistRelations = json.decode(userArtistJson);

    print('🎨 Todos los artistas: $allArtists');
    print('🔗 Relaciones usuario-artista: $userArtistRelations');

    final userArtistIds =
        userArtistRelations
            .where((relation) => relation['userId'] == userId)
            .map((relation) => relation['artistId'])
            .toSet();

    print('🆔 ArtistIds del usuario $userId: $userArtistIds');

    final filteredArtists =
        allArtists
            .where((artist) => userArtistIds.contains(artist['artistId']))
            .toList();

    print('🎯 Artistas filtrados para el usuario: $filteredArtists');

    return filteredArtists
        .map<Map<String, dynamic>>(
          (artist) => {
            'artistId': artist['artistId'] ?? 0,
            'name': artist['name'] ?? '',
            'image': artist['pictureUrl'] ?? '',
          },
        )
        .toList();
  }

  Future<List<Map<String, dynamic>>> getAllSongsByUser(int userId) async {
    final songJson = await rootBundle.loadString('assets/jsons/song.json');
    final userSongJson = await rootBundle.loadString(
      'assets/jsons/songUser.json',
    );

    final List<dynamic> allSongs = json.decode(songJson);
    final List<dynamic> userSongRelations = json.decode(userSongJson);

    print('🎨 Todas las canciones: $allSongs');
    print('🔗 Relaciones usuario-cancion: $userSongRelations');

    final Map<int, int> userScores = {
      for (var rel in userSongRelations)
        if (rel['userId'] == userId) rel['songId']: rel['score'],
    };

    final userSongIds = userScores.keys.toSet();

    final filteredSongs =
        allSongs
            .where((song) => userSongIds.contains(song['songId']))
            .map<Map<String, dynamic>>(
              (song) => {
                'songId': song['songId'],
                'title': song['title'] ?? '',
                'nTrack': song['nTrack'],
                'albumId': song['albumId'],
                'score': userScores[song['songId']] ?? 0,
              },
            )
            .toList();

    print('🎯 Canciones filtradas para el usuario: $filteredSongs');

    return filteredSongs;
  }

  Future<List<Map<String, dynamic>>> getRecomendedAlbums() async {
    final albumJson = await rootBundle.loadString('assets/jsons/album.json');
    final userAlbumJson = await rootBundle.loadString(
      'assets/jsons/albumUser.json',
    );

    final List<dynamic> allAlbums = json.decode(albumJson);

    allAlbums.shuffle();

    print('📦 Todos los albums: $allAlbums');

    final List<Map<String, dynamic>> randomAlbums =
        allAlbums
            .take(2)
            .map<Map<String, dynamic>>(
              (album) => {
                'albumId': album['albumId'] ?? 0,
                'name': album['title'] ?? '',
                'image': album['coverUrl'] ?? '',
                'rating': album['rating'] ?? 0,
              },
            )
            .toList();

    print("2 albumes aleatorios: $randomAlbums");

    return randomAlbums;
  }

  Future<List<Map<String, dynamic>>> getRecomendedArtists() async {
    final artistJson = await rootBundle.loadString('assets/jsons/artist.json');
    final userArtistJson = await rootBundle.loadString(
      'assets/jsons/artistUser.json',
    );

    final List<dynamic> allArtists = json.decode(artistJson);

    allArtists.shuffle();

    print('📦 Todos los artistas: $allArtists');

    final List<Map<String, dynamic>> randomArtists =
        allArtists
            .take(1)
            .map<Map<String, dynamic>>(
              (artist) => {
                'artistId': artist['artistId'] ?? 0,
                'name': artist['name'] ?? '',
                'image': artist['pictureUrl'] ?? '',
              },
            )
            .toList();

    print("1 artista aleatorios: $randomArtists");

    return randomArtists;
  }

  Future<Map<String, List<Album>>> getUserAlbumsByState(int userId) async {
    final albumsJson = await rootBundle.loadString('assets/jsons/album.json');
    final albumUserJson = await rootBundle.loadString(
      'assets/jsons/albumUser.json',
    );

    final List<dynamic> albumsData = json.decode(albumsJson);
    final List<dynamic> albumUserData = json.decode(albumUserJson);

    final allAlbums = albumsData.map((e) => Album.fromJson(e)).toList();

    final userAlbumRelations =
        albumUserData
            .where((relation) => relation['userId'] == userId)
            .toList();

    print('🔗 Relaciones del usuario $userId: $userAlbumRelations');

    final valuedAlbumIds =
        userAlbumRelations
            .where((relation) => relation['rankState'] == 'valued')
            .map<int>((relation) => relation['albumId'])
            .toSet();

    final pendingAlbumIds =
        userAlbumRelations
            .where((relation) => relation['rankState'] == 'pending')
            .map<int>((relation) => relation['albumId'])
            .toSet();

    final valuedAlbums =
        allAlbums
            .where((album) => valuedAlbumIds.contains(album.albumId))
            .toList();

    final pendingAlbums =
        allAlbums
            .where((album) => pendingAlbumIds.contains(album.albumId))
            .toList();

    print('🎯 Albums valorados: ${valuedAlbums.length}');
    print('⏳ Albums pendientes: ${pendingAlbums.length}');

    return {'valued': valuedAlbums, 'pending': pendingAlbums};
  }

  Future<Map<String, List<Artist>>> getUserArtistsByState(int userId) async {
    final artistsJson = await rootBundle.loadString('assets/jsons/artist.json');
    final artistUserJson = await rootBundle.loadString(
      'assets/jsons/artistUser.json',
    );
    final albumsJson = await rootBundle.loadString('assets/jsons/album.json');
    final albumUserJson = await rootBundle.loadString(
      'assets/jsons/albumUser.json',
    );

    final List<dynamic> artistsData = json.decode(artistsJson);
    final List<dynamic> artistUserData = json.decode(artistUserJson);
    final List<dynamic> albumsData = json.decode(albumsJson);
    final List<dynamic> albumUserData = json.decode(albumUserJson);

    final allArtists = artistsData.map((e) => Artist.fromJson(e)).toList();

    final userArtistIds =
        artistUserData
            .where((relation) => relation['userId'] == userId)
            .map<int>((relation) => relation['artistId'])
            .toSet();

    print('🎨 ArtistIds del usuario $userId: $userArtistIds');

    final userArtists =
        allArtists
            .where((artist) => userArtistIds.contains(artist.artistId))
            .toList();

    List<Artist> listenedArtists = [];
    List<Artist> pendingArtists = [];

    for (Artist artist in userArtists) {
      final artistAlbumIds =
          albumsData
              .where((album) => album['artistId'] == artist.artistId)
              .map<int>((album) => album['albumId'])
              .toSet();

      print('🎵 Albums del artista ${artist.name}: $artistAlbumIds');

      final userArtistAlbums =
          albumUserData
              .where(
                (relation) =>
                    relation['userId'] == userId &&
                    artistAlbumIds.contains(relation['albumId']),
              )
              .toList();

      print(
        '📚 Albums del artista ${artist.name} que tiene el usuario: $userArtistAlbums',
      );

      if (userArtistAlbums.isEmpty) {
        pendingArtists.add(artist);
        continue;
      }

      bool allValued = userArtistAlbums.every(
        (relation) => relation['rankState'] == 'valued',
      );
      bool hasPending = userArtistAlbums.any(
        (relation) => relation['rankState'] == 'pending',
      );

      if (allValued && !hasPending) {
        listenedArtists.add(artist);
        print('✅ Artista ${artist.name} completamente escuchado');
      } else {
        pendingArtists.add(artist);
        print('⏳ Artista ${artist.name} tiene albums pendientes');
      }
    }

    print('🎯 Artistas escuchados: ${listenedArtists.length}');
    print('⏳ Artistas pendientes: ${pendingArtists.length}');

    return {'listened': listenedArtists, 'pending': pendingArtists};
  }
}
