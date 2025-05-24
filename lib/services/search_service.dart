import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/entities/album.dart';
import '../../models/entities/artist.dart';
import '../../models/entities/user.dart';

class SearchService {
  /// Función auxiliar para verificar si un texto coincide con la búsqueda
  /// Devuelve un score de coincidencia o 0 si no hay match
  static double _calculateMatch(String text, String query) {
    final textLower = text.toLowerCase();
    final queryLower = query.toLowerCase();

    // Coincidencia exacta
    if (textLower == queryLower) return 100.0;

    // Contiene la query completa (esto es lo más importante)
    if (textLower.contains(queryLower)) return 80.0;

    // Verificar si todas las palabras de la query están en el texto
    final queryWords =
        queryLower.split(' ').where((w) => w.isNotEmpty).toList();

    if (queryWords.isEmpty) return 0.0;

    // Verificar que TODAS las palabras de la query estén presentes
    bool allWordsMatch = true;
    double totalScore = 0.0;

    for (String queryWord in queryWords) {
      bool wordFound = false;

      // Buscar si esta palabra específica está en el texto
      if (textLower.contains(queryWord)) {
        wordFound = true;

        // Dar puntuación basada en cómo coincide
        final textWords = textLower.split(' ');
        for (String textWord in textWords) {
          if (textWord == queryWord) {
            totalScore += 60.0; // Palabra exacta
            break;
          } else if (textWord.startsWith(queryWord)) {
            totalScore += 40.0; // Empieza con la palabra
            break;
          } else if (textWord.contains(queryWord)) {
            totalScore += 30.0; // Contiene la palabra
            break;
          }
        }
      }

      if (!wordFound) {
        allWordsMatch = false;
        break;
      }
    }

    // Solo devolver puntuación si TODAS las palabras coinciden
    if (allWordsMatch) {
      return totalScore / queryWords.length;
    }

    return 0.0; // No hay match válido
  }

  static Future<List<Album>> searchAlbums(String query) async {
    if (query.trim().isEmpty) return [];

    final String data = await rootBundle.loadString('assets/jsons/album.json');
    final List<dynamic> jsonList = json.decode(data);

    List<Map<String, dynamic>> albumsWithScore = [];

    for (var json in jsonList) {
      final album = Album.fromJson(json);

      // Calcular score para título y año
      double titleScore = _calculateMatch(album.title, query);
      double yearScore =
          album.releaseYear.toString() == query
              ? 100.0
              : album.releaseYear.toString().contains(query)
              ? 60.0
              : 0.0;

      double maxScore = titleScore > yearScore ? titleScore : yearScore;

      // Solo incluir si hay un match real (score > 0)
      if (maxScore > 0) {
        albumsWithScore.add({'album': album, 'score': maxScore});
      }
    }

    // Ordenar por score descendente
    albumsWithScore.sort((a, b) => b['score'].compareTo(a['score']));

    return albumsWithScore.map((item) => item['album'] as Album).toList();
  }

  static Future<List<Artist>> searchArtists(String query) async {
    if (query.trim().isEmpty) return [];

    final String data = await rootBundle.loadString('assets/jsons/artist.json');
    final List<dynamic> jsonList = json.decode(data);

    List<Map<String, dynamic>> artistsWithScore = [];

    for (var json in jsonList) {
      final artist = Artist.fromJson(json);

      // Calcular score para nombre y año de debut
      double nameScore = _calculateMatch(artist.name, query);
      double yearScore =
          artist.debutYear.toString() == query
              ? 100.0
              : artist.debutYear.toString().contains(query)
              ? 60.0
              : 0.0;

      double maxScore = nameScore > yearScore ? nameScore : yearScore;

      // Solo incluir si hay un match real (score > 0)
      if (maxScore > 0) {
        artistsWithScore.add({'artist': artist, 'score': maxScore});
      }
    }

    // Ordenar por score descendente
    artistsWithScore.sort((a, b) => b['score'].compareTo(a['score']));

    return artistsWithScore.map((item) => item['artist'] as Artist).toList();
  }

  static Future<List<User>> searchUsers(String query) async {
    if (query.trim().isEmpty) return [];

    final String data = await rootBundle.loadString('assets/jsons/user.json');
    final List<dynamic> jsonList = json.decode(data);

    List<Map<String, dynamic>> usersWithScore = [];

    for (var json in jsonList) {
      final user = User.fromJson(json);

      // Calcular score para todos los campos del usuario
      double nameScore = _calculateMatch(user.name, query);
      double lastNameScore = _calculateMatch(user.lastName, query);
      double nicknameScore = _calculateMatch(user.nickname, query);
      double emailScore = _calculateMatch(user.mail, query);

      // Crear nombre completo para búsqueda
      String fullName = '${user.name} ${user.lastName}';
      double fullNameScore = _calculateMatch(fullName, query);

      double maxScore = [
        nameScore,
        lastNameScore,
        nicknameScore,
        emailScore,
        fullNameScore,
      ].reduce((a, b) => a > b ? a : b);

      // Solo incluir si hay un match real (score > 0)
      if (maxScore > 0) {
        usersWithScore.add({'user': user, 'score': maxScore});
      }
    }

    // Ordenar por score descendente
    usersWithScore.sort((a, b) => b['score'].compareTo(a['score']));

    return usersWithScore.map((item) => item['user'] as User).toList();
  }
}
