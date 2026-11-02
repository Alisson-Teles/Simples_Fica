import 'package:flutter/material.dart';

import '../../state/app_scope.dart';
import '../../theme/app_theme.dart';

class AdvertisingView extends StatelessWidget {
  final int negocioId;

  const AdvertisingView({super.key, required this.negocioId});

  @override
  Widget build(BuildContext context) {
    final sessao = AppScope.of(context);
    final negocio = sessao.negocioPorId(negocioId);
    final previa = sessao.anuncioEmPrevia(negocioId);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Anúncios (demo)')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        const Text('Espaço de anúncio',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text('Os anúncios patrocinados são separados dos resultados '
            'orgânicos. Esta tela não publica anúncios.'),
        const SizedBox(height: 18),
        Card(color: const Color(0xFFFFF3DC),
          child: Padding(padding: const EdgeInsets.all(18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('PRÉVIA NÃO PUBLICADA',
                    style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                const Icon(Icons.campaign_outlined, size: 48, color: AppTheme.primary),
                const SizedBox(height: 12),
                Text(negocio?.nome ?? 'Negócio indisponível',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(negocio?.descricao ?? ''),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Prévia habilitada na sessão'),
          subtitle: const Text('Não representa anúncio ativo na plataforma.'),
          value: previa,
          onChanged: negocio == null ? null : (_) =>
              sessao.alternarPreviaAnuncio(negocioId),
        ),
        const SizedBox(height: 12),
        const Text('Na integração real, a criação de anúncios dependerá '
            'de regras comerciais, aprovação e cobrança no backend.'),
      ]),
    );
  }
}