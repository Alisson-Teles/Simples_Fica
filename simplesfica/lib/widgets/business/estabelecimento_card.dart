
import 'package:flutter/material.dart';

import '../../data/detalhes_mock.dart';
import '../../models/detalhes_estabelecimento.dart';
import '../../models/estabelecimento.dart';
import '../../state/app_scope.dart';
import '../../theme/app_theme.dart';

class EstabelecimentoCard extends StatelessWidget {
  final Estabelecimento estabelecimento;
  final bool patrocinado;
  final VoidCallback onTap;

  const EstabelecimentoCard({
    super.key,
    required this.estabelecimento,
    required this.onTap,
    this.patrocinado = false,
  });

  @override
  Widget build(BuildContext context) {
    final detalhes = detalhesMock[estabelecimento.id];

    final tipo = detalhes?.tipoAtuacao ??
        TipoAtuacao.semOfertas;

    final sessao = AppScope.of(context);

    final favorito = sessao.isFavorite(
      estabelecimento.id,
    );

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),

        side: BorderSide(
          color: patrocinado
              ? const Color(0xFFE4C98F)
              : const Color(0xFFEAD7CC),
        ),
      ),

      child: InkWell(
        onTap: onTap,

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              if (patrocinado)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),

                  child: Text(
                    'ANÚNCIO',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,

                    decoration: BoxDecoration(
                      color: const Color(0xFFF4E3D7),
                      borderRadius:
                      BorderRadius.circular(12),
                    ),

                    child: const Icon(
                      Icons.storefront,
                      color: AppTheme.primary,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [
                        Text(
                          estabelecimento.nome,
                          style: const TextStyle(
                            color: AppTheme.brown,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          estabelecimento.descricao,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // BOTÃO DE FAVORITOS
                  IconButton(
                    tooltip: favorito
                        ? 'Remover dos favoritos'
                        : 'Adicionar aos favoritos',

                    onPressed: () {
                      sessao.toggleFavorite(
                        estabelecimento.id,
                      );
                    },

                    icon: Icon(
                      favorito
                          ? Icons.favorite
                          : Icons.favorite_border,

                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 6,

                children: [
                  Chip(
                    visualDensity:
                    VisualDensity.compact,
                    label: Text(tipo.rotulo),
                  ),

                  Chip(
                    visualDensity:
                    VisualDensity.compact,

                    label: Text(
                      estabelecimento.aberto
                          ? 'Aberto (demo)'
                          : 'Fechado (demo)',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 18,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    estabelecimento.avaliacao
                        .toStringAsFixed(1),
                  ),

                  const Spacer(),

                  Text(
                    '${estabelecimento.distanciaKm.toStringAsFixed(1)} km',
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Text(
                '${estabelecimento.bairro}, '
                    '${estabelecimento.cidade}',

                style: const TextStyle(
                  color: Color(0xFF78645C),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
