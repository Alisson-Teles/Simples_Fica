
import 'package:flutter/material.dart';

import '../../state/admin_business_metrics.dart';
import '../../state/admin_demo_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatacao.dart';

import 'ads_management_view.dart';
import 'audit_logs_view.dart';
import 'business_management_view.dart';
import 'financial_overview_view.dart';
import 'reports_view.dart';
import 'users_management_view.dart';

// Modelo visual de um cartão do Dashboard.
class _IndicadorPainel {
  final String titulo;
  final String valor;
  final IconData icone;
  final Widget destino;

  const _IndicadorPainel({
    required this.titulo,
    required this.valor,
    required this.icone,
    required this.destino,
  });
}

class AdminDashboardView extends StatelessWidget {
  final AdminDemoState estado;

  const AdminDashboardView({
    super.key,
    required this.estado,
  });

  void _abrir(BuildContext context, Widget pagina) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => pagina,
      ),
    );
  }

  // ==========================================
  // CARTÕES INTERATIVOS
  // ==========================================

  Widget _indicador(
      BuildContext context,
      _IndicadorPainel indicador,
      double largura,
      ) {
    return SizedBox(
      width: largura,
      child: Card(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _abrir(
            context,
            indicador.destino,
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      indicador.icone,
                      color: AppTheme.primary,
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  indicador.valor,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brown,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  indicador.titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ver detalhes',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Grade responsiva para os indicadores.
  Widget _grade(
      BuildContext context,
      List<_IndicadorPainel> indicadores,
      ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final colunas =
        constraints.maxWidth >= 900
            ? 4
            : constraints.maxWidth >= 600
            ? 3
            : 2;

        const espaco = 8.0;

        final largura = (
            constraints.maxWidth -
                (colunas - 1) * espaco
        ) / colunas;

        return Wrap(
          spacing: espaco,
          runSpacing: espaco,
          children: indicadores.map((indicador) {
            return _indicador(
              context,
              indicador,
              largura,
            );
          }).toList(),
        );
      },
    );
  }

  Widget _tituloSecao(String texto) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 22,
        bottom: 12,
      ),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.bold,
          color: AppTheme.brown,
        ),
      ),
    );
  }

  // ==========================================
  // INDICADORES DE PESSOAS
  // ==========================================

  List<_IndicadorPainel> _indicadoresPessoas() {
    return [
      _IndicadorPainel(
        titulo: 'Clientes',
        valor: '${estado.clientes}',
        icone: Icons.people_outline,
        destino: UsersManagementView(
          estado: estado,
          perfilInicial: 'Cliente',
        ),
      ),
      _IndicadorPainel(
        titulo: 'Clientes ativos',
        valor: '${estado.clientesAtivos}',
        icone: Icons.person_outline,
        destino: UsersManagementView(
          estado: estado,
          perfilInicial: 'Cliente',
          filtroStatusInicial: 'ativo',
        ),
      ),
      _IndicadorPainel(
        titulo: 'Clientes inativos',
        valor: '${estado.clientesInativos}',
        icone: Icons.person_off_outlined,
        destino: UsersManagementView(
          estado: estado,
          perfilInicial: 'Cliente',
          filtroStatusInicial: 'inativos',
        ),
      ),
      _IndicadorPainel(
        titulo: 'Contas de comerciante',
        valor: '${estado.comerciantes}',
        icone: Icons.manage_accounts_outlined,
        destino: UsersManagementView(
          estado: estado,
          perfilInicial: 'Comerciante',
        ),
      ),
    ];
  }

  // ==========================================
  // INDICADORES DE ESTABELECIMENTOS
  // ==========================================

  List<_IndicadorPainel> _indicadoresNegocios() {
    return [
      _IndicadorPainel(
        titulo: 'Comerciantes / Prestadores',
        valor: '${estado.totalComerciantesPrestadores}',
        icone: Icons.storefront_outlined,
        destino: BusinessManagementView(
          estado: estado,
          filtroAtuacaoInicial:
          FiltroAtuacaoAdmin.comAtuacao,
        ),
      ),
      _IndicadorPainel(
        titulo: 'Somente comerciantes',
        valor: '${estado.somenteComerciantes}',
        icone: Icons.shopping_bag_outlined,
        destino: BusinessManagementView(
          estado: estado,
          filtroAtuacaoInicial:
          FiltroAtuacaoAdmin.somenteComerciantes,
        ),
      ),
      _IndicadorPainel(
        titulo: 'Somente prestadores',
        valor: '${estado.somentePrestadores}',
        icone: Icons.handyman_outlined,
        destino: BusinessManagementView(
          estado: estado,
          filtroAtuacaoInicial:
          FiltroAtuacaoAdmin.somentePrestadores,
        ),
      ),
      _IndicadorPainel(
        titulo: 'Ambos',
        valor: '${estado.comerciantesEPrestadores}',
        icone: Icons.layers_outlined,
        destino: BusinessManagementView(
          estado: estado,
          filtroAtuacaoInicial:
          FiltroAtuacaoAdmin.ambos,
        ),
      ),
      _IndicadorPainel(
        titulo: 'Negócios ativos',
        valor: '${estado.negociosAtivos}',
        icone: Icons.check_circle_outline,
        destino: BusinessManagementView(
          estado: estado,
          filtroStatusInicial: 'ativo',
        ),
      ),
      _IndicadorPainel(
        titulo: 'Suspensos',
        valor: '${estado.negociosSuspensos}',
        icone: Icons.block_outlined,
        destino: BusinessManagementView(
          estado: estado,
          filtroStatusInicial: 'suspenso',
        ),
      ),
    ];
  }

  // ==========================================
  // INDICADORES OPERACIONAIS
  // ==========================================

  List<_IndicadorPainel> _indicadoresOperacao() {
    return [
      _IndicadorPainel(
        titulo: 'Inadimplentes',
        valor: '${estado.inadimplentes}',
        icone: Icons.warning_amber_outlined,
        destino: FinancialOverviewView(
          estado: estado,
        ),
      ),
      _IndicadorPainel(
        titulo: 'Receita aprovada (demo)',
        valor: formatarMoeda(
          estado.receitaAprovada,
        ),
        icone: Icons.payments_outlined,
        destino: FinancialOverviewView(
          estado: estado,
        ),
      ),
      _IndicadorPainel(
        titulo: 'Anúncios ativos',
        valor: '${estado.anunciosAtivos}',
        icone: Icons.campaign_outlined,
        destino: AdsManagementView(
          estado: estado,
        ),
      ),
      _IndicadorPainel(
        titulo: 'Denúncias pendentes',
        valor: '${estado.denunciasPendentes}',
        icone: Icons.flag_outlined,
        destino: ReportsView(
          estado: estado,
        ),
      ),
    ];
  }

  // ==========================================
  // GRÁFICO DOS ÚLTIMOS 14 DIAS
  // ==========================================

  Widget _graficoAtividade() {
    final atividades = estado.atividade;

    final maior = atividades.fold<int>(
      1,
          (atual, dia) =>
      dia.total > atual ? dia.total : atual,
    );

    final contatos = atividades.fold<int>(
      0,
          (total, dia) => total + dia.contatos,
    );

    final rotas = atividades.fold<int>(
      0,
          (total, dia) => total + dia.rotas,
    );

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Text(
              'Atividade dos últimos 14 dias',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Visualizações, contatos e rotas '
                  'fictícios.',
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 155,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: atividades.map((dia) {
                  final altura =
                      (dia.total / maior) * 105;

                  return SizedBox(
                    width: 34,
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.end,
                      children: [
                        Text(
                          '${dia.total}',
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 19,
                          height: altura,
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius:
                            BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          dia.data,
                          style: const TextStyle(
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Contatos: $contatos  •  Rotas: $rotas',
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // ATALHOS DE GERENCIAMENTO
  // ==========================================

  Widget _atalho(
      BuildContext context,
      String titulo,
      String descricao,
      IconData icone,
      Widget destino,
      ) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(
          icone,
          color: AppTheme.primary,
        ),
        title: Text(titulo),
        subtitle: Text(descricao),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _abrir(context, destino),
      ),
    );
  }

  // ==========================================
  // TELA PRINCIPAL
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: estado,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            title: const Text('Administração geral'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Painel do proprietário',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brown,
                ),
              ),
              const SizedBox(height: 10),
              const Card(
                color: Color(0xFFFFF3DC),
                child: Padding(
                  padding: EdgeInsets.all(14),
                  child: Text(
                    'MODO DEMONSTRAÇÃO: as contagens, '
                        'situações e alterações são '
                        'fictícias e locais.',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Toque em qualquer indicador '
                    'para abrir a listagem.',
              ),

              // PESSOAS
              _tituloSecao('Pessoas'),
              _grade(
                context,
                _indicadoresPessoas(),
              ),

              // ESTABELECIMENTOS
              _tituloSecao('Estabelecimentos'),
              _grade(
                context,
                _indicadoresNegocios(),
              ),

              // INFORMAÇÕES OPERACIONAIS
              _tituloSecao('Operação'),
              _grade(
                context,
                _indicadoresOperacao(),
              ),

              const SizedBox(height: 24),
              _graficoAtividade(),

              // ATALHOS COMPLETOS
              _tituloSecao('Gerenciamento'),

              _atalho(
                context,
                'Estabelecimentos',
                'Consultar, filtrar e simular situações',
                Icons.storefront_outlined,
                BusinessManagementView(
                  estado: estado,
                ),
              ),
              _atalho(
                context,
                'Usuários',
                'Pesquisar e consultar perfis',
                Icons.manage_accounts_outlined,
                UsersManagementView(
                  estado: estado,
                ),
              ),
              _atalho(
                context,
                'Financeiro',
                'Consultar pagamentos fictícios',
                Icons.account_balance_wallet_outlined,
                FinancialOverviewView(
                  estado: estado,
                ),
              ),
              _atalho(
                context,
                'Publicidade',
                'Consultar anúncios demonstrativos',
                Icons.campaign_outlined,
                AdsManagementView(
                  estado: estado,
                ),
              ),
              _atalho(
                context,
                'Auditoria',
                'Consultar alterações simuladas',
                Icons.history_outlined,
                AuditLogsView(
                  estado: estado,
                ),
              ),
              _atalho(
                context,
                'Denúncias e relatórios',
                'Consultar avaliações denunciadas',
                Icons.flag_outlined,
                ReportsView(
                  estado: estado,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
