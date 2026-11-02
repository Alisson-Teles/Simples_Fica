
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/models/admin_demo_models.dart';
import '../lib/state/admin_demo_state.dart';
import '../lib/theme/app_theme.dart';
import '../lib/views/admin/admin_dashboard_view.dart';

void main() {
  group('Indicadores de clientes', () {
    test(
      'Deve iniciar com um cliente ativo e um inativo',
          () {
        final estado = AdminDemoState();

        expect(estado.clientes, 2);
        expect(estado.clientesAtivos, 1);
        expect(estado.clientesInativos, 1);

        expect(
          estado.clientesAtivos +
              estado.clientesInativos,
          estado.clientes,
        );

        estado.dispose();
      },
    );

    test(
      'Ativar cliente deve atualizar os indicadores',
          () {
        final estado = AdminDemoState();

        final logsAntes = estado.auditoria.length;

        // Ana Exemplo começa inativa.
        estado.alterarStatusUsuario(
          4,
          StatusUsuarioAdmin.ativo,
        );

        expect(estado.clientesAtivos, 2);
        expect(estado.clientesInativos, 0);

        expect(
          estado.auditoria.length,
          logsAntes + 1,
        );

        estado.dispose();
      },
    );

    test(
      'Inativar cliente deve atualizar os indicadores',
          () {
        final estado = AdminDemoState();

        // Cliente de Teste começa ativo.
        estado.alterarStatusUsuario(
          1,
          StatusUsuarioAdmin.inativo,
        );

        expect(estado.clientesAtivos, 0);
        expect(estado.clientesInativos, 2);

        estado.dispose();
      },
    );

    test(
      'Cliente bloqueado também conta como inativo',
          () {
        final estado = AdminDemoState();

        estado.alterarStatusUsuario(
          1,
          StatusUsuarioAdmin.bloqueado,
        );

        expect(estado.clientesAtivos, 0);
        expect(estado.clientesInativos, 2);

        estado.dispose();
      },
    );
  });

  group('Navegação dos indicadores', () {
    testWidgets(
      'Clientes inativos deve abrir lista filtrada',
          (tester) async {
        final estado = AdminDemoState();

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: AdminDashboardView(
              estado: estado,
            ),
          ),
        );

        final indicador = find.text(
          'Clientes inativos',
        );

        await tester.ensureVisible(indicador);

        await tester.tap(indicador);
        await tester.pumpAndSettle();

        // Confirma a navegação.
        expect(
          find.text('Gerenciar usuários'),
          findsOneWidget,
        );

        // Ana Exemplo é a cliente inativa.
        expect(
          find.text('Ana Exemplo'),
          findsOneWidget,
        );

        // O cliente ativo não deve aparecer
        // na lista filtrada.
        expect(
          find.text('Cliente de Teste'),
          findsNothing,
        );

        await tester.pumpWidget(
          const SizedBox.shrink(),
        );

        estado.dispose();
      },
    );

    testWidgets(
      'Clientes ativos deve abrir lista filtrada',
          (tester) async {
        final estado = AdminDemoState();

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: AdminDashboardView(
              estado: estado,
            ),
          ),
        );

        final indicador = find.text(
          'Clientes ativos',
        );

        await tester.ensureVisible(indicador);

        await tester.tap(indicador);
        await tester.pumpAndSettle();

        expect(
          find.text('Gerenciar usuários'),
          findsOneWidget,
        );

        expect(
          find.text('Cliente de Teste'),
          findsOneWidget,
        );

        expect(
          find.text('Ana Exemplo'),
          findsNothing,
        );

        await tester.pumpWidget(
          const SizedBox.shrink(),
        );

        estado.dispose();
      },
    );
  });
}
