import 'package:get/get.dart';
import '../models/entities/user.dart';

class AuthController extends GetxController {
  // Instancia singleton (acceso global)
  static AuthController get to => Get.find();

  User? _currentUser;

  // Getter para acceder a TODOS los atributos del usuario
  User? get user => _currentUser;

  // Getters individuales (opcionales, pero útiles para acceso rápido)
  int? get userId => _currentUser?.userId;
  String? get name => _currentUser?.name;
  String? get lastName => _currentUser?.lastName;
  String? get nickname => _currentUser?.nickname;
  String? get email => _currentUser?.mail;
  String? get photoUrl => _currentUser?.photoUrl;

  bool get isLoggedIn => _currentUser != null;

  // Login: Guarda el usuario completo
  void login(User user) {
    _currentUser = user;
    update(); // Notifica a los listeners
    print('Usuario logeado: ${user.toString()}'); // Debug
  }

  // Logout: Limpia todos los datos
  void logout() {
    _currentUser = null;
    update();
    print('Usuario cerró sesión'); // Debug
  }

  // Actualiza datos específicos (útil para editar perfil)
  void updateUserProfile({
    String? name,
    String? lastName,
    String? nickname,
    String? photoUrl,
  }) {
    if (_currentUser != null) {
      _currentUser = User(
        userId: _currentUser!.userId,
        name: name ?? _currentUser!.name,
        lastName: lastName ?? _currentUser!.lastName,
        nickname: nickname ?? _currentUser!.nickname,
        mail: _currentUser!.mail, // Email no se cambia
        password: _currentUser!.password, // Password se cambia con otro método
        photoUrl: photoUrl ?? _currentUser!.photoUrl,
      );
      update();
    }
  }
}
