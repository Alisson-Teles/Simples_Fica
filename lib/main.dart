
import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'views/splash_view.dart';

void main() {
  runApp(const SimplesFicaApp());
}

class SimplesFicaApp extends StatelessWidget {
  const SimplesFicaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simples Fica',
      theme: AppTheme.lightTheme,
      home: const SplashView(),
    );
  }
}
