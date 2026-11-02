
import 'package:flutter/material.dart';

import '../../models/tipo_conta.dart';
import '../../theme/app_theme.dart';

import 'register_view.dart';

class AccountTypeView extends StatelessWidget {
  const AccountTypeView({super.key});

  void _selecionarTipo(
      BuildContext context,
      TipoConta tipo,
      ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegisterView(
          tipoConta: tipo,
        ),
      ),
    );
  }

  Widget _opcaoConta({
    required BuildContext context,
    required TipoConta tipo,
    required IconData icone,
  }) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 14),

      child: InkWell(
        borderRadius: BorderRadius.circular(12),

        onTap: () {
          _selecionarTipo(context, tipo);
        },

        child: Padding(
          padding: const EdgeInsets.all(18),

          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,

                decoration: BoxDecoration(
                  color: const Color(0xFFF4E3D7),
                  borderRadius:
                  BorderRadius.circular(12),
                ),

                child: Icon(
                  icone,
                  size: 30,
                  color: AppTheme.primary,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    Text(
                      tipo.titulo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.brown,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(tipo.descricao),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right,
                color: AppTheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text('Tipo de conta'),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),

          children: [
            const SizedBox(height: 12),

            const Text(
              'Como você deseja usar '
                  'o Simples Fica?',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: AppTheme.brown,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Escolha o tipo de conta '
                  'para continuar.',
            ),

            const SizedBox(height: 28),

            _opcaoConta(
              context: context,
              tipo: TipoConta.cliente,
              icone: Icons.person_outline,
            ),

            _opcaoConta(
              context: context,
              tipo: TipoConta.comerciante,
              icone: Icons.storefront_outlined,
            ),

            const SizedBox(height: 16),

            const Text(
              'Esta escolha define o fluxo de '
                  'cadastro demonstrativo. Nenhuma '
                  'permissão de acesso será concedida.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF78645C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
