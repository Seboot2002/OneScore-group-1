import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/TitleWidget.dart';
import '../../components/BottomNavigationBar.dart';
import '../../models/entities/album.dart';
import '../../models/entities/artist.dart';
import '../../models/entities/user.dart';
import '../../components/MusicItemsGrid.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = Get.arguments ?? {};
    final List<dynamic> results = arguments['results'] ?? [];
    final String searchType = arguments['searchType'] ?? '';
    final String searchQuery = arguments['searchQuery'] ?? '';

    _printResults(results, searchType, searchQuery);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: null,
      bottomNavigationBar: const CustomMenuBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(34),
          color: Colors.white,
          child: SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: 20,
                        height: 30,
                        child: Image.asset('assets/imgs/BackButtonImage.png'),
                      ),
                    ),
                  ),
                  TitleWidget(text: "Resultados"),
                  const SizedBox(height: 10),
                  Text('Búsqueda: "$searchQuery"',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey)),
                  Text('Categoría: $searchType',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      )),
                  Text('Resultados encontrados: ${results.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      )),
                  const SizedBox(height: 20),
                  MusicItemsGridStructure(
                    buttonsData: [
                      {
                        'value': true,
                        'label': searchType,
                        'data': results.map((r) => buildResultItem(r, searchType)).toList(),
                      }
                    ],
                    onButtonChanged: (value) {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildResultItem(dynamic result, String searchType) {
    if (searchType == 'Todos') {
      final String type = result['type'];
      final dynamic data = result['data'];
      switch (type) {
        case 'album':
          return buildAlbumCard(data as Album);
        case 'artist':
          return buildArtistCard(data as Artist);
        case 'user':
          return buildUserCard(data as User);
        default:
          return const SizedBox.shrink();
      }
    } else {
      switch (searchType) {
        case 'Albums':
          return buildAlbumCard(result as Album);
        case 'Artistas':
          return buildArtistCard(result as Artist);
        case 'Usuarios':
          return buildUserCard(result as User);
        default:
          return const SizedBox.shrink();
      }
    }
  }

  Widget buildAlbumCard(Album album) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        color: const Color(0xFF6E6E6E),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              album.coverUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.image),
            ),
          ),
          const SizedBox(height: 10),
          Text(album.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              "88.33",
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildArtistCard(Artist artist) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        color: const Color(0xFF6E6E6E),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(artist.pictureUrl),
          ),
          const SizedBox(height: 10),
          Text(artist.name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  Widget buildUserCard(User user) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        color: const Color(0xFF6E6E6E),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(user.nickname,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  void _printResults(
    List<dynamic> results,
    String searchType,
    String searchQuery,
  ) {
    print('\n${'=' * 50}');
    print('🔍 RESULTADOS DE BÚSQUEDA');
    print('${'=' * 50}');
    print('📝 Query: "$searchQuery"');
    print('🏷️ Tipo: $searchType');
    print('📊 Total resultados: ${results.length}');
    print('${'-' * 30}');

    if (results.isEmpty) {
      print('❌ No se encontraron resultados');
    } else {
      for (int i = 0; i < results.length; i++) {
        print('📋 Resultado ${i + 1}:');

        if (searchType == 'Todos') {
          final String type = results[i]['type'];
          final dynamic data = results[i]['data'];
          print('   Tipo: $type');

          switch (type) {
            case 'album':
              final Album album = data as Album;
              print('   🎵 Album: ${album.title} (${album.releaseYear})');
              break;
            case 'artist':
              final Artist artist = data as Artist;
              print('   🎤 Artista: ${artist.name} (Debut: ${artist.debutYear})');
              break;
            case 'user':
              final User user = data as User;
              print('   👤 Usuario: ${user.name} ${user.lastName} (@${user.nickname})');
              break;
          }
        } else {
          switch (searchType) {
            case 'Albums':
              final Album album = results[i] as Album;
              print('   🎵 ${album.title} - Año: ${album.releaseYear} - ID: ${album.albumId}');
              break;
            case 'Artistas':
              final Artist artist = results[i] as Artist;
              print('   🎤 ${artist.name} - Debut: ${artist.debutYear} - ID: ${artist.artistId}');
              break;
            case 'Usuarios':
              final User user = results[i] as User;
              print('   👤 ${user.name} ${user.lastName} (@${user.nickname}) - ${user.mail}');
              break;
          }
        }
        print('');
      }
    }
    print('${'=' * 50}\n');
  }
}
