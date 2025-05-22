import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchingBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const SearchingBarWidget({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Ingresar palabra clave',
              ),
              textAlign: TextAlign.start,
            ),
          ),
          InkWell(
            onTap: onSearch,
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(6.0),
            ),
            child: Container(
              height: double.infinity,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(6.0),
                ),
              ),
              child: const Icon(Icons.search, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// Esto se usa solo para testear la visualización
class SearchingBarWidgetPreview extends StatelessWidget {
  const SearchingBarWidgetPreview({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SearchingBarWidget(
        controller: searchController,
        onSearch: () {
          print("Buscando: ${searchController.text}");
        },
      ),
    );
  }
}
