import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/entities/user.dart';
import '../models/httpresponse/service_http_response.dart';

class LogInService {
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/user.json');
  }

  Future<List<User>> _readUsers() async {
    final file = await _getLocalFile();
    if (await file.exists()) {
      final content = await file.readAsString();
      final data = jsonDecode(content) as List;
      return data.map((e) => User.fromJson(e)).toList();
    } else {
      final assetContent = await rootBundle.loadString(
        'assets/jsons/user.json',
      );
      final data = jsonDecode(assetContent) as List;
      final users = data.map((e) => User.fromJson(e)).toList();
      await _saveUsers(users); // guarda una copia local para próximas lecturas
      return users;
    }
  }

  Future<void> _saveUsers(List<User> users) async {
    final file = await _getLocalFile();
    final json = jsonEncode(users.map((u) => u.toJson()).toList());
    await file.writeAsString(json);
  }

  Future<ServiceHttpResponse> logIn(String identifier, String password) async {
    try {
      final users = await _readUsers();

      final matchedUser = users.firstWhere(
        (user) =>
            (user.mail.toLowerCase() == identifier.toLowerCase() ||
                user.nickname.toLowerCase() == identifier.toLowerCase()) &&
            user.password == password,
        orElse: () => User.empty(),
      );

      if (matchedUser.userId != null) {
        return ServiceHttpResponse(status: 200, body: matchedUser);
      } else {
        return ServiceHttpResponse(
          status: 401,
          body: 'Usuario o contraseña incorrectos',
        );
      }
    } catch (e) {
      return ServiceHttpResponse(
        status: 500,
        body: 'Error al procesar los datos: $e',
      );
    }
  }

  /// Agrega nuevo usuario al archivo
  Future<ServiceHttpResponse> registerUser(User newUser) async {
    try {
      final users = await _readUsers();

      final alreadyExists = users.any(
        (u) =>
            u.mail.toLowerCase() == newUser.mail.toLowerCase() ||
            u.nickname.toLowerCase() == newUser.nickname.toLowerCase(),
      );

      if (alreadyExists) {
        return ServiceHttpResponse(
          status: 409,
          body: 'Ya existe un usuario con ese correo o nickname',
        );
      }

      users.add(newUser);
      await _saveUsers(users);

      return ServiceHttpResponse(
        status: 201,
        body: 'Usuario registrado exitosamente',
      );
    } catch (e) {
      return ServiceHttpResponse(
        status: 500,
        body: 'Error al registrar usuario: $e',
      );
    }
  }
}
