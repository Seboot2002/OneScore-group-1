import 'package:flutter/cupertino.dart';
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
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 8.0),
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
      ),
    );
  }
}

// Esto se usa solo para testear la visualización
class StatisticsButtonWidgetPreview extends StatelessWidget {
  const StatisticsButtonWidgetPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: StatisticsButtonWidget(
        label: 'N° de artistas',
        numberLabel: '22',
      ),
    );
  }
}

// Esto se usa solo para testear la visualización
class StatisticsButtonWidgetPreview2 extends StatelessWidget {
  const StatisticsButtonWidgetPreview2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: StatisticsButtonWidget(
        label: 'N° de Albums',
        numberLabel: '98',
        backgroundColor: Color(0xFF777777),
        textColor: Colors.white,
      ),
    );
  }
}