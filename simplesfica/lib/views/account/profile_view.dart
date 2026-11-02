
import 'package:flutter/material.dart';

import '../../models/conta_demo.dart';
import '../../state/app_scope.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/app_feedback.dart';

import '../admin/admin_demo_view.dart';
import '../auth/login_view.dart';
import '../info/help_view.dart';
import '../info/how_it_works_view.dart';
import '../info/settings_view.dart';
import '../merchant/merchant_dashboard_view.dart';

import 'edit_profile_view.dart';

class ProfileView extends StatelessWidget {
  final VoidCallback onFavoritosPressed;

  const ProfileView({
    super.key,
    required this.onFavoritosPressed,
  });

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

  Future<void> _editarPerfil(
      BuildContext context,
      ) async {
    final sessao = AppScope.of(context);

    final salvo = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => EditProfileView(
          perfil: sessao.perfil,
        ),
      ),
    );

    if (!context.mounted) return;

    if (salvo == true) {
      mostrarAviso(
        context,
        'Perfil demonstrativo atualizado.',
      );
    }
  }

  Future<void> _sair(BuildContext context) async {
    final sessao = AppScope.of(context);

    if (sessao.confirmarAoSair) {
      final confirmou = await confirmarAcao(
        context,
        titulo: 'Sair da conta de teste?',
        mensagem: 'Seus favoritos e negócios '
            'demonstrativos serão preservados '
            'enquanto o aplicativo estiver aberto. '
            'Deseja voltar ao login?',
        confirmar: 'Sair',
      );

      if (!context.mounted || !confirmou) return;
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
      VoidCallback onTap,
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
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
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
                        Icons.person_outline,
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

            // Dica controlada pelas Configurações.
            if (sessao.mostrarDicas) ...[
              const SizedBox(height: 12),
              const Card(
                color: Color(0xFFFFF3DC),
                child: Padding(
                  padding: EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Icon(
                        Icons.tips_and_updates_outlined,
                        color: AppTheme.primary,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Dica: você pode trocar de '
                              'conta sem perder os favoritos '
                              'da conta anterior nesta execução.',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            if (!sessao.ehVisitante)
              _opcao(
                Icons.person_outline,
                'Dados pessoais',
                    () => _editarPerfil(context),
              ),

            _opcao(
              Icons.favorite_border,
              'Meus favoritos',
              onFavoritosPressed,
            ),

            if (sessao.ehComerciante)
              _opcao(
                Icons.storefront_outlined,
                'Meus negócios (demo)',
                    () => _abrir(
                  context,
                  const MerchantDashboardView(),
                ),
              ),

            if (sessao.ehAdministrador)
              _opcao(
                Icons.admin_panel_settings_outlined,
                'Painel administrativo (demo)',
                    () => _abrir(
                  context,
                  const AdminDemoView(),
                ),
              ),

            // ETAPA 7
            _opcao(
              Icons.lightbulb_outline,
              'Como funciona',
                  () => _abrir(
                context,
                const HowItWorksView(),
              ),
            ),

            _opcao(
              Icons.help_outline,
              'Central de ajuda',
                  () => _abrir(
                context,
                const HelpView(),
              ),
            ),

            _opcao(
              Icons.settings_outlined,
              'Configurações',
                  () => _abrir(
                context,
                const SettingsView(),
              ),
            ),

            _opcao(
              Icons.switch_account_outlined,
              sessao.ehVisitante
                  ? 'Entrar ou selecionar conta'
                  : 'Trocar conta de teste',
                  () => _abrir(
                context,
                const LoginView(),
              ),
            ),

            if (!sessao.ehVisitante)
              _opcao(
                Icons.logout,
                'Sair da demonstração',
                    () => _sair(context),
              ),

            const SizedBox(height: 16),

            const Text(
              'Os acessos e as permissões desta '
                  'versão são fictícios. O aplicativo '
                  'ainda não possui autenticação '
                  'ou persistência em servidor.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF78645C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
