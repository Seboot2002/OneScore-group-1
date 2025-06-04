import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/user_result/user_result_page.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String image;
  final int userId;

  const UserCard({
    super.key,
    required this.name,
    required this.image,
    required this.userId,
  });

  Widget _buildContext(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Debug para ver si el tap funciona
        print('UserCard tapped! UserId: $userId, Name: $name');

        // Navegamos usando rutas nombradas
        try {
          print('Intentando navegar a /user-result con userId: $userId');
          Get.toNamed('/user-result', arguments: userId);
          print('Navegación iniciada correctamente');
        } catch (e) {
          print('Error en navegación: $e');
          // Fallback: navegar directamente
          print('Intentando navegación directa...');
          Get.to(() => UserResultPage(), arguments: userId);
        }
      },
      child: Container(
        // Agregamos un contenedor con color transparente para mejorar el área de tap
        color: Colors.transparent,
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
                    color: Color.fromRGBO(110, 110, 110, 1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color.fromRGBO(110, 110, 110, 1),
                      width: 8,
                    ),
                  ),
                  child: Image.asset('assets/imgs/icon_user_search.png'),
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
                          width: 10,
                          color: Color.fromRGBO(110, 110, 110, 1),
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContext(context);
  }
}

// Esto se usa solo para testear la visualización
class UserCardPreview extends StatelessWidget {
  const UserCardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: UserCard(
        name: "Michael",
        image: "assets/imgs/mod1_01.jpg",
        userId: 1,
      ),
    );
  }
}
