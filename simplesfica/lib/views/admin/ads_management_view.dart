
import 'package:flutter/material.dart';

import '../../models/admin_demo_models.dart';
import '../../state/admin_demo_state.dart';
import '../../theme/app_theme.dart';

class AdsManagementView extends StatefulWidget {
  final AdminDemoState estado;

  const AdsManagementView({
    super.key,
    required this.estado,
  });

  @override
  State<AdsManagementView> createState() =>
      _AdsManagementViewState();
}

class _AdsManagementViewState
    extends State<AdsManagementView> {
  final _buscaController = TextEditingController();

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _alternar(AnuncioAdminDemo anuncio) async {
    final novo = anuncio.status ==
        StatusAnuncioAdmin.ativo
        ? StatusAnuncioAdmin.pausado
        : StatusAnuncioAdmin.ativo;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Alterar anúncio de teste?'),
        content: Text(
          '${anuncio.titulo}\n\n'
              'Nova situação: ${novo.name}.\n'
              'A visibilidade pública continuará '
              'dependendo da situação do estabelecimento.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (!mounted || confirmar != true) return;

    widget.estado.alterarStatusAnuncio(
      anuncio.id,
      novo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.estado,
      builder: (context, _) {
        final busca =
        _buscaController.text.toLowerCase().trim();

        final anuncios = widget.estado.anuncios.where(
              (a) {
            final negocio =
            widget.estado.negocioPorId(a.negocioId);

            return a.titulo.toLowerCase().contains(busca) ||
                (negocio?.nome.toLowerCase().contains(busca) ??
                    false);
          },
        ).toList();

        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            title: const Text('Publicidade (demo)'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: const Color(0xFFFFF3DC),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    'Anúncios elegíveis para exibição: '
                        '${widget.estado.anunciosAtivos}\n'
                        'Um estabelecimento suspenso ou '
                        'não publicado nunca será '
                        'anunciado publicamente.',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _buscaController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  labelText: 'Pesquisar anúncios',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              if (anuncios.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Text('Nenhum anúncio encontrado.'),
                  ),
                ),
              ...anuncios.map((a) {
                final negocio =
                widget.estado.negocioPorId(a.negocioId);

                final elegivel =
                    a.status == StatusAnuncioAdmin.ativo &&
                        widget.estado.negocioVisivel(a.negocioId);

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PUBLICIDADE DEMONSTRATIVA',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          a.titulo,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          negocio?.nome ??
                              'Estabelecimento indisponível',
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: [
                            Chip(
                              label: Text(
                                'Campanha: ${a.status.name}',
                              ),
                            ),
                            Chip(
                              label: Text(
                                elegivel
                                    ? 'Pode ser exibido'
                                    : 'Não exibido publicamente',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: () => _alternar(a),
                          icon: Icon(
                            a.status == StatusAnuncioAdmin.ativo
                                ? Icons.pause_circle_outline
                                : Icons.play_circle_outline,
                          ),
                          label: Text(
                            a.status == StatusAnuncioAdmin.ativo
                                ? 'Pausar (teste)'
                                : 'Habilitar (teste)',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
