
import 'package:flutter/material.dart';

import '../../models/estabelecimento.dart';
import '../../state/app_scope.dart';
import '../../theme/app_theme.dart';
import '../../widgets/business/estabelecimento_card.dart';

import 'business_detail_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  void _abrirDetalhes(
      BuildContext context,
      Estabelecimento estabelecimento,
      ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BusinessDetailView(
          estabelecimento: estabelecimento,
        ),
      ),
    );
  }

  Widget _cartao(
      BuildContext context,
      Estabelecimento estabelecimento, {
        bool patrocinado = false,
      }) {
    return EstabelecimentoCard(
      estabelecimento: estabelecimento,
      patrocinado: patrocinado,
      onTap: () => _abrirDetalhes(
        context,
        estabelecimento,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessao = AppScope.of(context);
    final disponiveis = sessao.estabelecimentosPublicos;

    final idsPatrocinados =
    sessao.administracao.negociosPatrocinados.toSet();

    final patrocinados = disponiveis.where(
          (e) => idsPatrocinados.contains(e.id),
    ).toList();

    final organicos = disponiveis.where(
          (e) => !idsPatrocinados.contains(e.id),
    ).toList()
      ..sort(
            (a, b) => a.distanciaKm.compareTo(b.distanciaKm),
      );

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: ListView(
          children: [
            // ANÚNCIOS AUTORIZADOS
            Container(
              color: const Color(0xFFFFF3DC),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ESPAÇO DE ANÚNCIO',
                    style: TextStyle(
                      color: Color(0xFF8E6420),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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
                    'Anúncios demonstrativos não '
                        'alteram a classificação orgânica.',
                  ),
                  const SizedBox(height: 18),
                  if (patrocinados.isEmpty)
                    const Text(
                      'Nenhum anúncio disponível no momento.',
                    )
                  else
                    ...patrocinados.map(
                          (e) => _cartao(
                        context,
                        e,
                        patrocinado: true,
                      ),
                    ),
                ],
              ),
            ),

            // RESULTADOS ORGÂNICOS
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    'RESULTADOS DA SUA REGIÃO',
                    style: TextStyle(
                      color: AppTheme.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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
                  Text(
                    '${disponiveis.length} estabelecimento(s) '
                        'disponível(is) nesta demonstração.',
                  ),

                  const SizedBox(height: 18),
                  if (organicos.isEmpty)
                    const Text(
                      'Nenhum resultado orgânico '
                          'disponível no momento.',
                    )
                  else
                    ...organicos.map(
                          (e) => _cartao(context, e),
                    ),
                ],
              ),
            ),

            // CONVITE AO COMERCIANTE
            Container(
              color: const Color(0xFFF4E3D7),
              padding: const EdgeInsets.all(24),
              child: const Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seu negócio também pode ficar '
                        'mais fácil de encontrar.',
                    style: TextStyle(
                      color: AppTheme.brown,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Cadastre seu negócio no painel '
                        'do Comerciante. Nesta demonstração, '
                        'a publicação depende da aprovação '
                        'no painel administrativo.',
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
