import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/entities/user.dart';
import '../models/httpresponse/service_http_response.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = "https://onescore.loca.lt";

  int _generateNewUserId(List<User> allUsers) {
    if (allUsers.isEmpty) return 1;
    try {
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
    final url = Uri.parse('$baseUrl/api/users');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': newUser.name,
          'last_name': newUser.lastName,
          'nickname': newUser.nickname,
          'mail': newUser.mail,
          'password': newUser.password,
          'photo_url': newUser.photoUrl,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return ServiceHttpResponse(
          status: 201,
          body: 'Usuario creado con ID ${data["userId"]}',
        );
      } else if (response.statusCode == 409) {
        return ServiceHttpResponse(
          status: 409,
          body: 'Ya existe un usuario con ese correo o nickname',
        );
      } else {
        return ServiceHttpResponse(
          status: response.statusCode,
          body: 'Error inesperado: ${response.body}',
        );
      }
    } catch (e) {
      return ServiceHttpResponse(status: 500, body: 'Error de red: $e');
    }
  }

  Future<ServiceHttpResponse> changePassword({
    required User usuario,
    required String currentPassword,
    required String newPassword,
    required String repeatNewPassword,
  }) async {
    final url = Uri.parse(
      '$baseUrl/api/users/updateUserPassword/${usuario.userId}',
    );

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user': {'password': currentPassword},
          'newPassword': newPassword,
          'repeatNewPassword': repeatNewPassword,
        }),
      );

      if (response.statusCode == 200) {
        return ServiceHttpResponse(
          status: 200,
          body: 'Contraseña actualizada exitosamente',
        );
      } else {
        final data = jsonDecode(response.body);
        return ServiceHttpResponse(
          status: response.statusCode,
          body: data['error'] ?? 'Error al cambiar la contraseña',
        );
      }
    } catch (e) {
      return ServiceHttpResponse(
        status: 500,
        body: 'Error al conectar con el servidor: $e',
      );
    }
  }

  Future<ServiceHttpResponse> logIn(String identifier, String password) async {
    final url = Uri.parse('$baseUrl/api/users/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'login': identifier, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = User.fromJson(data['user']);
        return ServiceHttpResponse(status: 200, body: user);
      } else if (response.statusCode == 401) {
        return ServiceHttpResponse(
          status: 401,
          body: 'Usuario o contraseña incorrectos',
        );
      } else {
        return ServiceHttpResponse(
          status: response.statusCode,
          body: 'Error inesperado: ${response.body}',
        );
      }
    } catch (e) {
      return ServiceHttpResponse(
        status: 500,
        body: 'Error al conectar con el servidor: $e',
      );
    }
  }

  // LOCAL

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

      final localUsers = await _loadLocalUsers();

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

  Future<User?> getUserById(int userId) async {
    try {
      final users = await _readUsers();

      print('🔍 Buscando usuario con ID: $userId');
      print('👥 Total usuarios disponibles: ${users.length}');

      final matchedUser = users.firstWhere(
        (user) => user.userId == userId,
        orElse: () => throw StateError('Usuario no encontrado'),
      );

      print('✅ Usuario encontrado: ${matchedUser.nickname}');
      return matchedUser;
    } catch (e) {
      print('❌ Error al buscar usuario con ID $userId: $e');
      return null;
    }
  }

  Future<ServiceHttpResponse> updateUser(
    User updatedUser,
    User originalUser,
  ) async {
    try {
      List<String> changes = [];
      if (updatedUser.name != originalUser.name) {
        changes.add('nombre de "${originalUser.name}" a "${updatedUser.name}"');
      }
      if (updatedUser.lastName != originalUser.lastName) {
        changes.add(
          'apellido de "${originalUser.lastName}" a "${updatedUser.lastName}"',
        );
      }
      if (updatedUser.mail != originalUser.mail) {
        changes.add('correo de "${originalUser.mail}" a "${updatedUser.mail}"');
      }

      if (changes.isNotEmpty) {
        print('========== ACTUALIZACIÓN DE PERFIL ==========');
        print(
          'El usuario "${updatedUser.name}" con ID "${updatedUser.userId}" cambió los siguientes campos:',
        );
        for (String change in changes) {
          print('- $change');
        }
        print('============================================');
      } else {
        print(
          'El usuario "${updatedUser.name}" con ID "${updatedUser.userId}" no realizó cambios',
        );
      }

      print('🔍 Buscando usuario con ID: ${updatedUser.userId}');

      final initialUsers = await _loadInitialUsers();
      final localUsers = await _loadLocalUsers();

      print('📁 Usuarios iniciales (assets): ${initialUsers.length}');
      print('📁 Usuarios locales (archivo): ${localUsers.length}');

      bool userExistsInAssets = initialUsers.any(
        (user) => user.userId.toString() == updatedUser.userId.toString(),
      );

      if (userExistsInAssets) {
        print('✅ Usuario encontrado en assets - moviendo a archivo local');

        localUsers.removeWhere(
          (user) => user.userId.toString() == updatedUser.userId.toString(),
        );

        localUsers.add(updatedUser);

        await _saveLocalUsers(localUsers);

        return ServiceHttpResponse(
          status: 200,
          body: 'Usuario actualizado correctamente (movido de assets a local)',
        );
      }

      int userIndex = localUsers.indexWhere(
        (user) => user.userId.toString() == updatedUser.userId.toString(),
      );

      if (userIndex != -1) {
        print('✅ Usuario encontrado en archivo local en posición $userIndex');

        localUsers[userIndex] = updatedUser;

        await _saveLocalUsers(localUsers);

        return ServiceHttpResponse(
          status: 200,
          body: 'Usuario actualizado correctamente',
        );
      }

      print('❌ Usuario con ID ${updatedUser.userId} no encontrado');

      return ServiceHttpResponse(
        status: 404,
        body: 'Usuario no encontrado. ID buscado: ${updatedUser.userId}',
      );
    } catch (e) {
      print('Error updating user: $e');
      return ServiceHttpResponse(
        status: 500,
        body: 'Error interno del servidor: $e',
      );
    }
  }
}
