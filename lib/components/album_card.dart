import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/album_result/album_result_page.dart';

class AlbumCard extends StatelessWidget {
  final String name;
  final String image;
  final double rating;
  final int albumId;
  final VoidCallback? onTap;

  const AlbumCard({
    super.key,
    required this.name,
    required this.image,
    required this.rating,
    required this.albumId,
    this.onTap,
  });

  Widget _buildContext(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => AlbumResultPage(), arguments: albumId);
      },
      child: SizedBox(
        height: 200,
        width: 130,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(110, 110, 110, 1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 24,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  border: Border.all(
                    color: const Color.fromRGBO(210, 210, 210, 1),
                    width: 15,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Opacity(
                    opacity: 0.7,
                    child: Image.network(image, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 154,
              child: Container(
                width: 130,
                height: 46,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(110, 110, 110, 1),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      name,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: 19,
                      width: 49,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(210, 210, 210, 1),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '$rating',
                          maxLines: 1,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            color: Color.fromRGBO(110, 110, 110, 1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContext(context);
  }
}
