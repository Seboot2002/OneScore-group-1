import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/TitleWidget.dart';
import '../../components/BottomNavigationBar.dart';
import '../../models/entities/album.dart';
import '../../models/entities/artist.dart';
import '../../models/entities/user.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener los argumentos pasados desde la página anterior
    final Map<String, dynamic> arguments = Get.arguments ?? {};
    final List<dynamic> results = arguments['results'] ?? [];
    final String searchType = arguments['searchType'] ?? '';
    final String searchQuery = arguments['searchQuery'] ?? '';

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Imprimir resultados en consola
    _printResults(results, searchType, searchQuery);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Center(
            child: Container(
              margin: EdgeInsets.only(top: screenHeight * 0.05),
              width: screenWidth * 0.9,
              height: screenHeight * 0.90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Botón de regreso
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, bottom: 10),
                        width: 20,
                        height: 30,
                        child: Image.asset('assets/imgs/BackButtonImage.png'),
                      ),
                    ),
                  ),

                  // Título con información de búsqueda
                  TitleWidget(text: "Resultados"),
                  const SizedBox(height: 10),

                  // Información de la búsqueda
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Búsqueda: "$searchQuery"',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Categoría: $searchType',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Resultados encontrados: ${results.length}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Lista de resultados
                  Expanded(
                    child:
                        results.isEmpty
                            ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No se encontraron resultados',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : ListView.builder(
                              itemCount: results.length,
                              itemBuilder: (context, index) {
                                return _buildResultItem(
                                  results[index],
                                  searchType,
                                );
                              },
                            ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomMenuBar(),
    );
  }

  Widget _buildResultItem(dynamic result, String searchType) {
    if (searchType == 'Todos') {
      // Para búsqueda de "Todos", el resultado viene con type y data
      final String type = result['type'];
      final dynamic data = result['data'];

      switch (type) {
        case 'album':
          return _buildAlbumCard(data as Album);
        case 'artist':
          return _buildArtistCard(data as Artist);
        case 'user':
          return _buildUserCard(data as User);
        default:
          return const SizedBox.shrink();
      }
    } else {
      // Para búsquedas específicas
      switch (searchType) {
        case 'Albums':
          return _buildAlbumCard(result as Album);
        case 'Artistas':
          return _buildArtistCard(result as Artist);
        case 'Usuarios':
          return _buildUserCard(result as User);
        default:
          return const SizedBox.shrink();
      }
    }
  }

  Widget _buildAlbumCard(Album album) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: const Icon(Icons.album, color: Colors.blue),
        title: Text(album.title),
        subtitle: Text('Año: ${album.releaseYear}'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          print('🎵 Album seleccionado: ${album.title}');
        },
      ),
    );
  }

  Widget _buildArtistCard(Artist artist) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: const Icon(Icons.person, color: Colors.green),
        title: Text(artist.name),
        subtitle: Text('Debut: ${artist.debutYear}'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          print('🎤 Artista seleccionado: ${artist.name}');
        },
      ),
    );
  }

  Widget _buildUserCard(User user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: const Icon(Icons.account_circle, color: Colors.orange),
        title: Text('${user.name} ${user.lastName}'),
        subtitle: Text('@${user.nickname} • ${user.mail}'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          print('👤 Usuario seleccionado: ${user.nickname}');
        },
      ),
    );
  }

  void _printResults(
    List<dynamic> results,
    String searchType,
    String searchQuery,
  ) {
    print('\n' + '=' * 50);
    print('🔍 RESULTADOS DE BÚSQUEDA');
    print('=' * 50);
    print('📝 Query: "$searchQuery"');
    print('🏷️ Tipo: $searchType');
    print('📊 Total resultados: ${results.length}');
    print('-' * 30);

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
              print(
                '   🎤 Artista: ${artist.name} (Debut: ${artist.debutYear})',
              );
              break;
            case 'user':
              final User user = data as User;
              print(
                '   👤 Usuario: ${user.name} ${user.lastName} (@${user.nickname})',
              );
              break;
          }
        } else {
          switch (searchType) {
            case 'Albums':
              final Album album = results[i] as Album;
              print(
                '   🎵 ${album.title} - Año: ${album.releaseYear} - ID: ${album.albumId}',
              );
              break;
            case 'Artistas':
              final Artist artist = results[i] as Artist;
              print(
                '   🎤 ${artist.name} - Debut: ${artist.debutYear} - ID: ${artist.artistId}',
              );
              break;
            case 'Usuarios':
              final User user = results[i] as User;
              print(
                '   👤 ${user.name} ${user.lastName} (@${user.nickname}) - ${user.mail}',
              );
              break;
          }
        }
        print('');
      }
    }
    print('=' * 50 + '\n');
  }
}
