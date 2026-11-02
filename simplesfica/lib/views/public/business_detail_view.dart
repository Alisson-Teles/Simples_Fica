
import 'package:flutter/material.dart';

import '../../models/detalhes_estabelecimento.dart';
import '../../models/estabelecimento.dart';
import '../../models/oferta.dart';
import '../../state/app_scope.dart';
import '../../theme/app_theme.dart';

import '../info/not_found_view.dart';

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
  int _nota = 5;

  final TextEditingController _comentarioController =
  TextEditingController();

  final List<Avaliacao> _avaliacoesLocais = [];

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  void _mostrarMensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
      ),
    );
  }

  // ======================================
  // AVALIAÇÃO DEMONSTRATIVA
  // ======================================

  void _publicarAvaliacao() {
    final sessao = AppScope.of(context);

    final id = widget.estabelecimento.id;

    if (!sessao.negocioDisponivelPublicamente(id)) {
      _mostrarMensagem(
        'Estabelecimento indisponível.',
      );
      return;
    }

    final comentario =
    _comentarioController.text.trim();

    if (comentario.isEmpty) {
      _mostrarMensagem(
        'Digite um comentário.',
      );
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

    _mostrarMensagem(
      'Avaliação adicionada nesta demonstração.',
    );
  }

  // ======================================
  // FORMATAÇÃO DO PREÇO
  // ======================================

  String _formatarPreco(double? valor) {
    if (valor == null) {
      return 'Consultar valor';
    }

    final numero = valor
        .toStringAsFixed(2)
        .replaceAll('.', ',');

    return 'R\$ $numero';
  }

  // ======================================
  // COMPONENTE DE SEÇÃO
  // ======================================

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
          crossAxisAlignment:
          CrossAxisAlignment.start,

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

  // ======================================
  // COMPONENTE DE PRODUTO OU SERVIÇO
  // ======================================

  Widget _cartaoOferta(Oferta oferta) {
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
          Text(
            oferta.nome,

            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
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
            Text(
              oferta.estoque! > 0
                  ? '${oferta.estoque} disponíveis'
                  : 'Indisponível no momento',
            ),
        ],
      ),
    );
  }

  // ======================================
  // TELA
  // ======================================

  @override
  Widget build(BuildContext context) {
    final sessao = AppScope.of(context);

    final id = widget.estabelecimento.id;

    final disponivel =
    sessao.negocioDisponivelPublicamente(id);

    final estabelecimento =
    sessao.estabelecimentoPorId(id);

    // ETAPA 7:
    // Uma única tela padronizada para negócios
    // suspensos, inativos ou não publicados.
    if (!disponivel || estabelecimento == null) {
      return const NotFoundView(
        titulo: 'Estabelecimento indisponível',
        mensagem:
        'Este negócio não está disponível '
            'para consulta pública no momento. '
            'Você pode voltar aos resultados '
            'ou acessar o início do aplicativo.',
      );
    }

    final detalhes = sessao.detalhesPorId(id);

    final favorito = sessao.isFavorite(id);

    final negocioLocal = sessao.ehNegocioLocal(id);

    final produtos =
        detalhes?.produtosAtivos ?? <Oferta>[];

    final servicos =
        detalhes?.servicosAtivos ?? <Oferta>[];

    final avaliacoes = <Avaliacao>[
      ..._avaliacoesLocais,
      ...?detalhes?.avaliacoes,
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text('Estabelecimento'),

        actions: [
          IconButton(
            tooltip: favorito
                ? 'Remover dos favoritos'
                : 'Adicionar aos favoritos',

            icon: Icon(
              favorito
                  ? Icons.favorite
                  : Icons.favorite_border,

              color: AppTheme.primary,
            ),

            onPressed: () {
              sessao.toggleFavorite(id);
            },
          ),
        ],
      ),

      body: ListView(
        children: [
          Container(
            height: 150,

            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF1D5C5),
                  Color(0xFFE5AD91),
                ],
              ),
            ),

            child: const Icon(
              Icons.storefront,
              size: 72,
              color: AppTheme.brown,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
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
                      label: Text(
                        detalhes?.tipoAtuacao.rotulo ??
                            'Sem ofertas',
                      ),
                    ),

                    if (!negocioLocal)
                      Chip(
                        label: Text(
                          estabelecimento.aberto
                              ? 'Aberto (demo)'
                              : 'Fechado (demo)',
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 14),

                Text(
                  estabelecimento.nome,

                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brown,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  '${estabelecimento.bairro}, '
                      '${estabelecimento.cidade} - '
                      '${detalhes?.uf ?? 'GO'}',
                ),

                const SizedBox(height: 12),

                if (!negocioLocal)
                  Text(
                    'Avaliação: '
                        '${estabelecimento.avaliacao.toStringAsFixed(1)} '
                        '(${estabelecimento.totalAvaliacoes} '
                        'avaliações demo)',
                  )
                else
                  const Text(
                    'Ainda sem avaliações públicas.',
                  ),

                const SizedBox(height: 18),

                // AÇÕES DE CONTATO
                Wrap(
                  spacing: 10,
                  runSpacing: 10,

                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _mostrarMensagem(
                          'WhatsApp será integrado '
                              'futuramente.',
                        );
                      },

                      icon: const Icon(Icons.chat),
                      label: const Text('WhatsApp'),
                    ),

                    OutlinedButton.icon(
                      onPressed: () {
                        _mostrarMensagem(
                          'Telefone: '
                              '${estabelecimento.telefone}',
                        );
                      },

                      icon: const Icon(Icons.phone),
                      label: const Text('Ligar'),
                    ),

                    OutlinedButton.icon(
                      onPressed: () {
                        _mostrarMensagem(
                          'Mapas serão integrados '
                              'futuramente.',
                        );
                      },

                      icon: const Icon(Icons.directions),
                      label: const Text('Rota'),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // SOBRE O NEGÓCIO
                _secao(
                  'Sobre este negócio',
                  [
                    Text(estabelecimento.descricao),
                  ],
                ),

                // PRODUTOS
                if (produtos.isNotEmpty)
                  _secao(
                    'Produtos disponíveis',
                    produtos.map(_cartaoOferta).toList(),
                  ),

                // SERVIÇOS
                if (servicos.isNotEmpty)
                  _secao(
                    'Serviços e valores',
                    servicos.map(_cartaoOferta).toList(),
                  ),

                // AVALIAÇÕES
                _secao(
                  'Avaliações (demonstração)',
                  [
                    const Text('Sua nota:'),

                    Wrap(
                      children: List.generate(
                        5,
                            (index) {
                          final nota = index + 1;

                          return IconButton(
                            tooltip: '$nota estrelas',

                            onPressed: () {
                              setState(() {
                                _nota = nota;
                              });
                            },

                            icon: Icon(
                              nota <= _nota
                                  ? Icons.star
                                  : Icons.star_border,

                              color: Colors.amber,
                            ),
                          );
                        },
                      ),
                    ),

                    TextField(
                      controller: _comentarioController,
                      maxLines: 3,
                      maxLength: 600,

                      decoration: const InputDecoration(
                        hintText:
                        'Escreva um comentário...',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    ElevatedButton(
                      onPressed: _publicarAvaliacao,

                      child: const Text(
                        'Publicar avaliação (teste)',
                      ),
                    ),

                    const Divider(height: 28),

                    if (avaliacoes.isEmpty)
                      const Text(
                        'Nenhum comentário demonstrativo.',
                      )
                    else
                      ...avaliacoes.map(
                            (avaliacao) => ListTile(
                          title: Text(avaliacao.autor),

                          subtitle: Text(
                            avaliacao.comentario,
                          ),

                          trailing: Text(
                            '${avaliacao.nota} ★',
                          ),
                        ),
                      ),
                  ],
                ),

                // ENDEREÇO E HORÁRIOS
                _secao(
                  'Endereço e horário',
                  [
                    Text(
                      '${detalhes?.endereco ?? 'Endereço não informado'}, '
                          '${estabelecimento.bairro}, '
                          '${estabelecimento.cidade}',
                    ),

                    const SizedBox(height: 8),

                    Text(
                      estabelecimento.telefone,
                    ),

                    const Divider(),

                    ...?detalhes?.horarios.map(
                          (horario) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: 6,
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
}
