import 'package:flutter/material.dart';

class StatisticsButtonWidget extends StatelessWidget {
  final String label;
  final String numberLabel;
  final Color backgroundColor;
  final Color textColor;

  const StatisticsButtonWidget({
    super.key,
    required this.label,
    required this.numberLabel,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.textColor = const Color(0xFF272727),
  });

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 10)),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.015,
              horizontal: screenWidth * 0.085
            ),
            child: Text(
              numberLabel,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Esto se usa solo para testear la visualización
class StatisticsButtonWidgetPreview extends StatelessWidget {
  const StatisticsButtonWidgetPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return StatisticsButtonWidget(
        label: 'N° Artistas',
        numberLabel: '22'
    );
  }
}

// Esto se usa solo para testear la visualización
class StatisticsButtonWidgetPreview2 extends StatelessWidget {
  const StatisticsButtonWidgetPreview2({super.key});

  @override
  Widget build(BuildContext context) {
    return StatisticsButtonWidget(
      label: 'N° Albums',
      numberLabel: '98',
      backgroundColor: Color(0xFF6E6E6E),
      textColor: Colors.white,
    );
  }
}
