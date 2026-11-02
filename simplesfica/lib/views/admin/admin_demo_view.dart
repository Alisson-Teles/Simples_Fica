
import 'package:flutter/material.dart';

import '../../state/app_scope.dart';
import '../../theme/app_theme.dart';

import 'admin_dashboard_view.dart';

class AdminDemoView extends StatelessWidget {
  const AdminDemoView({super.key});

  @override
  Widget build(BuildContext context) {
    final sessao = AppScope.of(context);

    if (!sessao.ehAdministrador) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: const Text('Administração'),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Selecione a conta Administrador '
                  'para abrir este painel de teste.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return AdminDashboardView(
      estado: sessao.administracao,
    );
  }
}
