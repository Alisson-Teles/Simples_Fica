
import 'package:flutter_test/flutter_test.dart';

import '../lib/data/contas_demo.dart';
import '../lib/models/conta_demo.dart';
import '../lib/state/app_session.dart';

void main() {
  group('Contas demonstrativas', () {
    test('Deve reconhecer as três contas', () {
      expect(contasDemo.length, 3);

      expect(
        buscarContaDemo(
          'cliente@simplesfica.test',
          'Cliente123!',
        )?.tipo,
        TipoAcessoDemo.cliente,
      );

      expect(
        buscarContaDemo(
          'comerciante@simplesfica.test',
          'Comerciante123!',
        )?.tipo,
        TipoAcessoDemo.comerciante,
      );

      expect(
        buscarContaDemo(
          'admin@simplesfica.test',
          'Admin123!',
        )?.tipo,
        TipoAcessoDemo.administrador,
      );
    });

    test('Deve rejeitar senha incorreta', () {
      final conta = buscarContaDemo(
        'admin@simplesfica.test',
        'senha_errada',
      );

      expect(conta, isNull);
    });

    test('Deve ignorar maiúsculas no e-mail', () {
      final conta = buscarContaDemo(
        'CLIENTE@SIMPLESFICA.TEST',
        'Cliente123!',
      );

      expect(conta, isNotNull);

      expect(
        conta!.tipo,
        TipoAcessoDemo.cliente,
      );
    });
  });

  group('Sessão demonstrativa', () {
    test('Deve iniciar como visitante', () {
      final sessao = AppSession();

      expect(sessao.ehVisitante, isTrue);
      expect(sessao.negocios, isEmpty);

      sessao.dispose();
    });

    test('Cliente deve atualizar o perfil ativo', () {
      final sessao = AppSession();

      final conta = buscarContaDemo(
        'cliente@simplesfica.test',
        'Cliente123!',
      )!;

      sessao.iniciarContaDemo(conta);

      expect(
        sessao.tipoAcesso,
        TipoAcessoDemo.cliente,
      );

      expect(
        sessao.perfil.nome,
        'Cliente de Teste',
      );

      expect(sessao.ehComerciante, isFalse);
      expect(sessao.ehAdministrador, isFalse);

      sessao.dispose();
    });

    test('Comerciante deve receber negócio demo', () {
      final sessao = AppSession();

      final conta = buscarContaDemo(
        'comerciante@simplesfica.test',
        'Comerciante123!',
      )!;

      sessao.iniciarContaDemo(conta);

      expect(sessao.ehComerciante, isTrue);
      expect(sessao.negocios.length, 1);

      final negocio = sessao.negocios.first;

      expect(
        negocio.nome,
        'Tech Cell — Demonstração',
      );

      expect(
        negocio.ofertas.length,
        3,
      );

      expect(
        sessao.vendasDoNegocio(negocio.id).length,
        1,
      );

      expect(
        sessao.receitaDemo(negocio.id),
        closeTo(59.80, 0.001),
      );

      // Foram vendidas 2 das 12 unidades.
      expect(
        negocio.ofertas.first.estoque,
        10,
      );

      sessao.dispose();
    });

    test('Administrador deve ter perfil próprio', () {
      final sessao = AppSession();

      final conta = buscarContaDemo(
        'admin@simplesfica.test',
        'Admin123!',
      )!;

      sessao.iniciarContaDemo(conta);

      expect(sessao.ehAdministrador, isTrue);

      expect(
        sessao.perfil.email,
        'admin@simplesfica.test',
      );

      sessao.dispose();
    });

    test('Sair deve limpar os dados temporários', () {
      final sessao = AppSession();

      final conta = buscarContaDemo(
        'comerciante@simplesfica.test',
        'Comerciante123!',
      )!;

      sessao.iniciarContaDemo(conta);

      sessao.toggleFavorite(1);

      expect(sessao.negocios, isNotEmpty);
      expect(sessao.favoritos, isNotEmpty);

      sessao.encerrarAcesso();

      expect(sessao.ehVisitante, isTrue);
      expect(sessao.negocios, isEmpty);
      expect(sessao.favoritos, isEmpty);

      sessao.dispose();
    });
  });
}
