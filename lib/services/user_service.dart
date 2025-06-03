import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/entities/user.dart';
import '../models/httpresponse/service_http_response.dart';

class UserService {
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/user.json');
  }

  Future<List<User>> _loadInitialUsers() async {
    try {
      final assetContent = await rootBundle.loadString(
        'assets/jsons/user.json',
      );
      final data = jsonDecode(assetContent) as List;
      final users = <User>[];

      for (var item in data) {
        try {
          if (item is Map<String, dynamic>) {
            users.add(User.fromJson(item));
          }
        } catch (e) {
          print('Error parsing initial user item: $item, error: $e');
        }
      }

      print('Loaded ${users.length} initial users from assets');
      return users;
    } catch (e) {
      print('Error loading initial users from assets: $e');
      return [];
    }
  }

  Future<List<User>> _loadLocalUsers() async {
    try {
      final file = await _getLocalFile();
      if (!await file.exists()) {
        print('Local file does not exist');
        return [];
      }

      final content = await file.readAsString();
      if (content.isEmpty) {
        print('Local file is empty');
        return [];
      }

      final data = jsonDecode(content) as List;
      final users = <User>[];
      for (var item in data) {
        try {
          if (item is Map<String, dynamic>) {
            users.add(User.fromJson(item));
          }
        } catch (e) {
          print('Error parsing local user item: $item, error: $e');
        }
      }

      print('Loaded ${users.length} users from local file');
      return users;
    } catch (e) {
      print('Error loading local users: $e');
      return [];
    }
  }

  Future<List<User>> _readUsers() async {
    try {
      final initialUsers = await _loadInitialUsers();

      // Cargar usuarios del archivo local (registrados por la app)
      final localUsers = await _loadLocalUsers();

      // Combinar ambas listas, evitando duplicados por userId
      final Map<int, User> allUsersMap = {};

      for (var user in initialUsers) {
        allUsersMap[user.userId] = user;
      }

      for (var user in localUsers) {
        allUsersMap[user.userId] = user;
      }

      final combinedUsers = allUsersMap.values.toList();

      print('=== USERS COMBINATION DEBUG ===');
      print('Initial users from assets: ${initialUsers.length}');
      print('Local users from file: ${localUsers.length}');
      print('Combined total users: ${combinedUsers.length}');
      print('===============================');

      return combinedUsers;
    } catch (e) {
      print('Error reading users: $e');
      return [];
    }
  }

  Future<void> _saveLocalUsers(List<User> localUsers) async {
    try {
      final file = await _getLocalFile();
      final json = jsonEncode(localUsers.map((u) => u.toJson()).toList());
      await file.writeAsString(json);
      print('Successfully saved ${localUsers.length} local users to file');
    } catch (e) {
      print('Error saving local users: $e');
      throw Exception('Error al guardar usuarios locales');
    }
  }

  int _generateNewUserId(List<User> allUsers) {
    if (allUsers.isEmpty) return 1;
    try {
      // Encontrar el userId más alto y sumar 1
      final maxId = allUsers
          .map((u) => u.userId)
          .reduce((a, b) => a > b ? a : b);
      return maxId + 1;
    } catch (e) {
      print('Error generating userId: $e');
      return allUsers.length + 1;
    }
  }

  Future<ServiceHttpResponse> registerUser(User newUser) async {
    try {
      final allUsers = await _readUsers();
      final localUsers = await _loadLocalUsers();

      print('Current total users count: ${allUsers.length}');
      print('Current local users count: ${localUsers.length}');

      final alreadyExists = allUsers.any(
        (u) =>
            u.mail.toLowerCase() == newUser.mail.toLowerCase() ||
            u.nickname.toLowerCase() == newUser.nickname.toLowerCase(),
      );

      if (alreadyExists) {
        print(
          'User already exists with email: ${newUser.mail} or nickname: ${newUser.nickname}',
        );
        return ServiceHttpResponse(
          status: 409,
          body: 'Ya existe un usuario con ese correo o nickname',
        );
      }

      final newUserId = _generateNewUserId(allUsers);
      print('Generated new userId: $newUserId');

      final userWithId = User(
        userId: newUserId,
        name: newUser.name,
        lastName: newUser.lastName,
        nickname: newUser.nickname,
        mail: newUser.mail,
        password: newUser.password,
        photoUrl: newUser.photoUrl,
      );

      localUsers.add(userWithId);
      await _saveLocalUsers(localUsers);

      print('Successfully registered new user: ${userWithId.nickname}');
      print('Total local users after registration: ${localUsers.length}');

      return ServiceHttpResponse(
        status: 200,
        body: 'Usuario registrado exitosamente',
      );
    } catch (e) {
      print('Error in registerUser: $e');
      return ServiceHttpResponse(
        status: 500,
        body: 'Error al registrar usuario: $e',
      );
    }
  }

  Future<ServiceHttpResponse> changePassword({
    required usuario,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final userNickname = usuario.nickName;
      final localUsers = await _loadLocalUsers();

      final userIndex = localUsers.indexWhere(
        (u) =>
            (u.mail.toLowerCase() == userNickname.toLowerCase() ||
                u.nickname.toLowerCase() == userNickname.toLowerCase()) &&
            u.password == currentPassword,
      );

      if (userIndex == -1) {
        return ServiceHttpResponse(
          status: 403,
          body: 'Credenciales incorrectas',
        );
      }

      final updatedUser = User(
        userId: usuario.userId,
        name: usuario.name,
        lastName: usuario.lastName,
        nickname: usuario.nickname,
        mail: usuario.mail,
        password: newPassword,
        photoUrl: usuario.photoUrl,
      );
      localUsers[userIndex] = updatedUser;
      await _saveLocalUsers(localUsers);

      return ServiceHttpResponse(
        status: 200,
        body: 'Contraseña actualizada exitosamente',
      );
    } catch (e) {
      return ServiceHttpResponse(
        status: 500,
        body: 'Error al cambiar la contraseña: $e',
      );
    }
  }

  Future<ServiceHttpResponse> logIn(String identifier, String password) async {
    try {
      final users = await _readUsers();

      // Debug - Mostrar todos los usuarios disponibles
      print('=== LOGIN DEBUG ===');
      print('Total users loaded: ${users.length}');
      print('Looking for identifier: "$identifier" with password: "$password"');
      print('Available users:');
      for (var user in users) {
        print(
          '  - ID: ${user.userId}, Nickname: "${user.nickname}", Email: "${user.mail}", Password: "${user.password}"',
        );
      }
      print('==================');

      // Buscar usuario que coincida
      User? matchedUser;
      for (var user in users) {
        final emailMatch = user.mail.toLowerCase() == identifier.toLowerCase();
        final nicknameMatch =
            user.nickname.toLowerCase() == identifier.toLowerCase();
        final passwordMatch = user.password == password;

        print('Checking user ${user.nickname}:');
        print('  Email match ("$identifier" vs "${user.mail}"): $emailMatch');
        print(
          '  Nickname match ("$identifier" vs "${user.nickname}"): $nicknameMatch',
        );
        print('  Password match: $passwordMatch');

        if ((emailMatch || nicknameMatch) && passwordMatch) {
          matchedUser = user;
          print('  ✓ MATCH FOUND!');
          break;
        }
      }

      if (matchedUser != null) {
        print('Login successful for user: ${matchedUser.nickname}');
        return ServiceHttpResponse(status: 200, body: matchedUser);
      } else {
        print('Login failed - no matching user found');
        return ServiceHttpResponse(
          status: 401,
          body: 'Usuario o contraseña incorrectos',
        );
      }
    } catch (e) {
      print('Login error: $e');
      return ServiceHttpResponse(
        status: 500,
        body: 'Error al procesar los datos: $e',
      );
    }
  }

  Future<void> resetLocalUsers() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        await file.delete();
        print('Local users file deleted');
      }
    } catch (e) {
      print('Error resetting local users: $e');
    }
  }

  Future<void> debugPrintUsers() async {
    final users = await _readUsers();
    print('=== ALL USERS DEBUG ===');
    for (var user in users) {
      print('User: ${user.toString()}');
    }
    print('=======================');
  }
}
