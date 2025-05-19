import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final bool hasBorder;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.red,
    this.textColor = Colors.white,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // full width
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side:
                hasBorder
                    ? BorderSide(color: Colors.grey.shade700, width: 1)
                    : BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// Esto se usa solo para testear la visualización
class ButtonWidgetPreview extends StatelessWidget {
  const ButtonWidgetPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ButtonWidget(
        text: 'Boton',
        onPressed: () {
          print("El boton fue presionado");
        },
      ),
    );
  }
}

// Esto se usa solo para testear la visualización
class ButtonWidgetPreview2 extends StatelessWidget {
  const ButtonWidgetPreview2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ButtonWidget(
        text: 'Boton',
        onPressed: () {
          print("El boton fue presionado");
        },
        backgroundColor: Colors.white,
        textColor: Colors.black,
        hasBorder: true,
      ),
    );
  }
}
