import 'package:flutter/material.dart';

class ButtonImageWidget extends StatelessWidget {
  final String assetPath;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final BoxFit fit;

  const ButtonImageWidget({
    super.key,
    required this.assetPath,
    required this.onPressed,
    this.width = 100,
    this.height = 100,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}

// Esto se usa solo para testear la visualización
class ButtonImageWidgetPreview extends StatelessWidget {
  const ButtonImageWidgetPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ButtonImageWidget(
        assetPath: 'assets/imgs/BackButtonImage.png',
        onPressed: () {
          print('Botón de imagen presionado');
        },
        width: 80,
        height: 80,
        fit: BoxFit.contain,
      ),
    );
  }
}