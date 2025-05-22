import 'package:flutter/material.dart';
import 'package:onescore/components/album_card.dart';

class MusicItemsGrid extends StatelessWidget {
  final List<Widget> musicWidgets;

  const MusicItemsGrid({super.key, required this.musicWidgets});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 0,
            mainAxisSpacing: 24,
            childAspectRatio: 0.75,
          ),
          itemCount: musicWidgets.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: musicWidgets[index],
            );
          },
        ),
      ),
    );
  }
}

class MusicItemsGridPreview extends StatelessWidget {
  const MusicItemsGridPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(
        height: 400,
        child: MusicItemsGrid(
          musicWidgets: [
            AlbumCard(
              name: "AAAA",
              image: "https://via.placeholder.com/150",
              rating: 12,
            ),
            AlbumCard(
              name: "BBBB",
              image: "https://via.placeholder.com/150",
              rating: 14,
            ),
            AlbumCard(
              name: "CCCC",
              image: "https://via.placeholder.com/150",
              rating: 17,
            ),
            AlbumCard(
              name: "DDDD",
              image: "https://via.placeholder.com/150",
              rating: 21,
            ),
            AlbumCard(
              name: "EEEE",
              image: "https://via.placeholder.com/150",
              rating: 9,
            ),
            AlbumCard(
              name: "FFFF",
              image: "https://via.placeholder.com/150",
              rating: 11,
            ),
          ],
        ),
      ),
    );
  }
}
