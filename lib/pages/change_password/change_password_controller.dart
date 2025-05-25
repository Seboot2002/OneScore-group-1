import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:onescore/models/httpResponse/service_http_response.dart';

class ChangePasswordController extends GetxController {
    TextEditingController txtConstrasenaVieja = TextEditingController();
    TextEditingController txtContrasenaNueva = TextEditingController();
    TextEditingController txtRepiteConstrasena = TextEditingController();
    RxString message = ''.obs;
    
    ServiceHttpResponse? response = await.service.changePassword()

    void ChangePassword(context) async{
        String contrasena_vieja = txtConstrasenaVieja.text;
        String contrasena_nueva = txtContrasenaNueva.text;
        String repite_constrasena = txtRepiteConstrasena.text;
        
        if((contrasena_vieja == '') | (contrasena_vieja == '') | (repite_constrasena == '') ){
            message.value = 'Favor de llenar los datos';
        } else {
            if (contrasena_nueva != repite_constrasena){
                message.value = 'Cambio de contraseña negado';
            } else{
                if(response == null){
                    message.value = 'No se pudo conectar con el servidor';
                } else{
                    if(response.status = 200){
                        message.value = 'Cambio de contraseña efectuado';
                    } else{
                        message.value = 'Cambio de contraseña negado';
                    }
                }
            }
        }
    }
}
