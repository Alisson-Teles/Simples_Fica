
import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'state/app_session.dart';
import 'state/app_scope.dart';
import 'views/core/splash_view.dart';

void main() {
  runApp(const SimplesFicaApp());
}

class SimplesFicaApp extends StatefulWidget {
  const SimplesFicaApp({super.key});

  @override
  State<SimplesFicaApp> createState() =>
      _SimplesFicaAppState();
}

class _SimplesFicaAppState extends State<SimplesFicaApp> {
  final AppSession _sessao = AppSession();

  @override
  void dispose() {
    _sessao.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      notifier: _sessao,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Simples Fica',
        theme: AppTheme.lightTheme,
        home: const SplashView(),
      ),
    );
  }
}
