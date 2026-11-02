
import 'package:flutter/material.dart';

import '../../data/detalhes_mock.dart';
import '../../models/estabelecimento.dart';
import '../../models/detalhes_estabelecimento.dart';
import '../../models/oferta.dart';
import '../../theme/app_theme.dart';

class BusinessDetailView extends StatefulWidget {
  final Estabelecimento estabelecimento;

  const BusinessDetailView({
    super.key,
    required this.estabelecimento,
  });

  @override
  State<BusinessDetailView> createState() =>
      _BusinessDetailViewState();
}

class _BusinessDetailViewState
    extends State<BusinessDetailView> {
  bool _favorito = false;
  int _nota = 5;

  final TextEditingController _comentarioController =
  TextEditingController();

  final List<Avaliacao> _avaliacoesLocais = [];

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  void _publicarAvaliacao() {
    final comentario = _comentarioController.text.trim();

    if (comentario.isEmpty) {
      _mostrarMensagem('Digite um comentário.');
      return;
    }

    setState(() {
      _avaliacoesLocais.insert(
        0,
        Avaliacao(
          autor: 'Usuário de teste',
          nota: _nota,
          comentario: comentario,
        ),
      );

      _comentarioController.clear();
    });

    FocusScope.of(context).unfocus();

    _mostrarMensagem(
      'Avaliação adicionada nesta demonstração.',
    );
  }

  String _formatarPreco(double? preco) {
    if (preco == null) {
      return 'Consultar valor';
    }

    return 'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    final estabelecimento = widget.estabelecimento;
    final detalhes = detalhesMock[estabelecimento.id];

    final produtos = detalhes?.produtosAtivos ??
        <Oferta>[];

    final servicos = detalhes?.servicosAtivos ??
        <Oferta>[];

    final tipo = detalhes?.tipoAtuacao ??
        TipoAtuacao.semOfertas;

    final avaliacoes = [
      ..._avaliacoesLocais,
      ...?detalhes?.avaliacoes,
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text('Estabelecimento'),

        actions: [
          IconButton(
            tooltip: 'Favoritar',
            icon: Icon(
              _favorito
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: AppTheme.primary,
            ),
            onPressed: () {
              setState(() {
                _favorito = !_favorito;
              });

              _mostrarMensagem(
                _favorito
                    ? 'Adicionado aos favoritos (teste).'
                    : 'Removido dos favoritos (teste).',
              );
            },
          ),
        ],
      ),

      body: ListView(
        children: [
          // CAPA DO ESTABELECIMENTO
          Container(
            height: 170,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF1D5C5),
                  Color(0xFFE5AD91),
                ],
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.storefront,
                size: 75,
                color: AppTheme.brown,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CLASSIFICAÇÃO
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    Chip(
                      label: Text(
                        estabelecimento.categoria,
                      ),
                    ),

                    Chip(
                      label: Text(tipo.rotulo),
                      backgroundColor:
                      const Color(0xFFF4E3D7),
                    ),

                    Chip(
                      label: Text(
                        estabelecimento.aberto
                            ? 'Aberto (demo)'
                            : 'Fechado (demo)',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // NOME E LOCALIZAÇÃO
                Text(
                  estabelecimento.nome,
                  style: const TextStyle(
                    color: AppTheme.brown,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  '${estabelecimento.bairro}, '
                      '${estabelecimento.cidade} - '
                      '${detalhes?.uf ?? 'GO'}',
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),

                    const SizedBox(width: 5),

                    Text(
                      estabelecimento.avaliacao
                          .toStringAsFixed(1),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        '${estabelecimento.totalAvaliacoes} '
                            'avaliações (demo)',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // BOTÕES DE CONTATO
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _mostrarMensagem(
                          'WhatsApp será integrado futuramente.',
                        );
                      },
                      icon: const Icon(Icons.chat),
                      label: const Text('WhatsApp'),
                    ),

                    OutlinedButton.icon(
                      onPressed: () {
                        _mostrarMensagem(
                          'Telefone: ${estabelecimento.telefone}',
                        );
                      },
                      icon: const Icon(Icons.phone),
                      label: const Text('Ligar'),
                    ),

                    OutlinedButton.icon(
                      onPressed: () {
                        _mostrarMensagem(
                          'Integração com mapas será futura.',
                        );
                      },
                      icon: const Icon(Icons.directions),
                      label: const Text('Rota'),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // SOBRE
                _secao(
                  'Sobre este negócio',
                  [
                    Text(estabelecimento.descricao),
                  ],
                ),

                // PRODUTOS: APENAS SE EXISTIREM
                if (produtos.isNotEmpty)
                  _secao(
                    'Produtos disponíveis',
                    produtos.map(_cardOferta).toList(),
                  ),

                // SERVIÇOS: APENAS SE EXISTIREM
                if (servicos.isNotEmpty)
                  _secao(
                    'Serviços e valores',
                    servicos.map(_cardOferta).toList(),
                  ),

                // AVALIAÇÕES
                _secao(
                  'Avaliações',
                  [
                    Text(
                      'Média demonstrativa: '
                          '${estabelecimento.avaliacao.toStringAsFixed(1)}',
                    ),

                    const SizedBox(height: 16),

                    const Text('Sua nota:'),

                    Wrap(
                      children: List.generate(5, (indice) {
                        final valor = indice + 1;

                        return IconButton(
                          tooltip: '$valor estrelas',
                          onPressed: () {
                            setState(() {
                              _nota = valor;
                            });
                          },
                          icon: Icon(
                            valor <= _nota
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                          ),
                        );
                      }),
                    ),

                    TextField(
                      controller: _comentarioController,
                      maxLines: 3,
                      maxLength: 600,
                      decoration: const InputDecoration(
                        hintText:
                        'Conte como foi sua experiência...',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: _publicarAvaliacao,
                      child: const Text(
                        'Publicar avaliação (teste)',
                      ),
                    ),

                    const Divider(height: 32),

                    if (avaliacoes.isEmpty)
                      const Text(
                        'Ainda não há comentários.',
                      )
                    else
                      ...avaliacoes.map(_cardAvaliacao),
                  ],
                ),

                // ENDEREÇO E HORÁRIOS
                _secao(
                  'Endereço e horário',
                  [
                    Text(
                      '${detalhes?.endereco ?? 'Endereço não informado'}, '
                          '${estabelecimento.bairro}, '
                          '${estabelecimento.cidade} - '
                          '${detalhes?.uf ?? 'GO'}',
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Telefone: ${estabelecimento.telefone}',
                    ),

                    const Divider(height: 28),

                    if (detalhes == null ||
                        detalhes.horarios.isEmpty)
                      const Text(
                        'Horários não informados.',
                      )
                    else
                      ...detalhes.horarios.map(
                            (horario) => Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                          ),
                          child: Text(horario),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // COMPONENTE PARA CADA SEÇÃO
  Widget _secao(
      String titulo,
      List<Widget> conteudo,
      ) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 18),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                color: AppTheme.brown,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            ...conteudo,
          ],
        ),
      ),
    );
  }

  // COMPONENTE DE PRODUTO OU SERVIÇO
  Widget _cardOferta(Oferta oferta) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  oferta.nome,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              if (oferta.destaque)
                const Chip(
                  label: Text('Destaque'),
                ),
            ],
          ),

          const SizedBox(height: 6),

          Text(oferta.descricao),

          const SizedBox(height: 8),

          Text(
            _formatarPreco(oferta.preco),
            style: const TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),

          if (oferta.tipo == TipoOferta.produto &&
              oferta.estoque != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                oferta.estoque! > 0
                    ? '${oferta.estoque} disponíveis'
                    : 'Indisponível no momento',
              ),
            ),
        ],
      ),
    );
  }

  // COMPONENTE DE AVALIAÇÃO
  Widget _cardAvaliacao(Avaliacao avaliacao) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(10),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  avaliacao.autor,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Icon(
                Icons.star,
                size: 16,
                color: Colors.amber,
              ),

              Text('${avaliacao.nota}'),
            ],
          ),

          const SizedBox(height: 6),

          Text(avaliacao.comentario),
        ],
      ),
    );
  }
}
