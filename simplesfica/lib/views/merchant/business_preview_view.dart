import 'package:flutter/material.dart';

import '../../models/oferta.dart';
import '../../models/detalhes_estabelecimento.dart';
import '../../state/app_scope.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatacao.dart';

class BusinessPreviewView extends StatelessWidget {
  final int negocioId;

  const BusinessPreviewView({super.key, required this.negocioId});

  @override
  Widget build(BuildContext context) {
    final negocio = AppScope.of(context).negocioPorId(negocioId);
    if (negocio == null) {
      return Scaffold(appBar: AppBar(title: const Text('Prévia pública')),
          body: const Center(child: Text('Negócio não encontrado.')));
    }
    final produtos = negocio.ofertas.where((o) =>
    o.ativo && o.tipo == TipoOferta.produto).toList();
    final servicos = negocio.ofertas.where((o) =>
    o.ativo && o.tipo == TipoOferta.servico).toList();

    Widget secao(String titulo, List<Oferta> ofertas) {
      return Card(color: Colors.white,
        child: Padding(padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...ofertas.map((o) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(o.nome),
                subtitle: Text(o.descricao),
                trailing: Text(o.preco == null ? 'Consultar' : formatarMoeda(o.preco!)),
              )),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Prévia pública (demo)')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Card(color: Color(0xFFFFF3DC),
          child: Padding(padding: EdgeInsets.all(12),
            child: Text('PRÉVIA LOCAL: este perfil não foi publicado '
                'na busca pública e não representa um anúncio ativo.'),
          ),
        ),
        const SizedBox(height: 12),
        Container(height: 130,
          decoration: BoxDecoration(
            color: const Color(0xFFF4E3D7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.storefront, size: 68, color: AppTheme.primary),
        ),
        const SizedBox(height: 14),
        Text(negocio.nome, style: const TextStyle(
            fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.brown)),
        Text('${negocio.categoria} • ${negocio.tipoAtuacao.rotulo}'),
        const SizedBox(height: 10),
        Text(negocio.descricao),
        const SizedBox(height: 18),
        if (produtos.isNotEmpty) secao('Produtos', produtos),
        if (servicos.isNotEmpty) secao('Serviços', servicos),
        if (produtos.isEmpty && servicos.isEmpty)
          const Card(child: Padding(padding: EdgeInsets.all(20),
              child: Text('Nenhuma oferta ativa para apresentar.'))),
        const SizedBox(height: 10),
        Card(color: Colors.white, child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Contato e localização', style: TextStyle(
                  fontSize: 19, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(negocio.endereco),
              Text('${negocio.bairro}, ${negocio.cidade} - ${negocio.uf}'),
              Text(negocio.telefone),
              const SizedBox(height: 10),
              Text(negocio.horarios),
            ],
          ),
        )),
      ]),
    );
  }
}