
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() =>
      _ForgotPasswordViewState();
}

class _ForgotPasswordViewState
    extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validarEmail(String? valor) {
    final email = valor?.trim() ?? '';

    if (email.isEmpty) {
      return 'Informe seu e-mail.';
    }

    final formatoEmail = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    if (!formatoEmail.hasMatch(email)) {
      return 'Informe um e-mail válido.';
    }

    return null;
  }

  void _validarRecuperacao() {
    FocusScope.of(context).unfocus();

    final valido =
        _formKey.currentState?.validate() ?? false;

    if (!valido) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 5),
        content: Text(
          'E-mail validado localmente. '
              'Nenhuma mensagem de recuperação '
              'foi enviada.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text('Recuperar senha'),
      ),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 480,
            ),

            child: Form(
              key: _formKey,
              autovalidateMode:
              AutovalidateMode.onUserInteraction,

              child: ListView(
                padding: const EdgeInsets.all(24),

                children: [
                  const SizedBox(height: 24),

                  const Icon(
                    Icons.lock_reset,
                    size: 64,
                    color: AppTheme.primary,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Esqueceu sua senha?',
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brown,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Informe seu e-mail para '
                        'testar o formulário de '
                        'recuperação de senha.',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  TextFormField(
                    controller: _emailController,
                    keyboardType:
                    TextInputType.emailAddress,

                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      hintText: 'usuario@exemplo.com',
                      prefixIcon:
                      Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),

                    validator: _validarEmail,
                    onFieldSubmitted: (_) {
                      _validarRecuperacao();
                    },
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      onPressed: _validarRecuperacao,
                      icon: const Icon(
                        Icons.mark_email_read_outlined,
                      ),
                      label: const Text(
                        'Validar e-mail (teste)',
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },

                    child: const Text(
                      'Voltar para o login',
                    ),
                  ),

                  const SizedBox(height: 32),

                  const Text(
                    'Esta é uma demonstração. '
                        'Nenhum e-mail será enviado '
                        'e nenhuma senha será alterada.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF78645C),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
