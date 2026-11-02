
import 'package:flutter_test/flutter_test.dart';

import '../lib/models/usuario_perfil.dart';
import '../lib/state/app_session.dart';

void main() {
  group('AppSession', () {

    test('Deve adicionar e remover favoritos', () {
      final sessao = AppSession();

      expect(sessao.favoritos, isEmpty);

      sessao.toggleFavorite(2);

      expect(sessao.isFavorite(2), isTrue);
      expect(sessao.favoritos.length, 1);

      sessao.toggleFavorite(2);

      expect(sessao.isFavorite(2), isFalse);
      expect(sessao.favoritos, isEmpty);

      sessao.dispose();
    });

    test('Deve atualizar o perfil local', () {
      final sessao = AppSession();

      const novoPerfil = UsuarioPerfil(
        nome: 'Usuário Simples Fica',
        email: 'teste@exemplo.com',
        telefone: '',
      );

      sessao.atualizarPerfil(novoPerfil);

      expect(
        sessao.perfil.nome,
        'Usuário Simples Fica',
      );

      expect(
        sessao.perfil.email,
        'teste@exemplo.com',
      );

      sessao.dispose();
    });

    test('Deve notificar alterações', () {
      final sessao = AppSession();

      int notificacoes = 0;

      sessao.addListener(() {
        notificacoes++;
      });

      sessao.toggleFavorite(1);
      sessao.atualizarPerfil(
        const UsuarioPerfil(
          nome: 'Novo usuário',
          email: 'novo@exemplo.com',
          telefone: '',
        ),
      );

      expect(notificacoes, 2);

      sessao.dispose();
    });
  });
}
