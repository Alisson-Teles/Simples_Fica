import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class SubscriptionView extends StatefulWidget {
  final String nomeNegocio;

  const SubscriptionView({super.key, required this.nomeNegocio});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  String? _planoSimulado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Assinatura (demo)')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Text(widget.nomeNegocio,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        const Card(child: ListTile(
          leading: Icon(Icons.info_outline, color: AppTheme.primary),
          title: Text('Nenhuma assinatura real'),
          subtitle: Text('Não há cobrança, pagamento ou ativação de plano.'),
        )),
        const SizedBox(height: 18),
        const Text('Escolha uma opção apenas para visualizar a seleção:'),
        const SizedBox(height: 12),
        for (final nome in ['Básico', 'Profissional'])
          Card(color: Colors.white, child: ListTile(
            leading: Icon(
              _planoSimulado == nome
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: AppTheme.primary,
            ),
            title: Text(nome),
            subtitle: const Text('Recursos e valores serão definidos futuramente.'),
            onTap: () => setState(() => _planoSimulado = nome),
          )),
        const SizedBox(height: 16),
        Text('Seleção local: ${_planoSimulado ?? 'Nenhuma'}'),
        const SizedBox(height: 10),
        const Text('Nenhuma assinatura será contratada ou renovada.'),
      ]),
    );
  }
}