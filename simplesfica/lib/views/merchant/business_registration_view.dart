import 'package:flutter/material.dart';

import '../../models/negocio_demo.dart';
import '../../state/app_scope.dart';
import '../../theme/app_theme.dart';

// O mesmo formulário atende ao cadastro e à edição.
class BusinessRegistrationView extends StatelessWidget {
  const BusinessRegistrationView({super.key});

  @override
  Widget build(BuildContext context) => const BusinessFormView();
}

class BusinessFormView extends StatefulWidget {
  final NegocioDemo? negocio;

  const BusinessFormView({super.key, this.negocio});

  @override
  State<BusinessFormView> createState() => _BusinessFormViewState();
}

class _BusinessFormViewState extends State<BusinessFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nome;
  late final TextEditingController _descricao;
  late final TextEditingController _cidade;
  late final TextEditingController _bairro;
  late final TextEditingController _uf;
  late final TextEditingController _endereco;
  late final TextEditingController _telefone;
  late final TextEditingController _horarios;
  late final TextEditingController _imagem;
  String _categoria = 'Alimentação';

  final _categorias = const [
    'Alimentação', 'Tecnologia', 'Beleza',
    'Mercados', 'Automotivo', 'Outros',
  ];

  @override
  void initState() {
    super.initState();
    final n = widget.negocio;
    _nome = TextEditingController(text: n?.nome ?? '');
    _descricao = TextEditingController(text: n?.descricao ?? '');
    _cidade = TextEditingController(text: n?.cidade ?? '');
    _bairro = TextEditingController(text: n?.bairro ?? '');
    _uf = TextEditingController(text: n?.uf ?? 'GO');
    _endereco = TextEditingController(text: n?.endereco ?? '');
    _telefone = TextEditingController(text: n?.telefone ?? '');
    _horarios = TextEditingController(text: n?.horarios ?? '');
    _imagem = TextEditingController(text: n?.imagemUrl ?? '');
    _categoria = _categorias.contains(n?.categoria)
        ? n!.categoria
        : 'Alimentação';
  }

  @override
  void dispose() {
    for (final c in [
      _nome, _descricao, _cidade, _bairro, _uf,
      _endereco, _telefone, _horarios, _imagem,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _obrigatorio(String? valor) =>
      (valor == null || valor.trim().isEmpty)
          ? 'Campo obrigatório.'
          : null;

  String? _validarTelefone(String? valor) {
    final numeros = (valor ?? '').replaceAll(RegExp(r'\D'), '');
    if (numeros.length != 10 && numeros.length != 11) {
      return 'Informe telefone com DDD (10 ou 11 dígitos).';
    }
    return null;
  }

  void _salvar() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final original = widget.negocio;
    final negocio = NegocioDemo(
      id: original?.id ?? -1,
      nome: _nome.text.trim(),
      descricao: _descricao.text.trim(),
      categoria: _categoria,
      cidade: _cidade.text.trim(),
      bairro: _bairro.text.trim(),
      uf: _uf.text.trim().toUpperCase(),
      endereco: _endereco.text.trim(),
      telefone: _telefone.text.trim(),
      horarios: _horarios.text.trim(),
      imagemUrl: _imagem.text.trim().isEmpty ? null : _imagem.text.trim(),
      ofertas: original?.ofertas ?? const [],
    );

    final sessao = AppScope.of(context);
    if (original == null) {
      sessao.cadastrarNegocio(negocio);
    } else {
      sessao.atualizarNegocio(negocio);
    }
    Navigator.pop(context, true);
  }

  Widget _campo(
      String titulo,
      TextEditingController controller, {
        int linhas = 1,
        bool obrigatorio = true,
        TextInputType? teclado,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: linhas,
        keyboardType: teclado,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: titulo,
          border: const OutlineInputBorder(),
          alignLabelWithHint: linhas > 1,
        ),
        validator: validator ?? (obrigatorio ? _obrigatorio : null),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.negocio != null;
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(editando ? 'Editar negócio' : 'Cadastrar negócio')),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Informações do estabelecimento',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Cadastro local para testar as views. Não será publicado.'),
            const SizedBox(height: 20),
            _campo('Nome do negócio', _nome),
            _campo('Descrição', _descricao, linhas: 3),
            DropdownButtonFormField<String>(
              initialValue: _categoria,
              decoration: const InputDecoration(
                labelText: 'Categoria', border: OutlineInputBorder(),
              ),
              items: _categorias.map((c) =>
                  DropdownMenuItem(value: c, child: Text(c)),
              ).toList(),
              onChanged: (valor) => setState(() => _categoria = valor ?? _categoria),
            ),
            const SizedBox(height: 14),
            _campo('Cidade', _cidade),
            _campo('Bairro', _bairro),
            _campo('UF', _uf, validator: (v) =>
            (v?.trim().length ?? 0) == 2 ? null : 'Informe 2 letras (ex.: GO).'),
            _campo('Endereço', _endereco),
            _campo('Telefone com DDD', _telefone,
                teclado: TextInputType.phone, validator: _validarTelefone),
            _campo('Horários de funcionamento', _horarios, linhas: 3),
            _campo('URL de foto (referência opcional)', _imagem, obrigatorio: false,
                teclado: TextInputType.url),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(14),
                child: Row(children: [
                  Icon(Icons.image_outlined, color: AppTheme.primary),
                  SizedBox(width: 12),
                  Expanded(child: Text(
                    'A foto é apenas uma referência de texto. '
                        'Upload e armazenamento de imagens virão com a API.',
                  )),
                ]),
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: _salvar,
              icon: const Icon(Icons.save_outlined),
              label: Text(editando ? 'Salvar alterações (demo)' : 'Criar negócio (demo)'),
            ),
          ],
        ),
      ),
    );
  }
}