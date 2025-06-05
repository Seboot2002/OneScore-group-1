import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArtistCard extends StatelessWidget {
  final int artistId;
  final String name;
  final String image;

  const ArtistCard({
    super.key,
    required this.artistId,
    required this.name,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/artist-result', arguments: {'artistId': artistId});
      },
      child: SizedBox(
        height: 174,
        width: 130,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(110, 110, 110, 1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromRGBO(110, 110, 110, 1),
                    width: 8,
                  ),
                ),
                child: Image.asset('assets/imgs/icon_artist_micro_search.png'),
              ),
            ),

            // Fondo superior
            Positioned(
              top: 65,
              child: Container(
                width: 130,
                height: 57,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(210, 210, 210, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
              ),
            ),

            // Imagen del artista con opacidad
            Positioned(
              top: 15,
              child: SizedBox(
                height: 97,
                width: 130,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 97,
                    height: 97,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(110, 110, 110, 1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromRGBO(110, 110, 110, 1),
                        width: 10,
                      ),
                    ),
                    child: ClipOval(
                      child: Opacity(
                        opacity: 0.7,
                        child:
                            image.startsWith('http')
                                ? Image.network(image, fit: BoxFit.cover)
                                : Image.asset(image, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Nombre del artista
            Positioned(
              top: 122,
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
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
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
