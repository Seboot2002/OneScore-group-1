import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:onescore/models/entities/album.dart';
import 'package:onescore/models/entities/artist.dart';
import 'package:http/http.dart' as http;

class UserMusicDataService {
  final String baseUrl = "https://onescore.loca.lt/";

  Future<List<Map<String, dynamic>>> getAllAlbumsByUser(int userId) async {
    final url = Uri.parse('${baseUrl}api/users/user-albums/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        print('🎯 Albums recibidos para el usuario $userId: $data');

        return data.map<Map<String, dynamic>>((album) {
          return {
            'albumId': album['album_id'] ?? 0,
            'name': album['album_title'] ?? '',
            'image': album['cover_url'] ?? '',
            'rating': album['rank_state'] ?? 0,
            'artist': {
              'id': album['artist_id'],
              'name': album['artist_name'],
              'image': album['artist_picture_url'],
            },
          };
        }).toList();
      } else if (response.statusCode == 404) {
        print('❌ No se encontraron álbumes para el usuario $userId');
        return [];
      } else {
        print('❌ Error inesperado: ${response.body}');
        return [];
      }
    } catch (e) {
      print('❌ Error al conectar con el servidor: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllArtistsByUser(int userId) async {
    final url = Uri.parse('${baseUrl}api/users/user-artists/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        print('🎯 Artistas recibidos para el usuario $userId: $data');

        return data.map<Map<String, dynamic>>((artist) {
          return {
            'artistId': artist['artist_id'] ?? 0,
            'name': artist['artist_name'] ?? '',
            'image': artist['picture_url'] ?? '',
            'genreId': artist['genre_id'],
            'debutYear': artist['debut_year'],
            'rating': artist['rank_state'],
          };
        }).toList();
      } else if (response.statusCode == 404) {
        print('❌ No se encontraron artistas para el usuario $userId');
        return [];
      } else {
        print('❌ Error inesperado: ${response.body}');
        return [];
      }
    } catch (e) {
      print('❌ Error al conectar con el servidor: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllSongsByUser(int userId) async {
    final url = Uri.parse('${baseUrl}api/users/user-songs/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map<Map<String, dynamic>>((song) {
          return {
            'songId': song['song_id'],
            'title': song['title'] ?? '',
            'nTrack': song['n_track'],
            'albumId': song['album_id'],
            'score': song['score'],
          };
        }).toList();
      } else {
        print('❌ Error cargando canciones del usuario: ${response.body}');
        return [];
      }
    } catch (e) {
      print('❌ Error de conexión: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getRecomendedAlbums(int userId) async {
    final url = Uri.parse('${baseUrl}/api/albums/recommend-albums/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          return data.map<Map<String, dynamic>>((album) {
            return {
              'albumId': album['id'] ?? 0,
              'name': album['title'] ?? '',
              'image': album['cover_url'] ?? '',
              'rating': 0,
            };
          }).toList();
        } else if (data is Map && data.containsKey('message')) {
          print('ℹ️ Sin recomendaciones: ${data['message']}');
          return [];
        } else {
          print('⚠️ Respuesta inesperada: $data');
          return [];
        }
      } else {
        print('❌ Error del servidor: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Error al conectar: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getRecomendedArtists(int userId) async {
    final url = Uri.parse('${baseUrl}/api/artists/recommend/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Verificamos que el servidor devolvió un artista
        if (data is Map && data.containsKey('id')) {
          final artist = {
            'artistId': data['id'] ?? 0,
            'name': data['name'] ?? '',
            'image': data['picture_url'] ?? '',
          };

          return [artist]; // Devolvemos una lista con un solo artista
        }

        // Si el servidor devuelve un mensaje diciendo que no hay recomendaciones
        if (data is Map && data.containsKey('message')) {
          print('ℹ️ Sin recomendaciones: ${data['message']}');
          return [];
        }

        print('⚠️ Formato inesperado de respuesta: $data');
        return [];
      } else {
        print('❌ Error del servidor: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Error al conectar: $e');
      return [];
    }
  }

  Future<Map<String, List<Album>>> getUserAlbumsByState(int userId) async {
    final url = Uri.parse('${baseUrl}/api/albums/user-albums-by-state/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final valuedAlbums =
            (data['valued'] as List)
                .map((albumJson) => Album.fromJson(albumJson))
                .toList();

        final pendingAlbums =
            (data['pending'] as List)
                .map((albumJson) => Album.fromJson(albumJson))
                .toList();

        return {'valued': valuedAlbums, 'pending': pendingAlbums};
      } else {
        print('❌ Error: ${response.statusCode}');
        return {'valued': [], 'pending': []};
      }
    } catch (e) {
      print('❌ Error en conexión: $e');
      return {'valued': [], 'pending': []};
    }
  }

  Future<Map<String, List<Artist>>> getUserArtistsByState(int userId) async {
    final url = Uri.parse('$baseUrl/api/artists/user-artists-by-state/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final listenedArtists =
            (data['listened'] as List)
                .map((json) => Artist.fromJson(json))
                .toList();

        final pendingArtists =
            (data['pending'] as List)
                .map((json) => Artist.fromJson(json))
                .toList();

        return {'listened': listenedArtists, 'pending': pendingArtists};
      } else {
        print('❌ Error HTTP: ${response.statusCode}');
        return {'listened': [], 'pending': []};
      }
    } catch (e) {
      print('❌ Error de red: $e');
      return {'listened': [], 'pending': []};
    }
  }

  Future<double> getUserAlbumRating(int albumId, int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/albums/average-rating/$userId/$albumId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['average'] ?? 0).toDouble();
    } else {
      throw Exception('Error al obtener promedio del álbum');
    }
  }
}
