
import 'package:flutter/material.dart';

import '../../data/contas_demo.dart';
import '../../data/estabelecimentos_mock.dart';
import '../../state/app_scope.dart';
import '../../theme/app_theme.dart';

class AdminDemoView extends StatelessWidget {
  const AdminDemoView({super.key});

  Widget _indicador(
      String titulo,
      String valor,
      IconData icone,
      ) {
    return Card(
      color: Colors.white,

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Row(
          children: [
            Icon(
              icone,
              color: AppTheme.primary,
              size: 28,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(titulo),
            ),

            Text(
              valor,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.brown,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _funcaoFutura(
      String titulo,
      IconData icone,
      ) {
    return Card(
      color: Colors.white,

      child: ListTile(
        leading: Icon(
          icone,
          color: AppTheme.primary,
        ),

        title: Text(titulo),

        subtitle: const Text(
          'Previsto para a Etapa 6',
        ),

        trailing: const Icon(
          Icons.lock_outline,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessao = AppScope.of(context);

    if (!sessao.ehAdministrador) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Área administrativa'),
        ),

        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),

            child: Text(
              'Selecione o perfil Administrador '
                  'para testar esta tela.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text(
          'Administração (demo)',
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          const Icon(
            Icons.admin_panel_settings_outlined,
            size: 62,
            color: AppTheme.primary,
          ),

          const SizedBox(height: 16),

          const Text(
            'Painel do Administrador',
            textAlign: TextAlign.center,

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
              padding: EdgeInsets.all(16),

              child: Text(
                'PRÉVIA DEMONSTRATIVA\n'
                    'Nenhuma permissão administrativa '
                    'real foi concedida. '
                    'Os indicadores abaixo utilizam '
                    'apenas dados fictícios locais.',
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Indicadores disponíveis para testes',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _indicador(
            'Estabelecimentos fictícios públicos',
            '${estabelecimentosMock.length}',
            Icons.storefront_outlined,
          ),

          _indicador(
            'Contas predefinidas de teste',
            '${contasDemo.length}',
            Icons.people_outline,
          ),

          _indicador(
            'Negócios criados nesta sessão',
            '${sessao.negocios.length}',
            Icons.business_outlined,
          ),

          const SizedBox(height: 24),

          const Text(
            'Módulos administrativos futuros',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _funcaoFutura(
            'Gerenciar usuários',
            Icons.manage_accounts_outlined,
          ),

          _funcaoFutura(
            'Gerenciar estabelecimentos',
            Icons.store_mall_directory_outlined,
          ),

          _funcaoFutura(
            'Assinaturas e inadimplência',
            Icons.payments_outlined,
          ),

          _funcaoFutura(
            'Publicidade e destaques',
            Icons.campaign_outlined,
          ),

          _funcaoFutura(
            'Auditoria e relatórios',
            Icons.fact_check_outlined,
          ),

          const SizedBox(height: 16),

          const Text(
            'As funcionalidades acima serão '
                'desenvolvidas na Etapa 6. '
                'Esta tela existe para validar '
                'a seleção do perfil administrativo.',
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
