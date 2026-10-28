import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ponte Dourada',
      theme: criarTema(),
      home: const LoginPage(),
    );
  }
}
