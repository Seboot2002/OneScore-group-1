import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../pages/album_result/album_result_controller.dart';

class TrackListItemWidget extends StatefulWidget {
  final String trackName;
  final int songId;
  final TextEditingController ratingController;

  const TrackListItemWidget({
    super.key,
    required this.trackName,
    required this.songId,
    required this.ratingController,
  });

  @override
  State<TrackListItemWidget> createState() => _TrackListItemWidgetState();
}

class _TrackListItemWidgetState extends State<TrackListItemWidget> {
  late AlbumResultController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AlbumResultController>();

    final existingRating = controller.getSongRating(widget.songId);
    widget.ratingController.text = existingRating.toString();

    widget.ratingController.addListener(_onRatingChanged);

    print(
      '🎵 TrackListItem inicializado para ${widget.trackName} (ID: ${widget.songId})',
    );
  }

  @override
  void dispose() {
    widget.ratingController.removeListener(_onRatingChanged);
    super.dispose();
  }

  void _onRatingChanged() {
    final text = widget.ratingController.text;
    print(
      '📝 Rating cambiado para ${widget.trackName} (ID: ${widget.songId}): "$text"',
    );

    if (text.isEmpty) {
      controller.updateSongRating(widget.songId, 0);
      return;
    }

    final rating = int.tryParse(text);
    if (rating != null) {
      if (rating >= 0 && rating <= 100) {
        controller.updateSongRating(widget.songId, rating);
        print('✅ Rating válido guardado: $rating');
      } else {
        print('❌ Rating fuera de rango (0-100): $rating');
      }
    } else {
      print('❌ Rating no es un número válido: "$text"');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = screenWidth * 0.65;

    return Center(
      child: SizedBox(
        width: contentWidth,
        height: 40,
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 44,
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
                  widget.trackName,
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
              height: 44,
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
                    controller: widget.ratingController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 3,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _RatingInputFormatter(),
                    ],
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
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        final rating = int.tryParse(value);
                        if (rating != null && rating > 100) {
                          widget.ratingController.text = '100';
                          widget
                              .ratingController
                              .selection = TextSelection.fromPosition(
                            TextPosition(
                              offset: widget.ratingController.text.length,
                            ),
                          );
                        }
                      }
                    },
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

class _RatingInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final int? value = int.tryParse(newValue.text);
    if (value == null) {
      return oldValue;
    }

    if (value > 100) {
      return TextEditingValue(
        text: '100',
        selection: TextSelection.collapsed(offset: 3),
      );
    }

    return newValue;
  }
}
