
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common/app_feedback.dart';

class _PerguntaAjuda {
  final String perfil;
  final String pergunta;
  final String resposta;

  const _PerguntaAjuda({
    required this.perfil,
    required this.pergunta,
    required this.resposta,
  });
}

class HelpView extends StatefulWidget {
  const HelpView({super.key});

  @override
  State<HelpView> createState() => _HelpViewState();
}

class _HelpViewState extends State<HelpView> {
  final _buscaController = TextEditingController();

  String _perfil = 'Todos';

  static const List<_PerguntaAjuda> _perguntas = [
    _PerguntaAjuda(
      perfil: 'Cliente',
      pergunta: 'Como encontro negócios próximos?',
      resposta: 'Abra Explorar e utilize a pesquisa '
          'ou os filtros de cidade, categoria e '
          'tipo de atuação. As distâncias atuais '
          'são demonstrativas.',
    ),
    _PerguntaAjuda(
      perfil: 'Cliente',
      pergunta: 'Como salvo meus favoritos?',
      resposta: 'Toque no coração de um '
          'estabelecimento disponível. '
          'A lista pertence à conta de teste '
          'utilizada naquele momento.',
    ),
    _PerguntaAjuda(
      perfil: 'Cliente',
      pergunta: 'O que acontece com um favorito suspenso?',
      resposta: 'Ele não aparece mais na busca '
          'pública, mas continua salvo na lista '
          'de favoritos como indisponível. '
          'Se for reativado, volta a permitir consulta.',
    ),
    _PerguntaAjuda(
      perfil: 'Cliente',
      pergunta: 'Como funcionam os anúncios?',
      resposta: 'Destaques patrocinados aparecem '
          'identificados. Eles são separados '
          'da classificação orgânica em Explorar.',
    ),
    _PerguntaAjuda(
      perfil: 'Comerciante',
      pergunta: 'Como cadastro meu estabelecimento?',
      resposta: 'Entre com o perfil Comerciante, '
          'abra Perfil e escolha Meus negócios. '
          'Ali é possível criar um cadastro de teste.',
    ),
    _PerguntaAjuda(
      perfil: 'Comerciante',
      pergunta: 'Meu negócio aparece imediatamente?',
      resposta: 'Não. O cadastro começa sem '
          'publicação. Na demonstração, o '
          'Administrador precisa aprová-lo.',
    ),
    _PerguntaAjuda(
      perfil: 'Comerciante',
      pergunta: 'Como são calculadas as vendas?',
      resposta: 'As vendas demonstrativas '
          'somam quantidades e valores. '
          'Produtos precisam de estoque suficiente. '
          'Não existe pagamento real.',
    ),
    _PerguntaAjuda(
      perfil: 'Administrador',
      pergunta: 'Como suspendo um estabelecimento?',
      resposta: 'Abra o painel administrativo, '
          'acesse Estabelecimentos e confirme '
          'a suspensão de teste. O negócio deixa '
          'de aparecer publicamente na sessão.',
    ),
    _PerguntaAjuda(
      perfil: 'Administrador',
      pergunta: 'Como publico um negócio?',
      resposta: 'O estabelecimento precisa estar '
          'ativo e ter pelo menos uma oferta ativa. '
          'Depois, utilize a opção Publicar (teste).',
    ),
    _PerguntaAjuda(
      perfil: 'Administrador',
      pergunta: 'Como consulto uma alteração?',
      resposta: 'Abra Auditoria no painel '
          'administrativo. O histórico de teste '
          'registra mudanças durante a execução.',
    ),
    _PerguntaAjuda(
      perfil: 'Todos',
      pergunta: 'Por que meus dados somem ao reiniciar?',
      resposta: 'Esta versão utiliza armazenamento '
          'em memória. É possível trocar de perfil '
          'sem perder os favoritos daquela conta, '
          'mas reiniciar o aplicativo descarta '
          'os dados demonstrativos.',
    ),
    _PerguntaAjuda(
      perfil: 'Todos',
      pergunta: 'Posso usar uma conta real?',
      resposta: 'Ainda não. As credenciais '
          'disponíveis são fictícias. O cadastro '
          'real dependerá da API e da autenticação '
          'segura no servidor.',
    ),
  ];

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pesquisa =
    _buscaController.text.trim().toLowerCase();

    final resultados = _perguntas.where((item) {
      final correspondePerfil =
          _perfil == 'Todos' ||
              item.perfil == _perfil ||
              item.perfil == 'Todos';

      final correspondePesquisa =
          item.pergunta.toLowerCase().contains(pesquisa) ||
              item.resposta.toLowerCase().contains(pesquisa);

      return correspondePerfil && correspondePesquisa;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Central de ajuda'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Como podemos ajudar?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.brown,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Encontre respostas sobre as '
                  'funcionalidades desta demonstração.',
            ),
            const SizedBox(height: 18),

            TextField(
              controller: _buscaController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Pesquisar uma dúvida',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final perfil in const [
                    'Todos',
                    'Cliente',
                    'Comerciante',
                    'Administrador',
                  ])
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 8,
                      ),
                      child: ChoiceChip(
                        label: Text(perfil),
                        selected: _perfil == perfil,
                        onSelected: (_) {
                          setState(() {
                            _perfil = perfil;
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Text(
              '${resultados.length} resposta(s) encontrada(s)',
            ),

            const SizedBox(height: 12),

            if (resultados.isEmpty)
              AppEmptyState(
                titulo: 'Nenhuma dúvida encontrada',
                mensagem: 'Experimente outros termos '
                    'ou selecione Todos.',
                icone: Icons.help_outline,
                textoBotao: 'Limpar pesquisa',
                onPressed: () {
                  setState(() {
                    _buscaController.clear();
                    _perfil = 'Todos';
                  });
                },
              )
            else
              ...resultados.map(
                    (item) => Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(
                    bottom: 8,
                  ),
                  child: ExpansionTile(
                    title: Text(item.pergunta),
                    subtitle: Text(item.perfil),
                    childrenPadding: const EdgeInsets.all(16),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(item.resposta),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            const Text(
              'Esta central reúne orientações '
                  'sobre o protótipo. Ainda não há '
                  'atendimento externo integrado.',
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
