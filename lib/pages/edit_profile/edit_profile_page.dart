import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'edit_profile_controller.dart';
import 'package:onescore/controllers/auth_controller.dart';
import '../../components/BackButtonWidget.dart';
import '../../components/TitleWidget.dart';
import '../../components/FieldTextWidget.dart';
import '../../components/ButtonWidget.dart';
import '../../components/BottomNavigationBar.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});

  final EditProfileController control = Get.put(EditProfileController());
  final AuthController authControl = Get.find<AuthController>();

  Widget _buildProfilePicture() {
    return Container(
      width: 190,
      height: 190,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade700, width: 10),
      ),
      child: ClipOval(
        child: Opacity(
          opacity: 0.7,
          child: Image.network(
            authControl.user?.photoUrl ??
                'https://www.shutterstock.com/image-vector/sakura-cherry-tree-blossom-enso-600nw-2442234723.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade200,
                child: Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.grey.shade400,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: null,
      bottomNavigationBar: const CustomMenuBar(),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Center(
            child: Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.90,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (notification) {
                  notification.disallowIndicator();
                  return true;
                },
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BackButtonWidget(),
                      const TitleWidget(text: "Edición"),
                      const SizedBox(height: 40),

                      Center(child: _buildProfilePicture()),
                      const SizedBox(height: 40),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 8,
                        ),
                        child: FieldTextWidget(
                          label: 'Nombre',
                          hintText: 'Escriba aquí',
                          controller: control.nameController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 8,
                        ),
                        child: FieldTextWidget(
                          label: 'Apellido',
                          hintText: 'Escriba aquí',
                          controller: control.lastNameController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 8,
                        ),
                        child: FieldTextWidget(
                          label: 'Correo',
                          hintText: 'ejemplo@correo.com',
                          controller: control.emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(height: 30),

                      Center(
                        child: Obx(
                          () =>
                              control.isLoading.value
                                  ? const CircularProgressIndicator()
                                  : ButtonWidget(
                                    text: 'Guardar cambios',
                                    onPressed: control.updateProfile,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Get.offNamed(
                              '/change-password',
                              arguments: authControl.user,
                            );
                          },
                          child: const Text(
                            'Cambiar contraseña',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF535353),
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w200,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
