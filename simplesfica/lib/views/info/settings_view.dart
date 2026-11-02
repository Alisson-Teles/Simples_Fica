
import 'package:flutter/material.dart';

import '../../models/conta_demo.dart';
import '../../state/app_scope.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/app_feedback.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  Future<void> _restaurar(
      BuildContext context,
      ) async {
    final confirmou = await confirmarAcao(
      context,
      titulo: 'Restaurar preferências?',
      mensagem:
      'As opções de demonstração voltarão '
          'aos valores iniciais.',
      confirmar: 'Restaurar',
    );

    if (!context.mounted || !confirmou) {
      return;
    }

    AppScope.of(context).restaurarPreferencias();

    mostrarAviso(
      context,
      'Preferências restauradas.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessao = AppScope.of(context);

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text('Configurações'),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),

          children: [
            const Text(
              'Preferências',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: AppTheme.brown,
              ),
            ),

            const SizedBox(height: 12),

            Card(
              color: Colors.white,

              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(
                      Icons.tips_and_updates_outlined,
                      color: AppTheme.primary,
                    ),

                    title: const Text(
                      'Mostrar dicas no Perfil',
                    ),

                    subtitle: const Text(
                      'Exibir orientações rápidas '
                          'durante a navegação.',
                    ),

                    value: sessao.mostrarDicas,

                    onChanged: (valor) {
                      sessao.definirMostrarDicas(valor);
                    },
                  ),

                  const Divider(height: 1),

                  SwitchListTile(
                    secondary: const Icon(
                      Icons.logout_outlined,
                      color: AppTheme.primary,
                    ),

                    title: const Text(
                      'Confirmar antes de sair',
                    ),

                    subtitle: const Text(
                      'Solicitar confirmação antes '
                          'de encerrar a conta de teste.',
                    ),

                    value: sessao.confirmarAoSair,

                    onChanged: (valor) {
                      sessao.definirConfirmarAoSair(valor);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Aparência',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: AppTheme.brown,
              ),
            ),

            const SizedBox(height: 12),

            const Card(
              color: Colors.white,

              child: ListTile(
                leading: Icon(
                  Icons.palette_outlined,
                  color: AppTheme.primary,
                ),

                title: Text('Tema claro'),

                subtitle: Text(
                  'Tema utilizado atualmente. '
                      'Outros temas ainda não foram '
                      'implementados.',
                ),

                trailing: Icon(
                  Icons.check_circle_outline,
                  color: AppTheme.green,
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Sobre o aplicativo',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: AppTheme.brown,
              ),
            ),

            const SizedBox(height: 12),

            Card(
              color: Colors.white,

              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: AppTheme.primary,
                    ),

                    title: Text('Simples Fica'),

                    subtitle: Text(
                      'Protótipo mobile desenvolvido '
                          'em Flutter e Dart.',
                    ),
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(
                      Icons.account_circle_outlined,
                      color: AppTheme.primary,
                    ),

                    title: const Text('Conta atual'),

                    subtitle: Text(
                      '${sessao.tipoAcesso.titulo} (demo)',
                    ),
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(
                      Icons.favorite_border,
                      color: AppTheme.primary,
                    ),

                    title: const Text(
                      'Favoritos desta conta',
                    ),

                    trailing: Text(
                      '${sessao.favoritos.length}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,

              child: OutlinedButton.icon(
                onPressed: () {
                  _restaurar(context);
                },

                icon: const Icon(Icons.restart_alt),

                label: const Text(
                  'Restaurar preferências',
                ),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'As preferências e os favoritos '
                  'são mantidos apenas durante '
                  'esta execução do aplicativo. '
                  'Ainda não existe armazenamento '
                  'persistente no dispositivo nem '
                  'sincronização com um servidor.',
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
