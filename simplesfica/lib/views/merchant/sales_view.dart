import 'package:flutter/material.dart';

import '../../models/oferta.dart';
import '../../state/app_scope.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatacao.dart';

class SalesView extends StatefulWidget {
  final int negocioId;

  const SalesView({super.key, required this.negocioId});

  @override
  State<SalesView> createState() => _SalesViewState();
}

class _SalesViewState extends State<SalesView> {
  final _formKey = GlobalKey<FormState>();
  final _quantidade = TextEditingController(text: '1');
  int? _ofertaSelecionada;

  @override
  void dispose() {
    _quantidade.dispose();
    super.dispose();
  }

  void _registrar() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final id = _ofertaSelecionada;
    if (id == null) return;
    final sessao = AppScope.of(context);
    try {
      sessao.registrarVenda(
        widget.negocioId, id, int.parse(_quantidade.text.trim()),
      );
      setState(() {
        _ofertaSelecionada = null;
        _quantidade.text = '1';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Venda registrada apenas nesta sessão.')),
      );
    } on StateError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessao = AppScope.of(context);
    final negocio = sessao.negocioPorId(widget.negocioId);
    if (negocio == null) {
      return Scaffold(appBar: AppBar(title: const Text('Vendas')),
          body: const Center(child: Text('Negócio não encontrado.')));
    }

    final disponiveis = negocio.ofertas.where((o) =>
    o.ativo && o.preco != null && o.preco! > 0 &&
        (o.tipo == TipoOferta.servico || (o.estoque ?? 0) > 0),
    ).toList();
    final selecionado = disponiveis.any((o) => o.id == _ofertaSelecionada)
        ? _ofertaSelecionada : null;
    final vendas = sessao.vendasDoNegocio(widget.negocioId);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Vendas (demo)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(color: Colors.white,
            child: Padding(padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Registrar venda de teste',
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Nenhum pagamento ou transação real é realizado.'),
                  const SizedBox(height: 14),
                  Form(key: _formKey, child: Column(children: [
                    DropdownButtonFormField<int>(
                      key: ValueKey('venda-$selecionado'),
                      initialValue: selecionado,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Produto ou serviço', border: OutlineInputBorder(),
                      ),
                      items: disponiveis.map((o) => DropdownMenuItem(
                        value: o.id,
                        child: Text('${o.nome} — ${formatarMoeda(o.preco!)}',
                            overflow: TextOverflow.ellipsis),
                      )).toList(),
                      validator: (v) => v == null ? 'Selecione uma oferta.' : null,
                      onChanged: (v) => setState(() => _ofertaSelecionada = v),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _quantidade,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Quantidade', border: OutlineInputBorder(),
                      ),
                      validator: (v) {
                        final n = int.tryParse((v ?? '').trim());
                        if (n == null || n <= 0) return 'Informe um inteiro maior que zero.';
                        final oferta = disponiveis.where((o) => o.id == selecionado);
                        if (oferta.isNotEmpty && oferta.first.tipo == TipoOferta.produto &&
                            n > (oferta.first.estoque ?? 0)) {
                          return 'Quantidade superior ao estoque disponível.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    SizedBox(width: double.infinity, child: ElevatedButton.icon(
                      onPressed: disponiveis.isEmpty ? null : _registrar,
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Registrar venda (demo)'),
                    )),
                  ])),
                  if (disponiveis.isEmpty) const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text('Cadastre ofertas ativas com preço e estoque para testar.'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Total demonstrativo: ${formatarMoeda(sessao.receitaDemo(widget.negocioId))}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('${vendas.length} venda(s) registrada(s) nesta sessão'),
          const SizedBox(height: 12),
          if (vendas.isEmpty)
            const Card(child: Padding(padding: EdgeInsets.all(20),
                child: Text('Nenhuma venda de teste registrada.')))
          else
            ...vendas.map((v) => Card(color: Colors.white,
              child: ListTile(
                title: Text(v.nomeOferta),
                subtitle: Text('${v.quantidade} unidade(s) · ${formatarData(v.data)}'),
                trailing: Text(formatarMoeda(v.total)),
              ),
            )),
        ],
      ),
    );
  }
}