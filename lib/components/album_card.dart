import 'package:flutter/material.dart';

class AlbumCard extends StatelessWidget {
  final String name;
  final String image;
  final double rating;

  const AlbumCard({
    super.key,
    required this.name,
    required this.image,
    required this.rating,
  });

  Widget _buildContext(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 130,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Color.fromRGBO(110, 110, 110, 1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 24,
            child: Container(
              width: (130),
              height: 130,
              decoration: BoxDecoration(
                color: Colors.blueGrey[100],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                border: Border.all(
                  color: (Color.fromRGBO(210, 210, 210, 1)),
                  width: 15,
                ),
              ),
              child: ClipRect(child: Image.network(image)),
            ),
          ),
          Positioned(
            top: (24 + 130),
            child: Container(
              width: (130),
              height: 46,
              decoration: BoxDecoration(
                color: Color.fromRGBO(110, 110, 110, 1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 5),
                  Text(
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    name,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 19,
                    width: 49,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(210, 210, 210, 1),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          color: Color.fromRGBO(110, 110, 110, 1),
                          fontWeight: FontWeight.w600,
                        ),
                        '$rating',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContext(context);
  }
}

// Esto se usa solo para testear la visualización
class AlbumCardPreview extends StatelessWidget {
  const AlbumCardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: AlbumCard(
          name: 'aaaa',
          image: 'assets/imgs/mod1_01.jpg',
          rating: 12,
        )
    );
  }
}