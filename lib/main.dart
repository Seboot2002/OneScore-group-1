import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onescore/controllers/auth_controller.dart';
import 'package:onescore/pages/results/results_page.dart';
import 'pages/log_in/log_in_page.dart';
import 'pages/sign_up/sign_up_page.dart';
import 'pages/home/home_page.dart';
import 'pages/search_bar/search_bar_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Onescore',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      initialRoute: '/log-in',
      initialBinding: BindingsBuilder(() {
        // Inicializa controladores globales
        Get.put(AuthController());
      }),
      getPages: [
        GetPage(name: '/log-in', page: () => LogInPage()),
        GetPage(name: '/sign-up', page: () => SignUpPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/searching', page: () => SearchBarPage()),
        GetPage(name: '/results', page: () => ResultsPage()),
      ],
    );
  }
}
