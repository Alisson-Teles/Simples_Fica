
import 'package:flutter/material.dart';

import '../../models/usuario_perfil.dart';
import '../../state/app_scope.dart';
import '../../theme/app_theme.dart';

class EditProfileView extends StatefulWidget {
  final UsuarioPerfil perfil;

  const EditProfileView({
    super.key,
    required this.perfil,
  });

  @override
  State<EditProfileView> createState() =>
      _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  late final TextEditingController _nomeController;
  late final TextEditingController _emailController;
  late final TextEditingController _telefoneController;

  @override
  void initState() {
    super.initState();

    _nomeController = TextEditingController(
      text: widget.perfil.nome,
    );

    _emailController = TextEditingController(
      text: widget.perfil.email,
    );

    _telefoneController = TextEditingController(
      text: widget.perfil.telefone,
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();

    super.dispose();
  }

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

  void _salvarPerfil() {
    FocusScope.of(context).unfocus();

    final formularioValido =
        _formKey.currentState?.validate() ?? false;

    if (!formularioValido) {
      return;
    }

    final novoPerfil = UsuarioPerfil(
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      telefone: _telefoneController.text.trim(),
    );

    AppScope.of(context).atualizarPerfil(novoPerfil);

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text(
          'Editar perfil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode:
          AutovalidateMode.onUserInteraction,

          child: ListView(
            padding: const EdgeInsets.all(20),

            children: [
              const Text(
                'Dados pessoais',
                style: TextStyle(
                  color: AppTheme.brown,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Atualize as informações do '
                    'perfil demonstrativo.',
              ),

              const SizedBox(height: 28),

              // NOME
              TextFormField(
                controller: _nomeController,
                textCapitalization:
                TextCapitalization.words,

                decoration: const InputDecoration(
                  labelText: 'Nome',
                  prefixIcon:
                  Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),

                validator: _validarNome,
              ),

              const SizedBox(height: 18),

              // EMAIL
              TextFormField(
                controller: _emailController,
                keyboardType:
                TextInputType.emailAddress,

                decoration: const InputDecoration(
                  labelText: 'E-mail',
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

                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  hintText: '(64) 99999-9999',
                  prefixIcon:
                  Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(),
                ),

                validator: _validarTelefone,
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  onPressed: _salvarPerfil,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Salvar alterações'),
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'As alterações serão mantidas '
                    'somente enquanto esta sessão '
                    'de demonstração estiver ativa.',
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
    );
  }
}
