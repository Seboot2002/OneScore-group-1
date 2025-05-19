import 'package:flutter/material.dart';

class CustomMenuBar extends StatefulWidget {
  const CustomMenuBar({super.key});

  @override
  State<CustomMenuBar> createState() => _CustomMenuBarState();
}

class _CustomMenuBarState extends State<CustomMenuBar> {
  int selectedIndex = 0;

  final List<String> icons = List.generate(
    5,
    (index) =>
        'assets/imgs/icon_menubar_${(index + 1).toString().padLeft(2, '0')}.png',
  );

  final List<Size> iconSizes = [
    const Size(60, 60),
    const Size(30, 30),
    const Size(50, 50),
    const Size(35, 35),
    const Size(30, 30),
  ];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Container(
      height: 80,
      width: width,
      decoration: const BoxDecoration(
        color: Color(0xFF6E6E6E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          // Círculo animado detrás del ícono seleccionado
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left:
                (width / 5) * selectedIndex +
                (width / 5 - 50) / 2, // centrar círculo de 50px
            top: 15, // margen superior
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F1F1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Íconos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(icons.length, (index) {
              final bool isSelected = index == selectedIndex;
              final Size size = iconSizes[index];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Container(
                  width: width / 5,
                  height: 80,
                  alignment: Alignment.center,
                  child: Image.asset(
                    icons[index],
                    width: size.width,
                    height: size.height,
                    color:
                        isSelected
                            ? const Color(0xFF6E6E6E)
                            : const Color(0xFFF1F1F1),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
