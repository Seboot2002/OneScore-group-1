import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade700, width: 10),
          ),
          child: ClipOval(
            child: Opacity(
              opacity: 0.7,
              child: Image(
                image: image,
                fit: BoxFit.cover,
                width: size,
                height: size,
              ),
            ),
          ),
        ),

        if (canEdit)
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Get.toNamed('/edit-profile');
                onEdit();
              },
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
                ),
              ),
            ),
          ),
      ],
    );
  }
}
