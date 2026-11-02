
import 'package:flutter/material.dart';

import '../../models/conta_demo.dart';
import '../../state/app_scope.dart';
import '../../theme/app_theme.dart';

import '../admin/admin_demo_view.dart';
import '../auth/login_view.dart';
import '../merchant/merchant_dashboard_view.dart';

import 'edit_profile_view.dart';

class ProfileView extends StatelessWidget {
  final VoidCallback onFavoritosPressed;

  const ProfileView({
    super.key,
    required this.onFavoritosPressed,
  });

  void _mensagem(
      BuildContext context,
      String texto,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  void _abrir(
      BuildContext context,
      Widget pagina,
      ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => pagina,
      ),
    );
  }

  void _abrirSelecaoDeConta(
      BuildContext context,
      ) {
    _abrir(
      context,
      const LoginView(),
    );
  }

  Future<void> _editarPerfil(
      BuildContext context,
      ) async {
    final sessao = AppScope.of(context);

    final salvo =
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => EditProfileView(
          perfil: sessao.perfil,
        ),
      ),
    );

    if (!context.mounted) return;

    if (salvo == true) {
      _mensagem(
        context,
        'Dados atualizados nesta sessão '
            'demonstrativa.',
      );
    }
  }

  Future<void> _sair(
      BuildContext context,
      ) async {
    final confirmar =
    await showDialog<bool>(
      context: context,

      builder: (dialogContext) => AlertDialog(
        title: const Text('Sair da demonstração?'),

        content: const Text(
          'Os favoritos, negócios e vendas '
              'criados nesta sessão serão perdidos. '
              'Deseja continuar?',
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(false);
            },

            child: const Text('Cancelar'),
          ),

          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
            },

            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (!context.mounted ||
        confirmar != true) {
      return;
    }

    AppScope.of(context).encerrarAcesso();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const LoginView(),
      ),
          (route) => false,
    );
  }

  Widget _opcao(
      IconData icone,
      String titulo,
      VoidCallback abrir,
      ) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),

      child: ListTile(
        leading: Icon(
          icone,
          color: AppTheme.primary,
        ),

        title: Text(titulo),

        trailing: const Icon(
          Icons.chevron_right,
        ),

        onTap: abrir,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessao = AppScope.of(context);

    final perfil = sessao.perfil;
    final tipo = sessao.tipoAcesso;

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text('Meu perfil'),
        automaticallyImplyLeading: false,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          // CARTÃO DO PERFIL ATIVO
          Card(
            color: Colors.white,

            child: Padding(
              padding: const EdgeInsets.all(18),

              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor:
                    Color(0xFFF4E3D7),

                    child: Icon(
                      Icons.person,
                      color: AppTheme.primary,
                      size: 32,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [
                        Text(
                          perfil.nome,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.brown,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          perfil.email,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 8),

                        Chip(
                          label: Text(
                            '${tipo.titulo} (demo)',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 22),

          // PERFIL DE TESTE SELECIONADO
          if (!sessao.ehVisitante)
            _opcao(
              Icons.person_outline,
              'Dados pessoais',
                  () => _editarPerfil(context),
            ),

          // FAVORITOS PÚBLICOS
          _opcao(
            Icons.favorite_border,
            'Meus favoritos',
            onFavoritosPressed,
          ),

          // MENU ESPECÍFICO DO COMERCIANTE
          if (sessao.ehComerciante)
            _opcao(
              Icons.storefront_outlined,
              'Meus negócios (demo)',
                  () => _abrir(
                context,
                const MerchantDashboardView(),
              ),
            ),

          // MENU ESPECÍFICO DO ADMINISTRADOR
          if (sessao.ehAdministrador)
            _opcao(
              Icons.admin_panel_settings_outlined,
              'Painel administrativo (demo)',
                  () => _abrir(
                context,
                const AdminDemoView(),
              ),
            ),

          // SELEÇÃO DE CONTAS
          _opcao(
            Icons.switch_account_outlined,
            sessao.ehVisitante
                ? 'Entrar ou selecionar conta'
                : 'Trocar conta de teste',
                () => _abrirSelecaoDeConta(context),
          ),

          // CONFIGURAÇÕES FUTURAS
          _opcao(
            Icons.settings_outlined,
            'Configurações',
                () => _mensagem(
              context,
              'Configurações serão desenvolvidas '
                  'na Etapa 7.',
            ),
          ),

          // SAIR DO PERFIL
          if (!sessao.ehVisitante)
            _opcao(
              Icons.logout,
              'Sair da demonstração',
                  () => _sair(context),
            ),

          const SizedBox(height: 22),

          const Text(
            'As contas e as permissões desta '
                'tela são simuladas localmente. '
                'Não existe autenticação, autorização '
                'ou persistência de usuários reais.',
            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF78645C),
            ),
          ),
        ],
      ),
    );
  }
}
