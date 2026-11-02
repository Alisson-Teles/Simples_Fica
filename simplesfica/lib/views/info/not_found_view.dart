
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common/app_feedback.dart';

import '../core/main_navigation_view.dart';

class NotFoundView extends StatelessWidget {
  final String titulo;
  final String mensagem;

  const NotFoundView({
    super.key,
    this.titulo = 'Página não encontrada',
    this.mensagem =
    'Não foi possível encontrar '
        'o conteúdo solicitado.',
  });

  void _voltar(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    _irParaInicio(context);
  }

  void _irParaInicio(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const MainNavigationView(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Conteúdo indisponível'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AppEmptyState(
                titulo: titulo,
                mensagem: mensagem,
                icone: Icons.search_off_outlined,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                24,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _voltar(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Voltar'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () => _irParaInicio(context),
                    icon: const Icon(Icons.home_outlined),
                    label: const Text('Ir para o início'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
