
import 'package:flutter/material.dart';

import '../../models/tipo_conta.dart';
import '../../theme/app_theme.dart';

class RegisterView extends StatefulWidget {
  final TipoConta tipoConta;

  const RegisterView({
    super.key,
    required this.tipoConta,
  });

  @override
  State<RegisterView> createState() =>
      _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarController = TextEditingController();

  bool _mostrarSenha = false;
  bool _mostrarConfirmacao = false;
  bool _aceitouDemonstracao = false;
  bool _mostrarErroCondicoes = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    _confirmarController.dispose();

    super.dispose();
  }

  // VALIDAÇÃO DO NOME
  String? _validarNome(String? valor) {
    final nome = valor?.trim() ?? '';

    if (nome.isEmpty) {
      return 'Informe seu nome.';
    }

    if (nome.length < 3) {
      return 'O nome deve ter pelo menos 3 caracteres.';
    }

    return null;
  }

  // VALIDAÇÃO DO E-MAIL
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

  // VALIDAÇÃO DO TELEFONE
  String? _validarTelefone(String? valor) {
    final telefone = valor?.trim() ?? '';

    if (telefone.isEmpty) {
      return null;
    }

    final numeros = telefone.replaceAll(
      RegExp(r'\D'),
      '',
    );

    if (numeros.length != 10 &&
        numeros.length != 11) {
      return 'Informe um telefone com DDD válido.';
    }

    return null;
  }

  // VALIDAÇÃO DA SENHA
  String? _validarSenha(String? valor) {
    final senha = valor ?? '';

    if (senha.isEmpty) {
      return 'Informe uma senha.';
    }

    if (senha.length < 8) {
      return 'A senha deve ter pelo menos 8 caracteres.';
    }

    return null;
  }

  // CONFIRMAÇÃO DA SENHA
  String? _validarConfirmacao(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Confirme sua senha.';
    }

    if (valor != _senhaController.text) {
      return 'As senhas não são iguais.';
    }

    return null;
  }

  // VALIDAÇÃO FINAL DO CADASTRO
  void _validarCadastro() {
    FocusScope.of(context).unfocus();

    final formularioValido =
        _formKey.currentState?.validate() ?? false;

    setState(() {
      _mostrarErroCondicoes = !_aceitouDemonstracao;
    });

    if (!formularioValido ||
        !_aceitouDemonstracao) {
      return;
    }

    // Não enviar dados nem criar contas nesta etapa.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 5),
        content: Text(
          'Formulário validado localmente. '
              'Nenhuma conta foi criada ou enviada '
              'a um servidor.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ehComerciante =
        widget.tipoConta == TipoConta.comerciante;

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text('Criar conta'),
      ),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),

            child: Form(
              key: _formKey,
              autovalidateMode:
              AutovalidateMode.onUserInteraction,

              child: ListView(
                padding: const EdgeInsets.all(24),

                children: [
                  const SizedBox(height: 12),

                  Text(
                    ehComerciante
                        ? 'Cadastro de comerciante'
                        : 'Cadastro de cliente',

                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brown,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    ehComerciante
                        ? 'Informe seus dados pessoais. '
                        'O estabelecimento será cadastrado '
                        'em uma etapa separada.'
                        : 'Preencha os campos abaixo '
                        'para conhecer o formulário '
                        'de cadastro.',
                  ),

                  const SizedBox(height: 24),

                  // NOME
                  TextFormField(
                    controller: _nomeController,
                    textCapitalization:
                    TextCapitalization.words,
                    textInputAction:
                    TextInputAction.next,

                    decoration: const InputDecoration(
                      labelText: 'Nome completo',
                      prefixIcon:
                      Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),

                    validator: _validarNome,
                  ),

                  const SizedBox(height: 18),

                  // E-MAIL
                  TextFormField(
                    controller: _emailController,
                    keyboardType:
                    TextInputType.emailAddress,
                    textInputAction:
                    TextInputAction.next,

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

                  // TELEFONE
                  TextFormField(
                    controller: _telefoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction:
                    TextInputAction.next,

                    decoration: const InputDecoration(
                      labelText: 'Telefone (opcional)',
                      hintText: '(64) 99999-9999',
                      prefixIcon:
                      Icon(Icons.phone_outlined),
                      border: OutlineInputBorder(),
                    ),

                    validator: _validarTelefone,
                  ),

                  const SizedBox(height: 18),

                  // SENHA
                  TextFormField(
                    controller: _senhaController,
                    obscureText: !_mostrarSenha,
                    textInputAction:
                    TextInputAction.next,

                    decoration: InputDecoration(
                      labelText: 'Senha',
                      helperText:
                      'Mínimo de 8 caracteres',
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
                  ),

                  const SizedBox(height: 18),

                  // CONFIRMAR SENHA
                  TextFormField(
                    controller: _confirmarController,
                    obscureText: !_mostrarConfirmacao,

                    decoration: InputDecoration(
                      labelText: 'Confirmar senha',
                      prefixIcon:
                      const Icon(Icons.lock_reset),
                      border: const OutlineInputBorder(),

                      suffixIcon: IconButton(
                        tooltip: _mostrarConfirmacao
                            ? 'Ocultar confirmação'
                            : 'Mostrar confirmação',

                        icon: Icon(
                          _mostrarConfirmacao
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),

                        onPressed: () {
                          setState(() {
                            _mostrarConfirmacao =
                            !_mostrarConfirmacao;
                          });
                        },
                      ),
                    ),

                    validator: _validarConfirmacao,
                  ),

                  const SizedBox(height: 24),

                  // ACEITE DAS CONDIÇÕES DE TESTE
                  CheckboxListTile(
                    value: _aceitouDemonstracao,
                    controlAffinity:
                    ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,

                    title: const Text(
                      'Entendo que este é um protótipo '
                          'e que nenhum cadastro será '
                          'criado ou armazenado.',
                      style: TextStyle(fontSize: 14),
                    ),

                    onChanged: (valor) {
                      setState(() {
                        _aceitouDemonstracao =
                            valor ?? false;

                        _mostrarErroCondicoes = false;
                      });
                    },
                  ),

                  if (_mostrarErroCondicoes)
                    const Padding(
                      padding: EdgeInsets.only(
                        bottom: 12,
                      ),

                      child: Text(
                        'Confirme que compreendeu '
                            'as condições da demonstração.',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // BOTÃO CRIAR CONTA
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      onPressed: _validarCadastro,
                      icon: const Icon(Icons.person_add),
                      label: const Text(
                        'Validar cadastro (teste)',
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },

                    child: const Text(
                      'Voltar e escolher outro tipo de conta',
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'DEMONSTRAÇÃO DE INTERFACE\n'
                        'Nenhuma conta será criada. '
                        'Não utilize senhas reais nos testes.',
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
