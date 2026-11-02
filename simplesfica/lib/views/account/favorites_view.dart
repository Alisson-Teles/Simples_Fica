
import 'package:flutter/material.dart';

import '../../models/estabelecimento.dart';
import '../../state/app_scope.dart';
import '../../theme/app_theme.dart';
import '../../widgets/business/estabelecimento_card.dart';

import '../public/business_detail_view.dart';

class FavoritesView extends StatelessWidget {
  final VoidCallback onExplorarPressed;

  const FavoritesView({
    super.key,
    required this.onExplorarPressed,
  });

  @override
  Widget build(BuildContext context) {
    final sessao = AppScope.of(context);

    final List<Estabelecimento> favoritos =
    sessao.favoritos
        .map(sessao.estabelecimentoPorId)
        .whereType<Estabelecimento>()
        .toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Favoritos'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: favoritos.isEmpty
            ? Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.favorite_border,
                  size: 64,
                  color: AppTheme.primary,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Nenhum favorito por enquanto',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Explore estabelecimentos '
                      'e toque no coração para salvar.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: onExplorarPressed,
                  icon: const Icon(Icons.search),
                  label: const Text('Explorar'),
                ),
              ],
            ),
          ),
        )
            : ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              '${favoritos.length} '
                  'estabelecimento(s) salvo(s)',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            ...favoritos.map((estabelecimento) {
              final disponivel =
              sessao.negocioDisponivelPublicamente(
                estabelecimento.id,
              );

              if (disponivel) {
                return EstabelecimentoCard(
                  estabelecimento: estabelecimento,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            BusinessDetailView(
                              estabelecimento:
                              estabelecimento,
                            ),
                      ),
                    );
                  },
                );
              }

              return Card(
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(
                    Icons.storefront_outlined,
                    color: AppTheme.primary,
                  ),
                  title: Text(estabelecimento.nome),
                  subtitle: const Text(
                    'Indisponível na plataforma '
                        'neste momento.',
                  ),
                  trailing: IconButton(
                    tooltip: 'Remover favorito',
                    icon: const Icon(
                      Icons.favorite,
                      color: AppTheme.primary,
                    ),
                    onPressed: () {
                      sessao.removerFavorito(
                        estabelecimento.id,
                      );
                    },
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
