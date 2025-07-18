import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onescore/config.dart';

class ArtistService {
  final String baseUrl = Config.baseUrl;

  Future<Map<String, dynamic>?> getArtistById(int artistId) async {
    final url = Uri.parse('$baseUrl/api/artists/$artistId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('❌ Error ${response.statusCode}: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error de red: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getArtistStats(int artistId) async {
    final url = Uri.parse('$baseUrl/api/artists/artist-stats/$artistId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('❌ Error de red (getArtistStats): $e');
    }
    return null;
  }

  Future<List<dynamic>> getAlbumsByArtist(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/albums/artist/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Error al obtener álbumes del artista');
    }
  }

  Future<void> followArtist(int artistId, int userId) async {
    final url = Uri.parse('$baseUrl/api/artists/artist-add-user/$artistId/$userId');
    final response = await http.post(url);

    if (response.statusCode == 201) {
      print('✅ ${json.decode(response.body)['message']}');
    } else {
      throw Exception('Error al seguir al artista');
    }
  }

  Future<void> unfollowArtist(int artistId, int userId) async {
    final url = Uri.parse('$baseUrl/api/artists/user/$userId/$artistId');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('✅ ${json.decode(response.body)['message']}');
    } else {
      throw Exception('Error al dejar de seguir al artista');
    }
  }

  Future<double> getAlbumAverageRating(int userId, int albumId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/albums/average-rating/$userId/$albumId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['average'] ?? 0).toDouble();
      } else {
        print("⚠️ Error ${response.statusCode} al obtener rating del álbum $albumId");
        return 0.0;
      }
    } catch (e) {
      print("❌ Excepción al obtener rating del álbum $albumId: $e");
      return 0.0;
    }
  }

}