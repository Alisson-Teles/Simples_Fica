import 'package:flutter/material.dart';

import '../../models/oferta.dart';
import '../../models/detalhes_estabelecimento.dart';
import '../../state/app_scope.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatacao.dart';
import 'offering_form_view.dart';

class OfferingsView extends StatefulWidget {
  final int negocioId;

  const OfferingsView({super.key, required this.negocioId});

  @override
  State<OfferingsView> createState() => _OfferingsViewState();
}

class _OfferingsViewState extends State<OfferingsView> {
  TipoOferta? _filtro;

  Future<void> _abrirFormulario([Oferta? original]) async {
    final resultado = await Navigator.of(context).push<Oferta>(
      MaterialPageRoute(builder: (context) => OfferingFormView(oferta: original)),
    );
    if (!mounted || resultado == null) return;
    AppScope.of(context).salvarOferta(widget.negocioId, resultado);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Oferta salva somente nesta sessão.')),
    );
  }

  Future<void> _excluir(Oferta oferta) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir oferta?'),
        content: Text('Remover "${oferta.nome}" do catálogo demonstrativo?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir')),
        ],
      ),
    );
    if (!mounted || confirmar != true) return;
    AppScope.of(context).excluirOferta(widget.negocioId, oferta.id);
  }

  @override
  Widget build(BuildContext context) {
    final sessao = AppScope.of(context);
    final negocio = sessao.negocioPorId(widget.negocioId);
    if (negocio == null) {
      return Scaffold(appBar: AppBar(title: const Text('Catálogo')),
          body: const Center(child: Text('Negócio não encontrado.')));
    }
    final lista = negocio.ofertas.where((o) =>
    _filtro == null || o.tipo == _filtro,
    ).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Produtos e serviços')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(Icons.add), label: const Text('Nova oferta'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        children: [
          Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Classificação: ${negocio.tipoAtuacao.rotulo}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Calculada apenas pelas ofertas ativas. '
                      'Produtos sem estoque ainda são produtos.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(spacing: 8, children: [
            ChoiceChip(label: const Text('Todos'), selected: _filtro == null,
                onSelected: (_) => setState(() => _filtro = null)),
            ChoiceChip(label: const Text('Produtos'),
                selected: _filtro == TipoOferta.produto,
                onSelected: (_) => setState(() => _filtro = TipoOferta.produto)),
            ChoiceChip(label: const Text('Serviços'),
                selected: _filtro == TipoOferta.servico,
                onSelected: (_) => setState(() => _filtro = TipoOferta.servico)),
          ]),
          const SizedBox(height: 16),
          if (lista.isEmpty)
            const Card(child: Padding(padding: EdgeInsets.all(24),
                child: Text('Nenhuma oferta neste filtro. Use Nova oferta para cadastrar.')))
          else
            ...lista.map((o) => Card(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(child: Text(o.nome,
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
                      PopupMenuButton<String>(
                        tooltip: 'Opções da oferta',
                        onSelected: (acao) {
                          if (acao == 'editar') _abrirFormulario(o);
                          if (acao == 'status') {
                            sessao.alterarStatusOferta(widget.negocioId, o.id);
                          }
                          if (acao == 'excluir') _excluir(o);
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem(value: 'editar', child: Text('Editar')),
                          PopupMenuItem(value: 'status',
                              child: Text(o.ativo ? 'Desativar' : 'Ativar')),
                          const PopupMenuItem(value: 'excluir', child: Text('Excluir')),
                        ],
                      ),
                    ]),
                    Text(o.tipo == TipoOferta.produto ? 'Produto' : 'Serviço'),
                    const SizedBox(height: 6),
                    Text(o.descricao),
                    const SizedBox(height: 8),
                    Text(o.preco == null ? 'Consultar valor' : formatarMoeda(o.preco!),
                        style: const TextStyle(color: AppTheme.primary,
                            fontWeight: FontWeight.bold)),
                    if (o.precoAte != null) Text('Até ${formatarMoeda(o.precoAte!)}'),
                    if (o.tipo == TipoOferta.produto)
                      Text('Estoque: ${o.estoque ?? 0}'),
                    if (o.sku != null) Text('SKU: ${o.sku}'),
                    Wrap(spacing: 8, children: [
                      Chip(label: Text(o.ativo ? 'Ativa' : 'Inativa')),
                      if (o.destaque) const Chip(label: Text('Destaque')),
                    ]),
                  ],
                ),
              ),
            )),
        ],
      ),
    );
  }
}