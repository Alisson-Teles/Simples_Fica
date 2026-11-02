
import 'package:flutter/material.dart';

import '../../data/estabelecimentos_mock.dart';
import '../../models/estabelecimento.dart';
import '../../theme/app_theme.dart';
import '../../widgets/business/estabelecimento_card.dart';
import 'business_detail_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  Estabelecimento _buscarPorId(int id) {
    return estabelecimentosMock.firstWhere(
          (estabelecimento) => estabelecimento.id == id,
    );
  }

  void _abrirDetalhes(
      BuildContext context,
      Estabelecimento estabelecimento,
      ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BusinessDetailView(
          estabelecimento: estabelecimento,
        ),
      ),
    );
  }

  Widget _card(
      BuildContext context,
      int id, {
        bool patrocinado = false,
      }) {
    final estabelecimento = _buscarPorId(id);

    return EstabelecimentoCard(
      estabelecimento: estabelecimento,
      patrocinado: patrocinado,
      onTap: () {
        _abrirDetalhes(context, estabelecimento);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      body: SafeArea(
        child: ListView(
          children: [
            // ANÚNCIOS
            Container(
              color: const Color(0xFFFFF3DC),
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ESPAÇO DE ANÚNCIO',
                    style: TextStyle(
                      color: Color(0xFF8E6420),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Destaques patrocinados',
                    style: TextStyle(
                      color: AppTheme.brown,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Anúncios aparecem aqui e não '
                        'alteram a ordem da busca.',
                  ),

                  const SizedBox(height: 20),

                  _card(
                    context,
                    1,
                    patrocinado: true,
                  ),

                  _card(
                    context,
                    2,
                    patrocinado: true,
                  ),
                ],
              ),
            ),

            // ESTABELECIMENTOS PRÓXIMOS
            Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'RESULTADOS DA SUA REGIÃO',
                    style: TextStyle(
                      color: AppTheme.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Encontre quem está perto',
                    style: TextStyle(
                      color: AppTheme.brown,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Explore estabelecimentos e '
                        'serviços da sua região.',
                  ),

                  const SizedBox(height: 20),

                  _card(context, 4),

                  _card(context, 3),
                ],
              ),
            ),

            // CONVITE AOS COMERCIANTES
            Container(
              color: const Color(0xFFF4E3D7),
              padding: const EdgeInsets.all(24),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Seu negócio também pode ficar '
                        'mais fácil de encontrar.',
                    style: TextStyle(
                      color: AppTheme.brown,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Divulgue seus produtos e serviços '
                        'para pessoas da sua região.',
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Cadastro de negócios será '
                                'implementado futuramente.',
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Cadastrar negócio',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
