
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/data/contas_demo.dart';
import '../lib/models/admin_demo_models.dart';
import '../lib/models/negocio_demo.dart';
import '../lib/state/app_scope.dart';
import '../lib/state/app_session.dart';
import '../lib/views/public/explore_view.dart';

void main() {
  group('Catálogo compartilhado', () {
    test('Começa com cinco cadastros e três públicos', () {
      final sessao = AppSession();

      expect(sessao.administracao.negocios.length, 5);
      expect(sessao.administracao.negociosAtivos, 3);
      expect(sessao.administracao.negociosSuspensos, 1);
      expect(sessao.administracao.negociosPublicados, 3);

      final nomes = sessao.estabelecimentosPublicos
          .map((e) => e.nome)
          .toList();

      expect(nomes, contains('Café da Praça'));
      expect(nomes, contains('Tech Cell'));
      expect(nomes, contains('Mercado Central'));

      expect(nomes, isNot(contains('Barbearia Moderna')));
      expect(nomes, isNot(contains('Oficina Rápida')));

      sessao.dispose();
    });

    test('Suspensão remove negócio do catálogo público', () {
      final sessao = AppSession();

      expect(
        sessao.negocioDisponivelPublicamente(2),
        isTrue,
      );

      sessao.administracao.alterarStatusNegocio(
        2,
        StatusNegocioAdmin.suspenso,
      );

      expect(
        sessao.negocioDisponivelPublicamente(2),
        isFalse,
      );

      expect(
        sessao.estabelecimentosPublicos.any(
              (e) => e.id == 2,
        ),
        isFalse,
      );

      // Continua cadastrado na administração.
      expect(
        sessao.administracao.negocioPorId(2),
        isNotNull,
      );

      expect(sessao.administracao.negociosSuspensos, 2);
      expect(sessao.administracao.negociosPublicados, 2);

      sessao.dispose();
    });

    test('Suspensão remove patrocinado sem apagar anúncio', () {
      final sessao = AppSession();

      expect(
        sessao.administracao.negociosPatrocinados,
        contains(1),
      );

      sessao.administracao.alterarStatusNegocio(
        1,
        StatusNegocioAdmin.suspenso,
      );

      expect(
        sessao.administracao.negociosPatrocinados,
        isNot(contains(1)),
      );

      expect(
        sessao.administracao.anunciosAtivos,
        1,
      );

      sessao.dispose();
    });

    test('Reativação restaura a visibilidade', () {
      final sessao = AppSession();

      sessao.administracao.alterarStatusNegocio(
        2,
        StatusNegocioAdmin.suspenso,
      );

      sessao.administracao.alterarStatusNegocio(
        2,
        StatusNegocioAdmin.ativo,
      );

      expect(
        sessao.negocioDisponivelPublicamente(2),
        isTrue,
      );

      expect(sessao.estabelecimentosPublicos.length, 3);

      sessao.dispose();
    });

    test('Retirar publicação oculta negócio ativo', () {
      final sessao = AppSession();

      sessao.administracao.alterarPublicacao(
        2,
        false,
      );

      expect(
        sessao.administracao.negocioPorId(2)!.status,
        StatusNegocioAdmin.ativo,
      );

      expect(
        sessao.negocioDisponivelPublicamente(2),
        isFalse,
      );

      expect(sessao.administracao.negociosAtivos, 3);
      expect(sessao.administracao.negociosPublicados, 2);

      sessao.dispose();
    });

    test('Favorito continua registrado após suspensão', () {
      final sessao = AppSession();

      sessao.toggleFavorite(2);

      sessao.administracao.alterarStatusNegocio(
        2,
        StatusNegocioAdmin.suspenso,
      );

      expect(sessao.isFavorite(2), isTrue);
      expect(
        sessao.negocioDisponivelPublicamente(2),
        isFalse,
      );

      sessao.dispose();
    });
  });

  group('Integração Comerciante e Administrador', () {
    test('Negócio do comerciante exige publicação', () {
      final sessao = AppSession();

      final comerciante = buscarContaDemo(
        'comerciante@simplesfica.test',
        'Comerciante123!',
      )!;

      sessao.iniciarContaDemo(comerciante);

      // O cenário inicial é registrado
      // também na administração.
      final cadastro =
      sessao.administracao.negocioPorId(100);

      expect(cadastro, isNotNull);
      expect(cadastro!.publicado, isFalse);

      expect(
        sessao.negocioDisponivelPublicamente(100),
        isFalse,
      );

      sessao.administracao.alterarPublicacao(
        100,
        true,
      );

      expect(
        sessao.negocioDisponivelPublicamente(100),
        isTrue,
      );

      expect(
        sessao.estabelecimentosPublicos.any(
              (e) => e.id == 100,
        ),
        isTrue,
      );

      sessao.dispose();
    });

    test('Trocar de conta preserva negócio no teste', () {
      final sessao = AppSession();

      sessao.iniciarContaDemo(
        buscarContaDemo(
          'comerciante@simplesfica.test',
          'Comerciante123!',
        )!,
      );

      sessao.encerrarAcesso();

      sessao.iniciarContaDemo(
        buscarContaDemo(
          'admin@simplesfica.test',
          'Admin123!',
        )!,
      );

      expect(
        sessao.administracao.negocioPorId(100),
        isNotNull,
      );

      sessao.administracao.alterarPublicacao(
        100,
        true,
      );

      sessao.encerrarAcesso();

      sessao.iniciarContaDemo(
        buscarContaDemo(
          'cliente@simplesfica.test',
          'Cliente123!',
        )!,
      );

      expect(
        sessao.estabelecimentosPublicos.any(
              (e) => e.id == 100,
        ),
        isTrue,
      );

      sessao.dispose();
    });

    test('Editar ofertas não elimina suspensão', () {
      final sessao = AppSession();

      sessao.iniciarContaDemo(
        buscarContaDemo(
          'comerciante@simplesfica.test',
          'Comerciante123!',
        )!,
      );

      sessao.administracao.alterarPublicacao(
        100,
        true,
      );

      sessao.administracao.alterarStatusNegocio(
        100,
        StatusNegocioAdmin.suspenso,
      );

      final negocio = sessao.negocioPorId(100)!;

      sessao.atualizarNegocio(
        negocio.copyWith(
          descricao: 'Descrição atualizada.',
        ),
      );

      expect(
        sessao.administracao.negocioPorId(100)!.status,
        StatusNegocioAdmin.suspenso,
      );

      expect(
        sessao.negocioDisponivelPublicamente(100),
        isFalse,
      );

      sessao.dispose();
    });

    test('Negócio sem ofertas não pode ser publicado', () {
      final sessao = AppSession();

      final id = sessao.cadastrarNegocio(
        const NegocioDemo(
          id: -1,
          nome: 'Negócio vazio',
          descricao: 'Sem ofertas',
          categoria: 'Outros',
          cidade: 'Rio Verde',
          bairro: 'Centro',
          uf: 'GO',
          endereco: 'Rua de teste, 10',
          telefone: '(64) 99999-0000',
          horarios: '09h às 18h',
        ),
      );

      expect(
            () => sessao.administracao.alterarPublicacao(
          id,
          true,
        ),
        throwsStateError,
      );

      sessao.dispose();
    });
  });

  group('Reação da interface pública', () {
    testWidgets(
      'Explorar atualiza contagem após suspensão',
          (tester) async {
        final sessao = AppSession();

        await tester.pumpWidget(
          AppScope(
            notifier: sessao,
            child: const MaterialApp(
              home: ExploreView(),
            ),
          ),
        );

        expect(
          find.textContaining('3 opção'),
          findsOneWidget,
        );

        sessao.administracao.alterarStatusNegocio(
          2,
          StatusNegocioAdmin.suspenso,
        );

        await tester.pump();

        expect(
          find.textContaining('2 opção'),
          findsOneWidget,
        );

        await tester.pumpWidget(
          const SizedBox.shrink(),
        );

        sessao.dispose();
      },
    );
  });
}
