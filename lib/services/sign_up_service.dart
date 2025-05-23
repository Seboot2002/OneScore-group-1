import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../models/entities/user.dart';
import '../models/httpresponse/service_http_response.dart';

class SignUpService {
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/user.json');
  }

  Future<ServiceHttpResponse> registerUser(User newUser) async {
    try {
      final file = await _getLocalFile();
      List<User> users = [];

      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          final data = jsonDecode(content) as List;
          users = data.map((e) => User.fromJson(e)).toList();
        }
      }

      final exists = users.any(
        (u) =>
            u.mail.toLowerCase() == newUser.mail.toLowerCase() ||
            u.nickname.toLowerCase() == newUser.nickname.toLowerCase(),
      );

      if (exists) {
        return ServiceHttpResponse(status: 400, body: 'Usuario ya existe');
      }

      users.add(newUser);
      await file.writeAsString(
        jsonEncode(users.map((e) => e.toJson()).toList()),
      );

      return ServiceHttpResponse(status: 200, body: 'Usuario registrado');
    } catch (e) {
      return ServiceHttpResponse(status: 500, body: 'Error interno');
    }
  }
}
