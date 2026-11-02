
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

// Estado vazio com mensagem e ação opcional.
class AppEmptyState extends StatelessWidget {
  final String titulo;
  final String mensagem;
  final IconData icone;
  final String? textoBotao;
  final VoidCallback? onPressed;

  const AppEmptyState({
    super.key,
    required this.titulo,
    required this.mensagem,
    this.icone = Icons.inbox_outlined,
    this.textoBotao,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icone,
              size: 60,
              color: AppTheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.brown,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              mensagem,
              textAlign: TextAlign.center,
            ),
            if (textoBotao != null &&
                onPressed != null) ...[
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: onPressed,
                child: Text(textoBotao!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Indicador de carregamento padronizado.
class AppLoadingState extends StatelessWidget {
  final String mensagem;

  const AppLoadingState({
    super.key,
    this.mensagem = 'Carregando informações...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 18),
            Text(
              mensagem,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Estado de erro com possibilidade de tentar novamente.
class AppErrorState extends StatelessWidget {
  final String mensagem;
  final VoidCallback? tentarNovamente;

  const AppErrorState({
    super.key,
    required this.mensagem,
    this.tentarNovamente,
  });

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      titulo: 'Não foi possível concluir',
      mensagem: mensagem,
      icone: Icons.error_outline,
      textoBotao:
      tentarNovamente == null ? null : 'Tentar novamente',
      onPressed: tentarNovamente,
    );
  }
}

// Confirmação reutilizável.
Future<bool> confirmarAcao(
    BuildContext context, {
      required String titulo,
      required String mensagem,
      String confirmar = 'Confirmar',
    }) async {
  final resposta = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(titulo),
      content: Text(mensagem),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext, false);
          },
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(dialogContext, true);
          },
          child: Text(confirmar),
        ),
      ],
    ),
  );

  return resposta ?? false;
}

// Mensagem breve de feedback.
void mostrarAviso(
    BuildContext context,
    String mensagem,
    ) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mensagem),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
