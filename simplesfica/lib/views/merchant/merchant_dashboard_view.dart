import 'package:flutter/material.dart';

import '../../models/negocio_demo.dart';
import '../../models/detalhes_estabelecimento.dart';
import '../../state/app_scope.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatacao.dart';
import 'advertising_view.dart';
import 'business_registration_view.dart';
import 'business_preview_view.dart';
import 'edit_business_view.dart';
import 'offerings_view.dart';
import 'sales_view.dart';
import 'subscription_view.dart';

class MerchantDashboardView extends StatefulWidget {
  const MerchantDashboardView({super.key});

  @override
  State<MerchantDashboardView> createState() => _MerchantDashboardViewState();
}

class _MerchantDashboardViewState extends State<MerchantDashboardView> {
  int? _idSelecionado;

  Future<void> _cadastrarNegocio() async {
    final salvo = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const BusinessRegistrationView()),
    );
    if (!mounted || salvo != true) return;
    final lista = AppScope.of(context).negocios;
    if (lista.isNotEmpty) {
      setState(() => _idSelecionado = lista.last.id);
    }
  }

  Future<void> _editarNegocio(NegocioDemo negocio) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => EditBusinessView(negocio: negocio)),
    );
  }

  Future<void> _excluirNegocio(NegocioDemo negocio) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir negócio de teste?'),
        content: const Text('As ofertas e vendas locais deste negócio '
            'também serão excluídas. Esta ação não atinge nenhum servidor.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir')),
        ],
      ),
    );
    if (!mounted || confirmar != true) return;
    AppScope.of(context).removerNegocio(negocio.id);
    setState(() => _idSelecionado = null);
  }

  void _abrir(Widget tela) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => tela));
  }

  Widget _atalho(IconData icone, String nome, VoidCallback onTap) {
    return Card(color: Colors.white,
      child: ListTile(
        leading: Icon(icone, color: AppTheme.primary),
        title: Text(nome),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessao = AppScope.of(context);
    final negocios = sessao.negocios;
    final selecionado = negocios.any((n) => n.id == _idSelecionado)
        ? _idSelecionado
        : (negocios.isEmpty ? null : negocios.first.id);
    final negocio = selecionado == null ? null : sessao.negocioPorId(selecionado);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Área do comerciante (demo)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(color: Color(0xFFFFF3DC),
            child: Padding(padding: EdgeInsets.all(14),
              child: Text('MODO DEMONSTRAÇÃO — acesso livre apenas para '
                  'visualizar e testar as views. Nenhum comerciante está autenticado.'),
            ),
          ),
          const SizedBox(height: 14),
          if (negocios.isEmpty) ...[
            const SizedBox(height: 50),
            const Icon(Icons.storefront_outlined,
                color: AppTheme.primary, size: 72),
            const SizedBox(height: 18),
            const Text('Nenhum negócio cadastrado nesta sessão',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            const Text('Cadastre um negócio de teste para desbloquear '
                'catálogo, vendas, assinatura e anúncios demonstrativos.',
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _cadastrarNegocio,
              icon: const Icon(Icons.add_business),
              label: const Text('Cadastrar negócio (demo)'),
            ),
          ] else if (negocio != null) ...[
            Row(children: [
              const Expanded(child: Text('Meus negócios',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
              IconButton(
                tooltip: 'Cadastrar outro negócio',
                onPressed: _cadastrarNegocio,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ]),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              key: ValueKey('negocio-$selecionado'),
              initialValue: selecionado,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Negócio selecionado', border: OutlineInputBorder(),
              ),
              items: negocios.map((n) => DropdownMenuItem(
                value: n.id, child: Text(n.nome, overflow: TextOverflow.ellipsis),
              )).toList(),
              onChanged: (v) => setState(() => _idSelecionado = v),
            ),
            const SizedBox(height: 16),
            Card(color: Colors.white,
              child: Padding(padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(negocio.nome,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('${negocio.bairro}, ${negocio.cidade} - ${negocio.uf}'),
                    const SizedBox(height: 8),
                    Text('Tipo calculado: ${negocio.tipoAtuacao.rotulo}'),
                    const SizedBox(height: 12),
                    Wrap(spacing: 8, children: [
                      OutlinedButton.icon(
                        onPressed: () => _editarNegocio(negocio),
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Editar'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _excluirNegocio(negocio),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Excluir (demo)'),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(spacing: 12, runSpacing: 12, children: [
              Chip(label: Text('${negocio.ofertas.length} ofertas')),
              Chip(label: Text('${sessao.vendasDoNegocio(negocio.id).length} vendas')),
              Chip(label: Text('Receita demo: ${formatarMoeda(sessao.receitaDemo(negocio.id))}')),
            ]),
            const SizedBox(height: 18),
            const Text('Gerenciamento',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _atalho(Icons.remove_red_eye_outlined, 'Prévia pública (não publicada)',
                    () => _abrir(BusinessPreviewView(negocioId: negocio.id))),
            _atalho(Icons.inventory_2_outlined, 'Produtos e serviços',
                    () => _abrir(OfferingsView(negocioId: negocio.id))),
            _atalho(Icons.point_of_sale_outlined, 'Vendas demonstrativas',
                    () => _abrir(SalesView(negocioId: negocio.id))),
            _atalho(Icons.workspace_premium_outlined, 'Assinatura',
                    () => _abrir(SubscriptionView(nomeNegocio: negocio.nome))),
            _atalho(Icons.campaign_outlined, 'Anúncios',
                    () => _abrir(AdvertisingView(negocioId: negocio.id))),
            const SizedBox(height: 16),
            const Text('Este negócio é apenas local. Ele não aparece '
                'na Home ou na Explorar, que ainda utilizam os mocks públicos.'),
          ],
        ],
      ),
    );
  }
}