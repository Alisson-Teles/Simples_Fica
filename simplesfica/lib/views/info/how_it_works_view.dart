
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'help_view.dart';

class HowItWorksView extends StatelessWidget {
  const HowItWorksView({super.key});

  Widget _passo(
      int numero,
      String titulo,
      String descricao,
      IconData icone,
      ) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFF4E3D7),
              child: Icon(
                icone,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    '$numero. $titulo',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brown,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(descricao),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Como funciona'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Icon(
              Icons.lightbulb_outline,
              size: 60,
              color: AppTheme.primary,
            ),
            const SizedBox(height: 14),
            const Text(
              'O que fica perto, fica fácil.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppTheme.brown,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'O Simples Fica aproxima pessoas '
                  'de comércios e prestadores de serviços '
                  'da sua região.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            _passo(
              1,
              'Encontre estabelecimentos',
              'Use a Home ou a aba Explorar para '
                  'pesquisar negócios, produtos e serviços. '
                  'Os filtros ajudam a refinar os resultados.',
              Icons.search_outlined,
            ),

            _passo(
              2,
              'Confira os detalhes',
              'Consulte ofertas ativas, informações '
                  'do estabelecimento, endereço e '
                  'horários demonstrativos.',
              Icons.storefront_outlined,
            ),

            _passo(
              3,
              'Entre em contato',
              'As telas apresentam formas previstas '
                  'de contato. WhatsApp, telefonia e mapas '
                  'ainda precisam de integração real.',
              Icons.chat_outlined,
            ),

            _passo(
              4,
              'Guarde seus favoritos',
              'Salve estabelecimentos na conta de '
                  'teste atual. Se um negócio for suspenso, '
                  'ele permanece salvo, mas será mostrado '
                  'como indisponível.',
              Icons.favorite_border,
            ),

            _passo(
              5,
              'Identifique anúncios',
              'Os conteúdos patrocinados aparecem '
                  'identificados como anúncio. Eles não '
                  'alteram os filtros ou a ordem da busca '
                  'orgânica em Explorar.',
              Icons.campaign_outlined,
            ),

            _passo(
              6,
              'Cadastre seu negócio',
              'O Comerciante pode criar um cadastro '
                  'e adicionar produtos ou serviços. '
                  'Na demonstração, o Administrador '
                  'precisa aprovar a publicação.',
              Icons.add_business_outlined,
            ),

            const SizedBox(height: 14),

            const Card(
              color: Color(0xFFFFF3DC),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'MODO DEMONSTRAÇÃO\n'
                      'Os cadastros, as vendas e as decisões '
                      'administrativas são simulados. '
                      'Ainda não há sincronização com outros '
                      'celulares, pagamentos ou autenticação '
                      'segura no servidor.',
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const HelpView(),
                  ),
                );
              },
              icon: const Icon(Icons.help_outline),
              label: const Text(
                'Ver perguntas frequentes',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
