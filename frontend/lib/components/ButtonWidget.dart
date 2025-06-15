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
    this.backgroundColor = const Color(0xFFBF4141),
    this.textColor = Colors.white,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side:
              hasBorder
                  ? BorderSide(color: Colors.grey.shade700, width: 1)
                  : BorderSide.none,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 15,
          horizontal: screenWidth * 0.08,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class ButtonWidgetPreview extends StatelessWidget {
  const ButtonWidgetPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ButtonWidget(
        text: 'Crear cuenta',
        onPressed: () {
          print("El boton fue presionado");
        },
      ),
    );
  }
}

class ButtonWidgetPreview2 extends StatelessWidget {
  const ButtonWidgetPreview2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ButtonWidget(
        text: 'Vuele a recordarme',
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
