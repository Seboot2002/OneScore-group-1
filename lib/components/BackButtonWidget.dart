import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  final String assetPath;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final BoxFit fit;

  const BackButtonWidget({
    super.key,
    this.assetPath = 'assets/imgs/BackButtonImage.png',
    required this.onPressed,
    this.width = 35,
    this.height = 35,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Image.asset(assetPath, width: width, height: height, fit: fit),
    );
  }
}

// Esto se usa solo para testear la visualización
class BackButtonWidgetPreview extends StatelessWidget {
  const BackButtonWidgetPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BackButtonWidget(
        onPressed: () {
          print('Botón de imagen presionado');
        },
        fit: BoxFit.contain,
      ),
    );
  }
}
