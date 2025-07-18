import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/entities/album.dart';
import '../../models/entities/artist.dart';
import '../../models/entities/user.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';

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

  static Future<List<Album>> fetchAlbumsFromApi(String keyword) async {
    final Uri url = Uri.parse('${Config.baseUrl}/api/albums/search/$keyword');
    print("🌐 Consultando endpoint: $url");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print("🧪 Resultado desde API: $data");
        return data.map((item) => Album.fromSearchJson(item)).toList();
      } else {
        print(
          "⚠️ Error desde API: ${response.statusCode} ${response.reasonPhrase}",
        );
        return [];
      }
    } catch (e) {
      print("❌ Excepción en búsqueda remota: $e");
      return [];
    }
  }
}
