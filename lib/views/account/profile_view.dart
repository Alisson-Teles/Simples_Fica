
import 'package:flutter/material.dart';

import '../../state/app_scope.dart';
import '../../theme/app_theme.dart';

import 'edit_profile_view.dart';

class ProfileView extends StatelessWidget {
  final VoidCallback onFavoritosPressed;

  const ProfileView({
    super.key,
    required this.onFavoritosPressed,
  });

  void _mostrarMensagem(
      BuildContext context,
      String mensagem,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  Future<void> _editarPerfil(BuildContext context) async {
    final sessao = AppScope.of(context);

    final salvo = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => EditProfileView(
          perfil: sessao.perfil,
        ),
      ),
    );

    if (!context.mounted) return;

    if (salvo == true) {
      _mostrarMensagem(
        context,
        'Perfil atualizado nesta sessão de teste.',
      );
    }
  }

  Widget _opcao({
    required IconData icone,
    required String titulo,
    required VoidCallback onTap,
  }) {
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

        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessao = AppScope.of(context);
    final perfil = sessao.perfil;

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text(
          'Meu perfil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          // CARTÃO DO USUÁRIO
          Card(
            color: Colors.white,

            child: Padding(
              padding: const EdgeInsets.all(18),

              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFFF4E3D7),
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

                        const SizedBox(height: 6),

                        const Text(
                          'Perfil demonstrativo',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // MENU DE NAVEGAÇÃO
          _opcao(
            icone: Icons.person_outline,
            titulo: 'Dados pessoais',
            onTap: () {
              _editarPerfil(context);
            },
          ),

          _opcao(
            icone: Icons.favorite_border,
            titulo: 'Meus favoritos',
            onTap: onFavoritosPressed,
          ),

          _opcao(
            icone: Icons.login,
            titulo: 'Entrar ou criar conta',
            onTap: () {
              _mostrarMensagem(
                context,
                'Login e cadastro serão implementados '
                    'na Etapa 4.',
              );
            },
          ),

          _opcao(
            icone: Icons.storefront_outlined,
            titulo: 'Meus negócios',
            onTap: () {
              _mostrarMensagem(
                context,
                'O painel do comerciante será '
                    'desenvolvido na Etapa 5.',
              );
            },
          ),

          _opcao(
            icone: Icons.settings_outlined,
            titulo: 'Configurações',
            onTap: () {
              _mostrarMensagem(
                context,
                'Configurações serão implementadas '
                    'na Etapa 7.',
              );
            },
          ),

          const SizedBox(height: 24),

          const Text(
            'Os dados desta tela são demonstrativos. '
                'Nenhuma conta real está conectada.',
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
