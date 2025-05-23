import 'package:flutter/material.dart';
import 'pages/log_in/log_in_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Onescore',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      initialRoute: '/sign-in',
      routes: {'/sign-in': (context) => LogInPage()},
    );
  }
}
