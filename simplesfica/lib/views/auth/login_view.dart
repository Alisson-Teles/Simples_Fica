
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

import 'account_type_view.dart';
import 'forgot_password_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  bool _mostrarSenha = false;
  bool _verificando = false;

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

  String? _validarSenha(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Informe sua senha.';
    }

    return null;
  }

  Future<void> _validarDemonstracao() async {
    FocusScope.of(context).unfocus();

    final valido =
        _formKey.currentState?.validate() ?? false;

    if (!valido || _verificando) {
      return;
    }

    setState(() {
      _verificando = true;
    });

    // Apenas demonstra o estado visual de carregamento.
    await Future<void>.delayed(
      const Duration(milliseconds: 500),
    );

    if (!mounted) return;

    setState(() {
      _verificando = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Campos validados localmente. '
              'Nenhum login foi realizado.',
        ),
      ),
    );
  }

  void _abrirCadastro() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
        const AccountTypeView(),
      ),
    );
  }

  void _abrirRecuperacao() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
        const ForgotPasswordView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text('Entrar'),
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
                  const SizedBox(height: 20),

                  const Icon(
                    Icons.lock_outline,
                    size: 56,
                    color: AppTheme.primary,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Bem-vindo de volta',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brown,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Entre para acessar sua conta.',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // CAMPO DE E-MAIL
                  TextFormField(
                    keyboardType:
                    TextInputType.emailAddress,
                    textInputAction:
                    TextInputAction.next,
                    enabled: !_verificando,

                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      hintText: 'usuario@exemplo.com',
                      prefixIcon:
                      Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),

                    validator: _validarEmail,
                  ),

                  const SizedBox(height: 18),

                  // CAMPO DE SENHA
                  TextFormField(
                    obscureText: !_mostrarSenha,
                    enabled: !_verificando,

                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon:
                      const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),

                      suffixIcon: IconButton(
                        tooltip: _mostrarSenha
                            ? 'Ocultar senha'
                            : 'Mostrar senha',

                        icon: Icon(
                          _mostrarSenha
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),

                        onPressed: () {
                          setState(() {
                            _mostrarSenha = !_mostrarSenha;
                          });
                        },
                      ),
                    ),

                    validator: _validarSenha,
                    onFieldSubmitted: (_) {
                      _validarDemonstracao();
                    },
                  ),

                  const SizedBox(height: 28),

                  // BOTÃO ENTRAR
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      onPressed: _verificando
                          ? null
                          : _validarDemonstracao,

                      child: _verificando
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text('Entrar'),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: _abrirRecuperacao,
                    child: const Text('Esqueci a senha'),
                  ),

                  TextButton(
                    onPressed: _abrirCadastro,
                    child: const Text('Criar conta'),
                  ),

                  const SizedBox(height: 32),

                  const Text(
                    'DEMONSTRAÇÃO DE INTERFACE\n'
                        'Nenhuma credencial será autenticada.',
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
