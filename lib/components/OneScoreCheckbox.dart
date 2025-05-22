import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OneScoreCheckBox extends StatelessWidget {

  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;

  const OneScoreCheckBox({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {

    final Color selectedColor =  Color(0xFF585858);
    final Color unselectedColor = Color(0xFFD2D2D2);
    final Color unselectedBorderColor = Color(0xFF6E6E6E);
    final Color selectedBorderColor = Color(0xFF585858);

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double boxSize = screenWidth * 0.04;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Container(
            width: boxSize,
            height: boxSize,
            decoration: BoxDecoration(
              color: value ? selectedColor : unselectedColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: value ? selectedBorderColor : unselectedBorderColor,
                width: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}

// Esto se usa solo para testear la visualización
class OneScoreCheckBoxPreview extends StatefulWidget {

  final List<Map<String, dynamic>> checkboxesData;
  final Function(List<Map<String, dynamic>>) onCheckboxChanged;

  const OneScoreCheckBoxPreview({
    super.key,
    required this.checkboxesData,
    required this.onCheckboxChanged
  });

  @override
  State<OneScoreCheckBoxPreview> createState() => _OneScoreCheckBoxPreviewState();
}

class _OneScoreCheckBoxPreviewState extends State<OneScoreCheckBoxPreview> {

  void _onChanged(int index) {
    setState(() {
      for (int i = 0; i < widget.checkboxesData.length; i++) {
        if (i == index) {
          widget.checkboxesData[i]['value'] = true;
        } else {
          widget.checkboxesData[i]['value'] = false;
        }
      }
    });

    widget.onCheckboxChanged(widget.checkboxesData);
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> checkBoxes = [];

    for (int i = 0; i < widget.checkboxesData.length; i++) {
      bool value = widget.checkboxesData[i]['value'];
      String label = widget.checkboxesData[i]['label'];

      checkBoxes.add(
        OneScoreCheckBox(
          value: value,
          label: label,
          onChanged: (val) {
            _onChanged(i);
          },
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing:  MediaQuery.of(context).size.width * 0.05,
          children: checkBoxes
        ),
      ),
    );
  }
}
