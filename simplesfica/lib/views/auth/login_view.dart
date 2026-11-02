
import 'package:flutter/material.dart';

import '../../data/contas_demo.dart';
import '../../models/conta_demo.dart';
import '../../state/app_scope.dart';
import '../../theme/app_theme.dart';

import '../core/main_navigation_view.dart';
import 'account_type_view.dart';
import 'forgot_password_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() =>
      _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  final _emailController =
  TextEditingController();

  final _senhaController =
  TextEditingController();

  bool _mostrarSenha = false;
  bool _verificando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  // =====================================
  // VALIDAÇÕES
  // =====================================

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

  // =====================================
  // NAVEGAÇÃO PRINCIPAL
  // =====================================

  void _abrirAplicativo() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) =>
        const MainNavigationView(),
      ),
          (route) => false,
    );
  }

  // =====================================
  // LOGIN DEMONSTRATIVO
  // =====================================

  Future<void> _entrar() async {
    FocusScope.of(context).unfocus();

    if (_verificando) return;

    final valido =
        _formKey.currentState?.validate() ?? false;

    if (!valido) return;

    setState(() {
      _verificando = true;
    });

    // Pequeno carregamento visual de teste.
    await Future<void>.delayed(
      const Duration(milliseconds: 400),
    );

    if (!mounted) return;

    final conta = buscarContaDemo(
      _emailController.text,
      _senhaController.text,
    );

    setState(() {
      _verificando = false;
    });

    if (conta == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Conta demonstrativa não encontrada '
                'ou senha incorreta.',
          ),
        ),
      );

      return;
    }

    // Seleciona o perfil fictício na sessão.
    AppScope.of(context).iniciarContaDemo(conta);

    _abrirAplicativo();
  }

  // =====================================
  // ENTRAR COMO VISITANTE
  // =====================================

  void _entrarComoVisitante() {
    AppScope.of(context).entrarComoVisitante();

    _abrirAplicativo();
  }

  // =====================================
  // PREENCHIMENTO AUTOMÁTICO
  // =====================================

  void _preencherConta(ContaDemo conta) {
    _emailController.text = conta.email;
    _senhaController.text = conta.senha;

    FocusScope.of(context).unfocus();

    setState(() {
      _mostrarSenha = false;
    });
  }

  // =====================================
  // CADASTRO E RECUPERAÇÃO
  // =====================================

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

  // =====================================
  // BOTÃO DE ACESSO RÁPIDO
  // =====================================

  Widget _botaoContaDemo(ContaDemo conta) {
    final IconData icone;

    switch (conta.tipo) {
      case TipoAcessoDemo.cliente:
        icone = Icons.person_outline;
        break;

      case TipoAcessoDemo.comerciante:
        icone = Icons.storefront_outlined;
        break;

      case TipoAcessoDemo.administrador:
        icone = Icons.admin_panel_settings_outlined;
        break;

      case TipoAcessoDemo.visitante:
        icone = Icons.person_search_outlined;
        break;
    }

    return OutlinedButton.icon(
      onPressed: _verificando
          ? null
          : () => _preencherConta(conta),

      icon: Icon(icone),

      label: Text(conta.tipo.titulo),
    );
  }

  // =====================================
  // INTERFACE
  // =====================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text('Simples Fica'),
        automaticallyImplyLeading: false,
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
                  const SizedBox(height: 8),

                  const Icon(
                    Icons.storefront,
                    size: 60,
                    color: AppTheme.primary,
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Bem-vindo ao Simples Fica',
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brown,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Escolha uma conta demonstrativa '
                        'ou continue como visitante.',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  // EMAIL
                  TextFormField(
                    controller: _emailController,
                    enabled: !_verificando,
                    keyboardType:
                    TextInputType.emailAddress,
                    textInputAction:
                    TextInputAction.next,

                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      hintText:
                      'cliente@simplesfica.test',
                      prefixIcon:
                      Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),

                    validator: _validarEmail,
                  ),

                  const SizedBox(height: 16),

                  // SENHA
                  TextFormField(
                    controller: _senhaController,
                    enabled: !_verificando,
                    obscureText: !_mostrarSenha,

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
                      _entrar();
                    },
                  ),

                  const SizedBox(height: 22),

                  // BOTÃO ENTRAR
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      onPressed:
                      _verificando ? null : _entrar,

                      icon: _verificando
                          ? const SizedBox(
                        height: 18,
                        width: 18,

                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Icon(Icons.login),

                      label: Text(
                        _verificando
                            ? 'Verificando...'
                            : 'Entrar (demo)',
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  OutlinedButton.icon(
                    onPressed: _verificando
                        ? null
                        : _entrarComoVisitante,

                    icon: const Icon(
                      Icons.explore_outlined,
                    ),

                    label: const Text(
                      'Continuar como visitante',
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [
                      TextButton(
                        onPressed: _abrirCadastro,
                        child: const Text('Criar conta'),
                      ),

                      TextButton(
                        onPressed: _abrirRecuperacao,
                        child: const Text(
                          'Esqueci a senha',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  const Divider(),

                  const SizedBox(height: 14),

                  const Text(
                    'ACESSOS RÁPIDOS DE TESTE',
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brown,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Toque em um perfil para '
                        'preencher o e-mail e a senha. '
                        'Depois pressione Entrar.',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,

                    children: [
                      for (final conta in contasDemo)
                        _botaoContaDemo(conta),
                    ],
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'MODO DEMONSTRAÇÃO\n'
                        'As credenciais são fictícias '
                        'e ficam no código do aplicativo. '
                        'Nenhuma autenticação real '
                        'é realizada. Não utilize '
                        'senhas pessoais nos testes.',
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
