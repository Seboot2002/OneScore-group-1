import 'dart:convert';

import 'package:flutter/services.dart';

class UserMusicDataService {
  Future<List<Map<String, dynamic>>> getAllAlbumsByUser(int userId) async {
    final albumJson = await rootBundle.loadString('assets/jsons/album.json');
    final userAlbumJson = await rootBundle.loadString('assets/jsons/albumUser.json');

    final List<dynamic> allAlbums = json.decode(albumJson);
    final List<dynamic> userAlbumsRelations = json.decode(userAlbumJson);

    print('📦 Todos los albums: $allAlbums');
    print('🔗 Relaciones usuario-album: $userAlbumsRelations');

    final userAlbumIds = userAlbumsRelations
        .where((relation) => relation['userId'] == userId)
        .map((relation) => relation['albumId'])
        .toSet();

    print('🆔 AlbumIds del usuario $userId: $userAlbumIds');

    final filteredAlbums = allAlbums
        .where((album) => userAlbumIds.contains(album['albumId']))
        .toList();

    print('🎯 Albums filtrados para el usuario: $filteredAlbums');

    return filteredAlbums.map<Map<String, dynamic>>((album) => {
      'albumId': album['albumId'] ?? 0,
      'name': album['title'] ?? '',
      'image': album['coverUrl'] ?? '',
      'rating': album['rating'] ?? 0,
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getAllArtistsByUser(int userId) async {
    final artistJson = await rootBundle.loadString('assets/jsons/artist.json');
    final userArtistJson = await rootBundle.loadString('assets/jsons/artistUser.json');

    final List<dynamic> allArtists = json.decode(artistJson);
    final List<dynamic> userArtistRelations = json.decode(userArtistJson);

    print('🎨 Todos los artistas: $allArtists');
    print('🔗 Relaciones usuario-artista: $userArtistRelations');

    final userArtistIds = userArtistRelations
        .where((relation) => relation['userId'] == userId)
        .map((relation) => relation['artistId'])
        .toSet();

    print('🆔 ArtistIds del usuario $userId: $userArtistIds');

    final filteredArtists = allArtists
        .where((artist) => userArtistIds.contains(artist['artistId']))
        .toList();

    print('🎯 Artistas filtrados para el usuario: $filteredArtists');

    return filteredArtists.map<Map<String, dynamic>>((artist) => {
      'name': artist['name'] ?? '',
      'image': artist['pictureUrl'] ?? '',
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getAllSongsByUser(int userId) async {
    final songJson = await rootBundle.loadString('assets/jsons/song.json');
    final userSongJson = await rootBundle.loadString('assets/jsons/songUser.json');

    final List<dynamic> allSongs = json.decode(songJson);
    final List<dynamic> userSongRelations = json.decode(userSongJson);

    print('🎨 Todas las canciones: $allSongs');
    print('🔗 Relaciones usuario-cancion: $userSongRelations');

    final Map<int, int> userScores = {
      for (var rel in userSongRelations)
        if (rel['userId'] == userId) rel['songId']: rel['score']
    };

    final userSongIds = userScores.keys.toSet();

    final filteredSongs = allSongs
        .where((song) => userSongIds.contains(song['songId']))
        .map<Map<String, dynamic>>((song) => {
      'songId': song['songId'],
      'title': song['title'] ?? '',
      'nTrack': song['nTrack'],
      'albumId': song['albumId'],
      'score': userScores[song['songId']] ?? 0,
    }).toList();

    print('🎯 Canciones filtradas para el usuario: $filteredSongs');

    return filteredSongs;
  }


}