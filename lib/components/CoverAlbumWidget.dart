import 'package:flutter/material.dart';

class CoverAlbumWidget extends StatelessWidget {
  final ImageProvider image;

  const CoverAlbumWidget({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    const double size = 173.0;

    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        shape: BoxShape.rectangle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Opacity(
          opacity: 0.7,
          child: Image(image: image, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

// Solo para preview
class CoverAlbumWidgetPreview extends StatelessWidget {
  const CoverAlbumWidgetPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: CoverAlbumWidget(image: AssetImage('assets/imgs/mod1_01.jpg')),
    );
  }
}
