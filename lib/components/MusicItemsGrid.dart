import 'package:flutter/material.dart';

class MusicItemsGrid extends StatefulWidget {
  final List<Widget> musicWidgets;
  final bool isStatic;

  const MusicItemsGrid({super.key,
    required this.musicWidgets,
    required this.isStatic
  });

  @override
  State<MusicItemsGrid> createState() => _MusicItemsGridState();
}

class _MusicItemsGridState extends State<MusicItemsGrid> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xFF6E6E6E), width: 2.5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: GridView.builder(
            physics: widget.isStatic ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 0,
              mainAxisSpacing: 8,
              childAspectRatio: 0.65,
            ),
            itemCount: widget.musicWidgets.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: widget.musicWidgets[index],
              );
            },
          ),
        ),
      ),
    );
  }
}

class GridButtonWidget extends StatelessWidget {
  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;

  const GridButtonWidget({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = Color(0xFF6E6E6E);
    final Color unselectedColor = Color(0xFFD2D2D2);

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double buttomWidth = screenWidth * 0.25;
    final double buttomHeight = screenHeight * 0.055;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: buttomWidth,
        height: buttomHeight,
        decoration: BoxDecoration(
          color: value ? selectedColor : unselectedColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: value ? Color(0xFFF1F1F1) : Color(0xFF535353),
            ),
          ),
        ),
      ),
    );
  }
}

class MusicItemsGridStructure extends StatefulWidget {
  final List<Map<String, dynamic>> buttonsData;
  final Function(List<Map<String, dynamic>>) onButtonChanged;
  final bool isStatic;

  const MusicItemsGridStructure({
    super.key,
    required this.buttonsData,
    required this.onButtonChanged,
    this.isStatic = false,
  });

  @override
  State<MusicItemsGridStructure> createState() =>
      _MusicItemsGridStructureState();
}

class _MusicItemsGridStructureState extends State<MusicItemsGridStructure> {
  late List<Widget> musicWidgets;

  @override
  void initState() {
    musicWidgets = widget.buttonsData[0]['data'];
    super.initState();
  }

  void _onChanged(int index) {
    setState(() {
      for (int i = 0; i < widget.buttonsData.length; i++) {
        if (i == index) {
          widget.buttonsData[i]['value'] = true;
        } else {
          widget.buttonsData[i]['value'] = false;
        }
      }

      if (widget.buttonsData[index]['value']) {
        musicWidgets = widget.buttonsData[index]['data'];
      }
    });

    widget.onButtonChanged(widget.buttonsData);
  }

  @override
  Widget build(BuildContext context) {
    List<GridButtonWidget> buttons = [];

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    for (int i = 0; i < widget.buttonsData.length; i++) {
      bool value = widget.buttonsData[i]['value'];
      String label = widget.buttonsData[i]['label'];

      buttons.add(
        GridButtonWidget(
          value: value,
          label: label,
          onChanged: (val) {
            _onChanged(i);
          },
        ),
      );
    }

    return SizedBox(
      height: 400,
      child: Column(
        children: [
          // Contenedor con scroll horizontal para los botones
          SizedBox(
            width: double.infinity,
            height: screenHeight * 0.055,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Espaciado inicial para mantener alineación a la izquierda
                  SizedBox(width: 0),
                  // Botones con espaciado entre ellos
                  ...buttons.map(
                    (button) => Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: button,
                    ),
                  ),
                ],
              ),
            ),
          ),
          MusicItemsGrid(
              musicWidgets: musicWidgets,
              isStatic: widget.isStatic
          ),
        ],
      ),
    );
  }
}
