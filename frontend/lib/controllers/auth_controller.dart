import 'package:get/get.dart';
import '../models/entities/user.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  User? _currentUser;

  User? get user => _currentUser;

  int? get userId => _currentUser?.userId;
  String? get name => _currentUser?.name;
  String? get lastName => _currentUser?.lastName;
  String? get nickname => _currentUser?.nickname;
  String? get email => _currentUser?.mail;
  String? get photoUrl => _currentUser?.photoUrl;

  bool get isLoggedIn => _currentUser != null;

  void login(User user) {
    _currentUser = user;
    update();
    print('Usuario logeado: ${user.toString()}');
  }

  void logout() {
    _currentUser = null;
    update();
    print('Usuario cerró sesión');
  }

  void updateUserProfileWithEmail({
    String? name,
    String? lastName,
    String? nickname,
    String? email,
    String? photoUrl,
  }) {
    if (_currentUser != null) {
      _currentUser = User(
        userId: _currentUser!.userId,
        name: name ?? _currentUser!.name,
        lastName: lastName ?? _currentUser!.lastName,
        nickname: nickname ?? _currentUser!.nickname,
        mail: email ?? _currentUser!.mail,
        password: _currentUser!.password,
        photoUrl: photoUrl ?? _currentUser!.photoUrl,
      );
      update();
    }
  }

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
        mail: _currentUser!.mail,
        password: _currentUser!.password,
        photoUrl: photoUrl ?? _currentUser!.photoUrl,
      );
      update();
    }
  }
}
