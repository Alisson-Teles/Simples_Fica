
import 'package:flutter/material.dart';

import '../../models/admin_demo_models.dart';
import '../../state/admin_demo_state.dart';
import '../../theme/app_theme.dart';

class ReportsView extends StatefulWidget {
  final AdminDemoState estado;

  const ReportsView({
    super.key,
    required this.estado,
  });

  @override
  State<ReportsView> createState() =>
      _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  String _filtro = 'todos';

  String _rotulo(StatusDenunciaAdmin status) {
    switch (status) {
      case StatusDenunciaAdmin.pendente:
        return 'Pendente';

      case StatusDenunciaAdmin.analisada:
        return 'Analisada';

      case StatusDenunciaAdmin.arquivada:
        return 'Arquivada';
    }
  }

  Future<void> _alterarDenuncia(
      DenunciaAdminDemo denuncia,
      StatusDenunciaAdmin novoStatus,
      ) async {
    final confirmar = await showDialog<bool>(
      context: context,

      builder: (dialogContext) => AlertDialog(
        title: const Text(
          'Atualizar denúncia de teste?',
        ),

        content: Text(
          'Alterar a denúncia #${denuncia.id} '
              'para "${_rotulo(novoStatus)}"?\n\n'
              'Nenhuma avaliação real '
              'será modificada ou removida.',
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(false);
            },
            child: const Text('Cancelar'),
          ),

          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
            },
            child: const Text('Confirmar teste'),
          ),
        ],
      ),
    );

    if (!mounted || confirmar != true) return;

    widget.estado.alterarStatusDenuncia(
      denuncia.id,
      novoStatus,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Denúncia de teste atualizada '
              'na auditoria local.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.estado,

      builder: (context, _) {
        final denuncias =
        widget.estado.denuncias.where(
              (denuncia) {
            return _filtro == 'todos' ||
                denuncia.status.name == _filtro;
          },
        ).toList();

        return Scaffold(
          backgroundColor: AppTheme.background,

          appBar: AppBar(
            title: const Text('Denúncias (demo)'),
          ),

          body: ListView(
            padding: const EdgeInsets.all(16),

            children: [
              const Card(
                color: Color(0xFFFFF3DC),

                child: Padding(
                  padding: EdgeInsets.all(14),

                  child: Text(
                    'Todas as denúncias e avaliações '
                        'desta tela são fictícias. '
                        'As ações de moderação '
                        'não afetam conteúdo público.',
                  ),
                ),
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _filtro,

                decoration: const InputDecoration(
                  labelText: 'Filtrar denúncias',
                  border: OutlineInputBorder(),
                ),

                items: const [
                  DropdownMenuItem(
                    value: 'todos',
                    child: Text('Todas'),
                  ),

                  DropdownMenuItem(
                    value: 'pendente',
                    child: Text('Pendentes'),
                  ),

                  DropdownMenuItem(
                    value: 'analisada',
                    child: Text('Analisadas'),
                  ),

                  DropdownMenuItem(
                    value: 'arquivada',
                    child: Text('Arquivadas'),
                  ),
                ],

                onChanged: (valor) {
                  setState(() {
                    _filtro = valor ?? 'todos';
                  });
                },
              ),

              const SizedBox(height: 14),

              Text(
                '${denuncias.length} denúncia(s) '
                    'encontrada(s)',
              ),

              const SizedBox(height: 12),

              if (denuncias.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),

                    child: Text(
                      'Nenhuma denúncia neste filtro.',
                    ),
                  ),
                ),

              ...denuncias.map((denuncia) {
                final negocio = widget.estado
                    .negocioPorId(denuncia.negocioId);

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(
                    bottom: 12,
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [
                        Text(
                          'Denúncia #${denuncia.id}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          negocio?.nome ??
                              'Negócio indisponível',
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Motivo: ${denuncia.motivo}',
                        ),

                        const SizedBox(height: 6),

                        Text(denuncia.comentario),

                        const SizedBox(height: 10),

                        Chip(
                          label: Text(
                            '${_rotulo(denuncia.status)} (demo)',
                          ),
                        ),

                        const SizedBox(height: 10),

                        Wrap(
                          spacing: 8,
                          runSpacing: 6,

                          children: [
                            OutlinedButton.icon(
                              onPressed: denuncia.status ==
                                  StatusDenunciaAdmin.analisada
                                  ? null
                                  : () => _alterarDenuncia(
                                denuncia,
                                StatusDenunciaAdmin.analisada,
                              ),

                              icon: const Icon(
                                Icons.fact_check_outlined,
                              ),

                              label: const Text(
                                'Marcar analisada',
                              ),
                            ),

                            OutlinedButton.icon(
                              onPressed: denuncia.status ==
                                  StatusDenunciaAdmin.arquivada
                                  ? null
                                  : () => _alterarDenuncia(
                                denuncia,
                                StatusDenunciaAdmin.arquivada,
                              ),

                              icon: const Icon(
                                Icons.archive_outlined,
                              ),

                              label: const Text(
                                'Arquivar (teste)',
                              ),
                            ),
                          ],
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
