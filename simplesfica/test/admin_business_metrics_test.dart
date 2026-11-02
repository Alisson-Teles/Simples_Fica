
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/models/admin_demo_models.dart';
import '../lib/models/detalhes_estabelecimento.dart';
import '../lib/state/admin_business_metrics.dart';
import '../lib/state/admin_demo_state.dart';
import '../lib/theme/app_theme.dart';
import '../lib/views/admin/admin_dashboard_view.dart';

void main() {
  group('Classificação administrativa', () {
    test('Deve contar os tipos sem duplicidade', () {
      final estado = AdminDemoState();

      expect(estado.totalComerciantesPrestadores, 5);
      expect(estado.somenteComerciantes, 2);
      expect(estado.somentePrestadores, 2);
      expect(estado.comerciantesEPrestadores, 1);
      expect(estado.negociosSemOfertas, 0);

      expect(
        estado.somenteComerciantes +
            estado.somentePrestadores +
            estado.comerciantesEPrestadores,
        estado.totalComerciantesPrestadores,
      );

      estado.dispose();
    });

    test('Tech Cell deve pertencer a Ambos', () {
      final estado = AdminDemoState();

      final techCell = estado.negocioPorId(2)!;

      expect(
        estado.atuacaoDe(techCell),
        TipoAtuacao.ambos,
      );

      expect(
        estado.correspondeFiltroAtuacao(
          techCell,
          FiltroAtuacaoAdmin.somenteComerciantes,
        ),
        isFalse,
      );

      expect(
        estado.correspondeFiltroAtuacao(
          techCell,
          FiltroAtuacaoAdmin.ambos,
        ),
        isTrue,
      );

      estado.dispose();
    });

    test('Suspensos devem manter classificação', () {
      final estado = AdminDemoState();

      expect(estado.negociosSuspensos, 1);

      final barbearia = estado.negocioPorId(3)!;

      expect(
        barbearia.status,
        StatusNegocioAdmin.suspenso,
      );

      expect(
        estado.atuacaoDe(barbearia),
        TipoAtuacao.servicos,
      );

      final filtrados = estado.filtrarNegocios(
        atuacao: FiltroAtuacaoAdmin.somentePrestadores,
        status: StatusNegocioAdmin.suspenso,
      );

      expect(filtrados.length, 1);
      expect(filtrados.first.nome, 'Barbearia Moderna');

      estado.dispose();
    });

    test('Suspender não altera contagem por atuação', () {
      final estado = AdminDemoState();

      final comerciantesAntes =
          estado.somenteComerciantes;

      final suspensosAntes = estado.negociosSuspensos;

      estado.alterarStatusNegocio(
        1,
        StatusNegocioAdmin.suspenso,
      );

      expect(
        estado.somenteComerciantes,
        comerciantesAntes,
      );

      expect(
        estado.negociosSuspensos,
        suspensosAntes + 1,
      );

      estado.dispose();
    });

    test('Reativar deve reduzir suspensos', () {
      final estado = AdminDemoState();

      estado.alterarStatusNegocio(
        3,
        StatusNegocioAdmin.ativo,
      );

      expect(estado.negociosSuspensos, 0);
      expect(estado.negociosAtivos, 4);
      expect(estado.somentePrestadores, 2);

      estado.dispose();
    });
  });

  group('Navegação pelo Dashboard', () {
    testWidgets(
      'Somente prestadores abre lista filtrada',
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
          'Somente prestadores',
        );

        await tester.ensureVisible(indicador);
        await tester.tap(indicador);
        await tester.pumpAndSettle();

        expect(
          find.text('Estabelecimentos'),
          findsOneWidget,
        );

        expect(
          find.text('Barbearia Moderna'),
          findsOneWidget,
        );

        expect(
          find.text('Oficina Rápida'),
          findsOneWidget,
        );

        expect(
          find.text('Café da Praça'),
          findsNothing,
        );

        await tester.pumpWidget(
          const SizedBox.shrink(),
        );

        estado.dispose();
      },
    );

    testWidgets(
      'Suspensos abre lista apenas de suspensos',
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

        final indicador = find.text('Suspensos');

        await tester.ensureVisible(indicador);
        await tester.tap(indicador);
        await tester.pumpAndSettle();

        expect(
          find.text('Barbearia Moderna'),
          findsOneWidget,
        );

        expect(
          find.text('Tech Cell'),
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
