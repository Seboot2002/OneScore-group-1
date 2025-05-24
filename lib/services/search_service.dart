import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/entities/album.dart';
import '../../models/entities/artist.dart';
import '../../models/entities/user.dart';

class SearchService {
  static Future<List<Album>> searchAlbums(String query) async {
    final String data = await rootBundle.loadString('assets/jsons/album.json');
    final List<dynamic> jsonList = json.decode(data);

    return jsonList
        .map((e) => Album.fromJson(e))
        .where(
          (album) =>
              album.title.toLowerCase().contains(query) ||
              album.releaseYear.toString().contains(query),
        )
        .toList();
  }

  static Future<List<Artist>> searchArtists(String query) async {
    final String data = await rootBundle.loadString('assets/jsons/artist.json');
    final List<dynamic> jsonList = json.decode(data);

    return jsonList
        .map((e) => Artist.fromJson(e))
        .where(
          (artist) =>
              artist.name.toLowerCase().contains(query) ||
              artist.debutYear.toString().contains(query),
        )
        .toList();
  }

  static Future<List<User>> searchUsers(String query) async {
    final String data = await rootBundle.loadString('assets/jsons/user.json');
    final List<dynamic> jsonList = json.decode(data);

    return jsonList
        .map((e) => User.fromJson(e))
        .where(
          (user) =>
              user.name.toLowerCase().contains(query) ||
              user.lastName.toLowerCase().contains(query) ||
              user.nickname.toLowerCase().contains(query) ||
              user.mail.toLowerCase().contains(query),
        )
        .toList();
  }
}
