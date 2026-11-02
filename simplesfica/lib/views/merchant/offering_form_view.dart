import 'package:flutter/material.dart';

import '../../models/oferta.dart';
import '../../theme/app_theme.dart';

class OfferingFormView extends StatefulWidget {
  final Oferta? oferta;

  const OfferingFormView({super.key, this.oferta});

  @override
  State<OfferingFormView> createState() => _OfferingFormViewState();
}

class _OfferingFormViewState extends State<OfferingFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nome;
  late final TextEditingController _descricao;
  late final TextEditingController _preco;
  late final TextEditingController _precoAte;
  late final TextEditingController _estoque;
  late final TextEditingController _sku;
  late final TextEditingController _unidade;
  late final TextEditingController _imagem;
  TipoOferta _tipo = TipoOferta.produto;
  bool _ativo = true;
  bool _destaque = false;

  @override
  void initState() {
    super.initState();
    final o = widget.oferta;
    _tipo = o?.tipo ?? TipoOferta.produto;
    _ativo = o?.ativo ?? true;
    _destaque = o?.destaque ?? false;
    _nome = TextEditingController(text: o?.nome ?? '');
    _descricao = TextEditingController(text: o?.descricao ?? '');
    _preco = TextEditingController(text: o?.preco?.toString() ?? '');
    _precoAte = TextEditingController(text: o?.precoAte?.toString() ?? '');
    _estoque = TextEditingController(text: o?.estoque?.toString() ?? '');
    _sku = TextEditingController(text: o?.sku ?? '');
    _unidade = TextEditingController(text: o?.unidade ?? 'un');
    _imagem = TextEditingController(text: o?.imagemUrl ?? '');
  }

  @override
  void dispose() {
    for (final c in [
      _nome, _descricao, _preco, _precoAte, _estoque,
      _sku, _unidade, _imagem,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  double? _decimal(String texto) =>
      double.tryParse(texto.trim().replaceAll(',', '.'));

  String? _validarPreco(String? texto) {
    final t = (texto ?? '').trim();
    if (t.isEmpty) {
      return _tipo == TipoOferta.produto ? 'Informe o preço do produto.' : null;
    }
    final valor = _decimal(t);
    if (valor == null || !valor.isFinite || valor <= 0) {
      return 'Informe um preço maior que zero.';
    }
    return null;
  }

  String? _validarPrecoAte(String? texto) {
    final t = (texto ?? '').trim();
    if (t.isEmpty) return null;
    final valor = _decimal(t);
    if (valor == null || !valor.isFinite || valor <= 0) {
      return 'Informe um valor final válido.';
    }
    final inicial = _decimal(_preco.text);
    if (inicial == null) return 'Informe o preço inicial antes.';
    if (valor < inicial) return 'O valor final deve ser maior ou igual ao inicial.';
    return null;
  }

  String? _validarEstoque(String? texto) {
    if (_tipo == TipoOferta.servico) return null;
    final valor = int.tryParse((texto ?? '').trim());
    if (valor == null || valor < 0) {
      return 'Informe estoque inteiro, zero ou maior.';
    }
    return null;
  }

  void _salvar() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final oferta = Oferta(
      id: widget.oferta?.id ?? -1,
      tipo: _tipo,
      nome: _nome.text.trim(),
      descricao: _descricao.text.trim(),
      preco: _preco.text.trim().isEmpty ? null : _decimal(_preco.text),
      precoAte: _precoAte.text.trim().isEmpty ? null : _decimal(_precoAte.text),
      estoque: _tipo == TipoOferta.produto ? int.parse(_estoque.text.trim()) : null,
      sku: _sku.text.trim().isEmpty ? null : _sku.text.trim(),
      unidade: _unidade.text.trim(),
      imagemUrl: _imagem.text.trim().isEmpty ? null : _imagem.text.trim(),
      ativo: _ativo,
      destaque: _destaque,
    );
    Navigator.pop(context, oferta);
  }

  Widget _campo(
      String titulo, TextEditingController controller, {
        bool obrigatorio = false,
        int linhas = 1,
        TextInputType? teclado,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: linhas,
        keyboardType: teclado,
        decoration: InputDecoration(
          labelText: titulo, border: const OutlineInputBorder(),
        ),
        validator: validator ?? (obrigatorio
            ? (v) => (v?.trim().isEmpty ?? true) ? 'Campo obrigatório.' : null
            : null),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final produto = _tipo == TipoOferta.produto;
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(widget.oferta == null ? 'Nova oferta' : 'Editar oferta')),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('Catálogo demonstrativo: nenhum produto ou serviço será publicado.'),
            const SizedBox(height: 18),
            DropdownButtonFormField<TipoOferta>(
              initialValue: _tipo,
              decoration: const InputDecoration(
                labelText: 'Tipo de oferta', border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: TipoOferta.produto, child: Text('Produto')),
                DropdownMenuItem(value: TipoOferta.servico, child: Text('Serviço')),
              ],
              onChanged: (t) => setState(() => _tipo = t ?? _tipo),
            ),
            const SizedBox(height: 14),
            _campo('Nome', _nome, obrigatorio: true),
            _campo('Descrição', _descricao, linhas: 3, obrigatorio: true),
            _campo('Preço inicial (R\$)', _preco,
                teclado: const TextInputType.numberWithOptions(decimal: true),
                validator: _validarPreco),
            _campo('Preço final (opcional)', _precoAte,
                teclado: const TextInputType.numberWithOptions(decimal: true),
                validator: _validarPrecoAte),
            if (produto) _campo('Estoque', _estoque,
                teclado: TextInputType.number, validator: _validarEstoque),
            _campo('SKU / código interno (opcional)', _sku),
            _campo('Unidade (un, kg, hora)', _unidade, obrigatorio: true),
            _campo('URL de imagem (opcional)', _imagem),
            SwitchListTile(
              title: const Text('Oferta ativa'),
              value: _ativo,
              onChanged: (v) => setState(() => _ativo = v),
            ),
            SwitchListTile(
              title: const Text('Destacar no catálogo'),
              value: _destaque,
              onChanged: (v) => setState(() => _destaque = v),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: _salvar,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Salvar oferta (demo)'),
            ),
          ],
        ),
      ),
    );
  }
}