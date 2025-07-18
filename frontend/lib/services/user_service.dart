import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/entities/user.dart';
import '../models/httpresponse/service_http_response.dart';
import 'package:http/http.dart' as http;
import '../config.dart'; // Asegúrate que esto esté arriba

class UserService {
  final String baseUrl = Config.baseUrl;

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
    final url = Uri.parse('$baseUrl/api/users/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print('🎯 Usuario recibido: $data');

        return User.fromJson(data);
      } else if (response.statusCode == 404) {
        print('❌ Usuario no encontrado');
        return null;
      } else {
        print('❌ Error inesperado: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error de red: $e');
      return null;
    }
  }

  Future<ServiceHttpResponse> updateUser(
      User updatedUser,
      User originalUser,
      ) async {
    try {
      // Comparar cambios
      List<String> changes = [];
      if (updatedUser.name != originalUser.name) {
        changes.add('nombre de "${originalUser.name}" a "${updatedUser.name}"');
      }
      if (updatedUser.lastName != originalUser.lastName) {
        changes.add('apellido de "${originalUser.lastName}" a "${updatedUser.lastName}"');
      }
      if (updatedUser.mail != originalUser.mail) {
        changes.add('correo de "${originalUser.mail}" a "${updatedUser.mail}"');
      }

      // Imprimir cambios detectados
      if (changes.isNotEmpty) {
        print('========== ACTUALIZACIÓN DE PERFIL ==========');
        print('El usuario con ID "${updatedUser.userId}" cambió:');
        for (String change in changes) {
          print('- $change');
        }
        print('============================================');
      } else {
        print('🔎 No hay cambios en los datos del usuario.');
      }

      // Preparar cuerpo del PUT
      final body = {
        "name": updatedUser.name,
        "last_name": updatedUser.lastName,
        "nickname": updatedUser.nickname,
        "mail": updatedUser.mail,
      };

      final response = await http.put(
        Uri.parse('$baseUrl/api/users/${updatedUser.userId}'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('✅ Usuario actualizado en el servidor');
        return ServiceHttpResponse(
          status: 200,
          body: 'Usuario actualizado correctamente',
        );
      } else {
        print('❌ Error al actualizar usuario: ${response.body}');
        return ServiceHttpResponse(
          status: response.statusCode,
          body: 'Error al actualizar usuario: ${response.body}',
        );
      }
    } catch (e) {
      print('❌ Excepción al actualizar usuario: $e');
      return ServiceHttpResponse(
        status: 500,
        body: 'Error interno del servidor: $e',
      );
    }
  }
}
