
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/data/contas_demo.dart';
import '../lib/models/admin_demo_models.dart';
import '../lib/state/app_scope.dart';
import '../lib/state/app_session.dart';
import '../lib/views/account/favorites_view.dart';

void main() {
  group('Favoritos por conta', () {
    test(
      'Cliente mantém favoritos após trocar de perfil',
          () {
        final sessao = AppSession();

        final cliente = buscarContaDemo(
          'cliente@simplesfica.test',
          'Cliente123!',
        )!;

        final administrador = buscarContaDemo(
          'admin@simplesfica.test',
          'Admin123!',
        )!;

        // Entra como Cliente.
        sessao.iniciarContaDemo(cliente);

        // Favorita a Tech Cell.
        sessao.toggleFavorite(2);

        expect(
          sessao.isFavorite(2),
          isTrue,
        );

        // Troca para Administrador.
        sessao.encerrarAcesso();
        sessao.iniciarContaDemo(administrador);

        // O favorito do Cliente não aparece
        // na conta do Administrador.
        expect(
          sessao.isFavorite(2),
          isFalse,
        );

        // Volta para Cliente.
        sessao.encerrarAcesso();
        sessao.iniciarContaDemo(cliente);

        // O favorito continua salvo.
        expect(
          sessao.isFavorite(2),
          isTrue,
        );

        expect(sessao.favoritos, {2});

        sessao.dispose();
      },
    );

    test(
      'Suspender estabelecimento preserva favorito',
          () {
        final sessao = AppSession();

        final cliente = buscarContaDemo(
          'cliente@simplesfica.test',
          'Cliente123!',
        )!;

        sessao.iniciarContaDemo(cliente);

        sessao.toggleFavorite(2);

        // Suspende Tech Cell.
        sessao.administracao.alterarStatusNegocio(
          2,
          StatusNegocioAdmin.suspenso,
        );

        // O favorito permanece registrado.
        expect(
          sessao.isFavorite(2),
          isTrue,
        );

        // O estabelecimento deixa
        // de estar disponível ao público.
        expect(
          sessao.negocioDisponivelPublicamente(2),
          isFalse,
        );

        sessao.dispose();
      },
    );

    test(
      'Reativação restaura disponibilidade',
          () {
        final sessao = AppSession();

        final cliente = buscarContaDemo(
          'cliente@simplesfica.test',
          'Cliente123!',
        )!;

        sessao.iniciarContaDemo(cliente);
        sessao.toggleFavorite(2);

        sessao.administracao.alterarStatusNegocio(
          2,
          StatusNegocioAdmin.suspenso,
        );

        expect(
          sessao.negocioDisponivelPublicamente(2),
          isFalse,
        );

        // Reativa o estabelecimento.
        sessao.administracao.alterarStatusNegocio(
          2,
          StatusNegocioAdmin.ativo,
        );

        expect(
          sessao.negocioDisponivelPublicamente(2),
          isTrue,
        );

        // Não cria duplicações.
        expect(sessao.favoritos, {2});

        sessao.dispose();
      },
    );

    test(
      'Visitante e Cliente possuem listas diferentes',
          () {
        final sessao = AppSession();

        // Favorito do Visitante.
        sessao.toggleFavorite(1);

        expect(sessao.favoritos, {1});

        final cliente = buscarContaDemo(
          'cliente@simplesfica.test',
          'Cliente123!',
        )!;

        // Entra como Cliente.
        sessao.iniciarContaDemo(cliente);

        expect(sessao.favoritos, isEmpty);

        // Favorito próprio do Cliente.
        sessao.toggleFavorite(2);

        expect(sessao.favoritos, {2});

        // Retorna ao Visitante.
        sessao.entrarComoVisitante();

        expect(sessao.favoritos, {1});

        // Retorna ao Cliente.
        sessao.iniciarContaDemo(cliente);

        expect(sessao.favoritos, {2});

        sessao.dispose();
      },
    );

    test(
      'Editar o e-mail de exibição não apaga favoritos',
          () {
        final sessao = AppSession();

        final cliente = buscarContaDemo(
          'cliente@simplesfica.test',
          'Cliente123!',
        )!;

        sessao.iniciarContaDemo(cliente);
        sessao.toggleFavorite(2);

        // Atualiza somente o perfil de exibição.
        sessao.atualizarPerfil(
          const UsuarioPerfil(
            nome: 'Cliente Atualizado',
            email: 'outro-email@exemplo.test',
            telefone: '',
          ),
        );

        expect(sessao.favoritos, {2});

        // A conta demonstrativa original
        // continua sendo a referência.
        sessao.encerrarAcesso();
        sessao.iniciarContaDemo(cliente);

        expect(sessao.favoritos, {2});

        sessao.dispose();
      },
    );
  });

  group('Favoritos - Interface', () {
    testWidgets(
      'Favorito suspenso aparece como indisponível',
          (tester) async {
        final sessao = AppSession();

        final cliente = buscarContaDemo(
          'cliente@simplesfica.test',
          'Cliente123!',
        )!;

        sessao.iniciarContaDemo(cliente);

        // Salva Tech Cell como favorito.
        sessao.toggleFavorite(2);

        await tester.pumpWidget(
          AppScope(
            notifier: sessao,

            child: MaterialApp(
              home: FavoritesView(
                onExplorarPressed: () {},
              ),
            ),
          ),
        );

        expect(
          find.text('Tech Cell'),
          findsOneWidget,
        );

        // Suspensão administrativa.
        sessao.administracao.alterarStatusNegocio(
          2,
          StatusNegocioAdmin.suspenso,
        );

        await tester.pump();

        expect(
          find.text(
            'Indisponível na plataforma '
                'neste momento.',
          ),
          findsOneWidget,
        );

        expect(
          sessao.isFavorite(2),
          isTrue,
        );

        // Reativa Tech Cell.
        sessao.administracao.alterarStatusNegocio(
          2,
          StatusNegocioAdmin.ativo,
        );

        await tester.pump();

        expect(
          find.text('Tech Cell'),
          findsOneWidget,
        );

        expect(
          find.text(
            'Indisponível na plataforma '
                'neste momento.',
          ),
          findsNothing,
        );

        await tester.pumpWidget(
          const SizedBox.shrink(),
        );

        sessao.dispose();
      },
    );
  });
}
