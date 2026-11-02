
import 'package:flutter/material.dart';

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

    final favoritos = sessao.favoritos
        .map(sessao.estabelecimentoPorId)
        .whereType<dynamic>()
        .toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Favoritos'),
        automaticallyImplyLeading: false,
      ),
      body: favoritos.isEmpty
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
              const SizedBox(height: 16),
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
            '${favoritos.length} estabelecimento(s) salvo(s)',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...favoritos.map((e) {
            final disponivel =
            sessao.negocioDisponivelPublicamente(
              e.id,
            );

            if (disponivel) {
              return EstabelecimentoCard(
                estabelecimento: e,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BusinessDetailView(
                        estabelecimento: e,
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
                title: Text(e.nome),
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
                    sessao.removerFavorito(e.id);
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
