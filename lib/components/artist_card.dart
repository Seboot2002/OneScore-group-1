import 'package:flutter/material.dart';

class ArtistCard extends StatelessWidget {
  final String name;
  final String image;

  const ArtistCard({super.key, required this.name, required this.image});

  Widget _buildContext(BuildContext context) {
    return SizedBox(
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
                color: Color.fromRGBO(110, 110, 110, 1),
                shape: BoxShape.circle,
                border: Border.all(color: Color.fromRGBO(210, 210, 210, 1)),
              ),
              child: Icon(Icons.mic, color: Color.fromRGBO(210, 210, 210, 1)),
            ),
          ),
          Positioned(
            top: 65,
            child: Container(
              width: (130),
              height: 57,
              decoration: BoxDecoration(
                color: Color.fromRGBO(210, 210, 210, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
          ),
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
                    color: Color.fromRGBO(110, 110, 110, 1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color.fromRGBO(110, 110, 110, 1),
                      width: 10,
                    ),
                  ),
                  child: ClipOval(child: Image.network(image)),
                ),
              ),
            ),
          ),

          Positioned(
            top: (65 + 57),
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
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
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
