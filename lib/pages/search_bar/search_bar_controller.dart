import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  void onSearchPressed() {
    String tipoBusqueda =
        checkboxes.firstWhere((c) => c['value'] == true)['label'];
    String textoBusqueda = searchController.text.trim();

    print("🔍 Tipo de búsqueda seleccionada: $tipoBusqueda");
    print("📝 Texto ingresado: $textoBusqueda");

    // Simular resultados
    List<String> resultados = [
      "$tipoBusqueda Resultado 1",
      "$tipoBusqueda Resultado 2",
      "$tipoBusqueda Resultado 3",
    ];

    print("📦 Resultados encontrados:");
    for (var r in resultados) {
      print("• $r");
    }
  }
}
