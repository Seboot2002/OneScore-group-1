import 'package:flutter/material.dart';

class EditableAvatarWidget extends StatelessWidget {
  final double size;
  final ImageProvider image;
  final VoidCallback onEdit;
  final bool canEdit;

  const EditableAvatarWidget({
    super.key,
    required this.size,
    required this.image,
    required this.onEdit,
    this.canEdit = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Borde circular
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade700, width: 10),
            image: DecorationImage(image: image, fit: BoxFit.cover),
          ),
        ),

        // Botón de edición en la esquina superior derecha
        if ( canEdit ) Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade700,
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Image.asset(
                  "assets/imgs/icon_edit.png",
                  width: 16,
                  height: 16,
                  fit: BoxFit.cover,
                ),
              )
            ),
          ),
        ),
      ],
    );
  }
}

// Esto se usa solo para testear la visualización
class EditableAvatarWidgetPreview extends StatelessWidget {
  const EditableAvatarWidgetPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: EditableAvatarWidget(
        size: 190,
        image: const AssetImage('assets/imgs/mod1_01.jpg'),
        onEdit: () {
          print('Cambiar imagen');
        },
        canEdit: true,
      )
    );
  }
}
