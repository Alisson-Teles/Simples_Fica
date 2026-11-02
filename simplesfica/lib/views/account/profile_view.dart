import 'package:flutter/material.dart';

import '../../state/app_scope.dart';
import '../../theme/app_theme.dart';
import '../auth/login_view.dart';
import '../merchant/merchant_dashboard_view.dart';
import 'edit_profile_view.dart';

class ProfileView extends StatelessWidget {
  final VoidCallback onFavoritosPressed;

  const ProfileView({super.key, required this.onFavoritosPressed});

  void _mensagem(BuildContext context, String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  Future<void> _editarPerfil(BuildContext context) async {
    final sessao = AppScope.of(context);
    final salvo = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => EditProfileView(perfil: sessao.perfil)),
    );
    if (!context.mounted) return;
    if (salvo == true) {
      _mensagem(context, 'Perfil atualizado somente nesta sessão.');
    }
  }

  void _abrir(BuildContext context, Widget pagina) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => pagina));
  }

  Widget _opcao(IconData icone, String titulo, VoidCallback abrir) {
    return Card(color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icone, color: AppTheme.primary),
        title: Text(titulo),
        trailing: const Icon(Icons.chevron_right),
        onTap: abrir,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final perfil = AppScope.of(context).perfil;
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Meu perfil'), automaticallyImplyLeading: false),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Card(color: Colors.white,
          child: Padding(padding: const EdgeInsets.all(18),
            child: Row(children: [
              const CircleAvatar(radius: 30,
                  backgroundColor: Color(0xFFF4E3D7),
                  child: Icon(Icons.person, color: AppTheme.primary, size: 32)),
              const SizedBox(width: 16),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(perfil.nome,
                      style: const TextStyle(fontSize: 18,
                          fontWeight: FontWeight.bold, color: AppTheme.brown)),
                  Text(perfil.email, overflow: TextOverflow.ellipsis),
                  const Text('Perfil demonstrativo',
                      style: TextStyle(fontSize: 12, color: AppTheme.primary)),
                ],
              )),
            ]),
          ),
        ),
        const SizedBox(height: 24),
        _opcao(Icons.person_outline, 'Dados pessoais',
                () => _editarPerfil(context)),
        _opcao(Icons.favorite_border, 'Meus favoritos', onFavoritosPressed),
        _opcao(Icons.login, 'Entrar ou criar conta',
                () => _abrir(context, const LoginView())),
        _opcao(Icons.storefront_outlined, 'Meus negócios (demonstração)',
                () => _abrir(context, const MerchantDashboardView())),
        _opcao(Icons.settings_outlined, 'Configurações',
                () => _mensagem(context, 'Configurações: Etapa 7.')),
        const SizedBox(height: 20),
        const Text(
          'Modo de demonstração: o painel do comerciante é acessível '
              'sem login real. Nenhuma permissão ou alteração no servidor é concedida.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Color(0xFF78645C)),
        ),
      ]),
    );
  }
}