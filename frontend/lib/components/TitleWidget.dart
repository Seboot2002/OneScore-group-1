import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String text;
  final double fontSize;

  const TitleWidget({super.key,
    required this.text,
    this.fontSize = 36
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        style: TextStyle(
          color: Color(0xFF535353),
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

// Esto se usa solo para testear la visualización
class TitleWidgetPreview extends StatelessWidget {
  const TitleWidgetPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TitleWidget(text: 'Titulo'),
    );
  }
}
