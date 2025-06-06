import 'package:flutter/material.dart';

class TrackListItemWidget extends StatelessWidget {
  final String trackName;
  final TextEditingController ratingController;

  const TrackListItemWidget({
    super.key,
    required this.trackName,
    required this.ratingController,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth =
        screenWidth * 0.65; // Aproximadamente 185px en pantallas comunes

    return Center(
      child: SizedBox(
        width: contentWidth,
        height: 40, // Aumentado desde 36 a 44
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 44, // Aumentado
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFE9E9E9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  trackName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6E6E6E),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(
              width: 69,
              height: 44, // Aumentado
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF6E6E6E),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: TextField(
                    controller: ratingController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 3,
                    style: const TextStyle(
                      color: Color(0xFFF1F1F1),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      hintText: '—',
                      hintStyle: TextStyle(color: Color(0xFFF1F1F1)),
                      isCollapsed: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
