import 'dart:convert';

import 'package:flutter/services.dart';
import '../models/httpResponse/service_http_response.dart';

class ChangePassService {
  Future <ServiceHttpResponse?> changePassword(User u, String contrasena_vieja, String contrasena_nueva, String repite_constrasena) async{
    ServiceHttpResponse serviceResponse = ServiceHttpResponse();
    final String body = await rootBundle.loadString('assets/jsons/users.json');
    final List <dynamic> data = jsonDecode(body);
    
  }
}