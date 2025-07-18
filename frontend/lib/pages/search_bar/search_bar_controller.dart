import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/search_service.dart';

class SearchBarController extends GetxController {
  final searchController = TextEditingController();
  final List<Map<String, dynamic>> checkboxes = [
    {'label': 'Todos', 'value': true},
    {'label': 'Albums', 'value': false},
    {'label': 'Artistas', 'value': false},
    {'label': 'Usuarios', 'value': false},
  ];

  void selectCheckbox(int index) {
    for (int i = 0; i < checkboxes.length; i++) {
      checkboxes[i]['value'] = i == index;
    }
    update();
    print("🔘 Se clickeó la opción ${checkboxes[index]['label']}");
  }

  Future<void> onSearchPressed() async {
    String tipoBusqueda =
        checkboxes.firstWhere((c) => c['value'] == true)['label'];
    String textoBusqueda = searchController.text.trim();

    if (textoBusqueda.isEmpty) {
      Get.snackbar(
        'Búsqueda vacía',
        'Por favor ingresa un término de búsqueda',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    print("🔍 Tipo de búsqueda seleccionada: $tipoBusqueda");
    print("📝 Texto ingresado: $textoBusqueda");

    try {
      List<dynamic> resultados = [];

      switch (tipoBusqueda) {
        case 'Albums':
          resultados = await SearchService.fetchAlbumsFromApi(textoBusqueda);
          break;
        case 'Artistas':
          resultados = await SearchService.searchArtists(textoBusqueda);
          break;
        case 'Usuarios':
          resultados = await SearchService.searchUsers(textoBusqueda);
          break;
        case 'Todos':
          final albums = await SearchService.fetchAlbumsFromApi(textoBusqueda);
          final artists = await SearchService.searchArtists(textoBusqueda);
          final users = await SearchService.searchUsers(textoBusqueda);
          resultados = [
            ...albums,
            ...artists.map((artist) => {'type': 'artist', 'data': artist}),
            ...users.map((user) => {'type': 'user', 'data': user}),
          ];
          break;
      }

      print("📦 Resultados encontrados: ${resultados.length}");

      // ✅ Agregar timestamp para forzar nueva navegación
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      await Get.toNamed(
        '/results',
        arguments: {
          'results': resultados,
          'searchType': tipoBusqueda,
          'searchQuery': textoBusqueda,
          'timestamp': timestamp, // ✅ Hace que cada búsqueda sea única
        },
      );

      // ✅ Limpiar el texto del buscador
      searchController.clear();
    } catch (e) {
      print("❌ Error en la búsqueda: $e");
      Get.snackbar(
        'Error',
        'Ha ocurrido un error durante la búsqueda',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
