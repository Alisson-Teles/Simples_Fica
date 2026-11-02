
import 'package:flutter/material.dart';

import '../../state/admin_demo_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatacao.dart';

class AuditLogsView extends StatefulWidget {
  final AdminDemoState estado;

  const AuditLogsView({
    super.key,
    required this.estado,
  });

  @override
  State<AuditLogsView> createState() =>
      _AuditLogsViewState();
}

class _AuditLogsViewState extends State<AuditLogsView> {
  final _buscaController = TextEditingController();

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.estado,

      builder: (context, _) {
        final termo =
        _buscaController.text.trim().toLowerCase();

        final registros = widget.estado.auditoria.where(
              (registro) {
            return registro.acao
                .toLowerCase()
                .contains(termo) ||
                registro.entidade
                    .toLowerCase()
                    .contains(termo);
          },
        ).toList();

        return Scaffold(
          backgroundColor: AppTheme.background,

          appBar: AppBar(
            title: const Text('Auditoria (demo)'),
          ),

          body: ListView(
            padding: const EdgeInsets.all(16),

            children: [
              const Card(
                color: Color(0xFFFFF3DC),

                child: Padding(
                  padding: EdgeInsets.all(14),

                  child: Text(
                    'REGISTROS FICTÍCIOS\n'
                        'As alterações realizadas no '
                        'painel são registradas apenas '
                        'enquanto a demonstração '
                        'estiver aberta.',
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _buscaController,

                decoration: const InputDecoration(
                  labelText: 'Pesquisar auditoria',
                  hintText: 'Ação ou entidade',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),

                onChanged: (_) {
                  setState(() {});
                },
              ),

              const SizedBox(height: 14),

              Text(
                '${registros.length} registro(s)',
              ),

              const SizedBox(height: 12),

              if (registros.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),

                    child: Text(
                      'Nenhum registro encontrado.',
                    ),
                  ),
                ),

              ...registros.map(
                    (registro) => Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(
                    bottom: 10,
                  ),

                  child: ListTile(
                    leading: const Icon(
                      Icons.history_outlined,
                      color: AppTheme.primary,
                    ),

                    title: Text(registro.acao),

                    subtitle: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [
                        const SizedBox(height: 4),

                        Text(registro.entidade),

                        const SizedBox(height: 4),

                        Text(
                          formatarData(registro.data),
                        ),
                      ],
                    ),

                    trailing: Text(
                      '#${registro.id}',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Esta auditoria não é persistente '
                    'nem protegida contra alterações '
                    'externas. Uma trilha real de '
                    'auditoria deve ser implementada '
                    'no backend.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF78645C),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
