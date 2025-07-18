import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../models/entities/album.dart';
import '../../models/entities/artist.dart';
import '../../models/entities/user.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';
import '../controllers/auth_controller.dart';

class SearchService {
  // Funciones finales
  static Future<List<Artist>> searchArtists(String query) async {
    if (query.trim().isEmpty) return [];

    final Uri url = Uri.parse('${Config.baseUrl}/api/artists/search/$query');
    print("🎤 Consultando artistas: $url");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print("✅ Artistas encontrados: ${data.length}");

        return data.map((item) => Artist.fromSearchJson(item)).toList();
      } else {
        print("⚠️ Error ${response.statusCode}: ${response.reasonPhrase}");
        return [];
      }
    } catch (e) {
      print("❌ Excepción al buscar artistas: $e");
      return [];
    }
  }

  static Future<List<User>> searchUsers(String query) async {
    if (query.trim().isEmpty) return [];

    final Uri url = Uri.parse('${Config.baseUrl}/api/users/search/$query');
    print("👤 Consultando usuarios: $url");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print("✅ Usuarios encontrados: ${data.length}");

        return data.map((item) => User.fromSearchJson(item)).toList();
      } else {
        print("⚠️ Error ${response.statusCode}: ${response.reasonPhrase}");
        return [];
      }
    } catch (e) {
      print("❌ Excepción al buscar usuarios: $e");
      return [];
    }
  }

  // Dentro de SearchService
  static Future<List<Map<String, dynamic>>> fetchAlbumsFromApi(
    String keyword,
  ) async {
    final url = Uri.parse('${Config.baseUrl}/api/albums/search/$keyword');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> albums = json.decode(response.body);

      final userId = Get.find<AuthController>().userId;

      // Ahora enriquecemos cada álbum con info de seguimiento
      final List<Map<String, dynamic>> enrichedAlbums = [];

      for (Map<String, dynamic> album in albums.cast<Map<String, dynamic>>()) {
        final albumId = album['id'];

        // Consultar si el usuario sigue ese álbum
        final followUrl = Uri.parse(
          '${Config.baseUrl}/api/albums/check-user-album/$userId/$albumId',
        );
        final followRes = await http.get(followUrl);

        bool isFollowing = false;
        int listenYear = 0;
        String? rankState;

        if (followRes.statusCode == 200) {
          final data = json.decode(followRes.body);
          isFollowing = data['exists'] ?? false;
          rankState = data['rank_state'];
          listenYear = isFollowing ? 2024 : 0;
        }

        enrichedAlbums.add({
          'type': 'album',
          'data': {
            ...album,
            'isUserFollowing': isFollowing,
            'listenYear': listenYear,
            'rankState': rankState,
          },
        });
      }

      return enrichedAlbums;
    } else {
      throw Exception("Error fetching albums: ${response.statusCode}");
    }
  }
}
