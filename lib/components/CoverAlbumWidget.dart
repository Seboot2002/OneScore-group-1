import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CoverAlbumWidget extends StatelessWidget {
  final ImageProvider image;

  const CoverAlbumWidget({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double width = screenWidth * 0.46;
    double height = screenHeight * 0.22;

    return SafeArea(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          shape: BoxShape.rectangle,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Opacity(
            opacity: 0.7, // 70% de opacidad
            child: Image(image: image, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}

// Esto se usa solo para testear la visualización
class CoverAlbumWidgetPreview extends StatelessWidget {
  const CoverAlbumWidgetPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: CoverAlbumWidget(
        image: const AssetImage('assets/imgs/mod1_01.jpg'),
      ),
    );
  }
}
