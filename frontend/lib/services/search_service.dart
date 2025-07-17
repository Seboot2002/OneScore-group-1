import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/entities/album.dart';
import '../../models/entities/artist.dart';
import '../../models/entities/user.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';

class SearchService {
  static double _calculateMatch(String text, String query) {
    final textLower = text.toLowerCase();
    final queryLower = query.toLowerCase();

    if (textLower == queryLower) return 100.0;

    if (textLower.contains(queryLower)) return 80.0;

    final queryWords =
        queryLower.split(' ').where((w) => w.isNotEmpty).toList();

    if (queryWords.isEmpty) return 0.0;

    bool allWordsMatch = true;
    double totalScore = 0.0;

    for (String queryWord in queryWords) {
      bool wordFound = false;

      if (textLower.contains(queryWord)) {
        wordFound = true;

        final textWords = textLower.split(' ');
        for (String textWord in textWords) {
          if (textWord == queryWord) {
            totalScore += 60.0;
            break;
          } else if (textWord.startsWith(queryWord)) {
            totalScore += 40.0;
            break;
          } else if (textWord.contains(queryWord)) {
            totalScore += 30.0;
            break;
          }
        }
      }

      if (!wordFound) {
        allWordsMatch = false;
        break;
      }
    }

    if (allWordsMatch) {
      return totalScore / queryWords.length;
    }

    return 0.0;
  }

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

    final String data = await rootBundle.loadString('assets/jsons/user.json');
    final List<dynamic> jsonList = json.decode(data);

    List<Map<String, dynamic>> usersWithScore = [];

    for (var json in jsonList) {
      final user = User.fromJson(json);

      double nameScore = _calculateMatch(user.name, query);
      double lastNameScore = _calculateMatch(user.lastName, query);
      double nicknameScore = _calculateMatch(user.nickname, query);
      double emailScore = _calculateMatch(user.mail, query);

      String fullName = '${user.name} ${user.lastName}';
      double fullNameScore = _calculateMatch(fullName, query);

      double maxScore = [
        nameScore,
        lastNameScore,
        nicknameScore,
        emailScore,
        fullNameScore,
      ].reduce((a, b) => a > b ? a : b);

      if (maxScore > 0) {
        usersWithScore.add({'user': user, 'score': maxScore});
      }
    }

    usersWithScore.sort((a, b) => b['score'].compareTo(a['score']));

    return usersWithScore.map((item) => item['user'] as User).toList();
  }

  // Funciones finales
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
