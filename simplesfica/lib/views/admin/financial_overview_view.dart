
import 'package:flutter/material.dart';

import '../../models/admin_demo_models.dart';
import '../../state/admin_demo_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatacao.dart';

class FinancialOverviewView extends StatefulWidget {
  final AdminDemoState estado;

  const FinancialOverviewView({
    super.key,
    required this.estado,
  });

  @override
  State<FinancialOverviewView> createState() =>
      _FinancialOverviewViewState();
}

class _FinancialOverviewViewState
    extends State<FinancialOverviewView> {
  String _filtro = 'todos';

  String _rotulo(StatusPagamentoAdmin status) {
    switch (status) {
      case StatusPagamentoAdmin.aprovado:
        return 'Aprovado';

      case StatusPagamentoAdmin.pendente:
        return 'Pendente';

      case StatusPagamentoAdmin.vencido:
        return 'Vencido';
    }
  }

  @override
  Widget build(BuildContext context) {
    final pagamentos =
    widget.estado.pagamentos.where(
          (pagamento) {
        return _filtro == 'todos' ||
            pagamento.status.name == _filtro;
      },
    ).toList();

    final pendentes = widget.estado.pagamentos.where(
          (p) => p.status == StatusPagamentoAdmin.pendente,
    ).length;

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text('Financeiro (demo)'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          const Card(
            color: Color(0xFFFFF3DC),

            child: Padding(
              padding: EdgeInsets.all(14),

              child: Text(
                'DADOS FINANCEIROS FICTÍCIOS\n'
                    'Nenhuma cobrança, transferência '
                    'ou aprovação real de pagamento '
                    'é realizada nesta tela.',
              ),
            ),
          ),

          const SizedBox(height: 18),

          Card(
            color: Colors.white,

            child: ListTile(
              leading: const Icon(
                Icons.payments_outlined,
                color: AppTheme.primary,
              ),

              title: const Text(
                'Receita aprovada demonstrativa',
              ),

              subtitle: Text(
                formatarMoeda(
                  widget.estado.receitaAprovada,
                ),

                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brown,
                ),
              ),
            ),
          ),

          Card(
            color: Colors.white,

            child: ListTile(
              leading: const Icon(
                Icons.warning_amber_outlined,
                color: AppTheme.primary,
              ),

              title: const Text(
                'Negócios inadimplentes (demo)',
              ),

              trailing: Text(
                '${widget.estado.inadimplentes}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Card(
            color: Colors.white,

            child: ListTile(
              leading: const Icon(
                Icons.pending_actions_outlined,
                color: AppTheme.primary,
              ),

              title: const Text(
                'Pagamentos pendentes (demo)',
              ),

              trailing: Text(
                '$pendentes',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'Histórico de pagamentos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            initialValue: _filtro,

            decoration: const InputDecoration(
              labelText: 'Filtrar por situação',
              border: OutlineInputBorder(),
            ),

            items: const [
              DropdownMenuItem(
                value: 'todos',
                child: Text('Todos'),
              ),

              DropdownMenuItem(
                value: 'aprovado',
                child: Text('Aprovados'),
              ),

              DropdownMenuItem(
                value: 'pendente',
                child: Text('Pendentes'),
              ),

              DropdownMenuItem(
                value: 'vencido',
                child: Text('Vencidos'),
              ),
            ],

            onChanged: (valor) {
              setState(() {
                _filtro = valor ?? 'todos';
              });
            },
          ),

          const SizedBox(height: 14),

          if (pagamentos.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),

                child: Text(
                  'Nenhum pagamento neste filtro.',
                ),
              ),
            ),

          ...pagamentos.map(
                (pagamento) {
              final negocio = widget.estado
                  .negocioPorId(pagamento.negocioId);

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(
                  bottom: 10,
                ),

                child: ListTile(
                  title: Text(
                    negocio?.nome ??
                        'Negócio não encontrado',
                  ),

                  subtitle: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      Text(pagamento.descricao),

                      const SizedBox(height: 4),

                      Text(
                        '${_rotulo(pagamento.status)} '
                            '(demo)',
                      ),
                    ],
                  ),

                  trailing: Text(
                    formatarMoeda(pagamento.valor),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 14),

          const Text(
            'A situação de pagamento nesta '
                'etapa é somente para consulta. '
                'Valores e assinaturas reais '
                'dependerão da API.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF78645C),
            ),
          ),
        ],
      ),
    );
  }
}
