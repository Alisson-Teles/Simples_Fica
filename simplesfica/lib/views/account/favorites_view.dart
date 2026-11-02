
import 'package:flutter/material.dart';

import '../../data/estabelecimentos_mock.dart';
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

  @override
  Widget build(BuildContext context) {
    final sessao = AppScope.of(context);

    final favoritos = estabelecimentosMock.where((e) {
      return sessao.isFavorite(e.id);
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text(
          'Favoritos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),

      body: favoritos.isEmpty
          ? _estadoVazio()
          : ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            '${favoritos.length} '
                '${favoritos.length == 1 ? 'estabelecimento salvo' : 'estabelecimentos salvos'}',
            style: const TextStyle(
              color: AppTheme.brown,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 18),

          ...favoritos.map(
                (estabelecimento) => EstabelecimentoCard(
              estabelecimento: estabelecimento,
              onTap: () {
                _abrirDetalhes(
                  context,
                  estabelecimento,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _estadoVazio() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite_border,
              size: 70,
              color: AppTheme.primary,
            ),

            const SizedBox(height: 20),

            const Text(
              'Nenhum favorito por enquanto',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                color: AppTheme.brown,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Explore estabelecimentos e toque '
                  'no coração para salvar seus favoritos.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: onExplorarPressed,
              icon: const Icon(Icons.search),
              label: const Text(
                'Explorar estabelecimentos',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
