
import 'package:flutter/material.dart';

import '../../data/estabelecimentos_mock.dart';
import '../../data/detalhes_mock.dart';
import '../../models/estabelecimento.dart';
import '../../models/detalhes_estabelecimento.dart';
import '../../theme/app_theme.dart';
import '../../widgets/business/estabelecimento_card.dart';

import 'business_detail_view.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final TextEditingController _buscaController =
  TextEditingController();

  final TextEditingController _cidadeController =
  TextEditingController();

  String _categoria = 'Todas';
  String _tipo = 'Todos';
  String _ordenacao = 'Mais perto';

  double _avaliacaoMinima = 0;
  bool _somenteAbertos = false;

  final List<String> _categorias = [
    'Todas',
    'Alimentação',
    'Tecnologia',
    'Beleza',
    'Mercados',
    'Automotivo',
  ];

  final List<String> _tipos = [
    'Todos',
    'Comerciante',
    'Prestador de serviços',
    'Produtos e serviços',
  ];

  @override
  void dispose() {
    _buscaController.dispose();
    _cidadeController.dispose();
    super.dispose();
  }

  // FILTRAGEM DOS ESTABELECIMENTOS
  List<Estabelecimento> get _resultados {
    final busca =
    _buscaController.text.toLowerCase().trim();

    final cidade =
    _cidadeController.text.toLowerCase().trim();

    final lista = estabelecimentosMock.where((e) {
      final detalhes = detalhesMock[e.id];

      final tipoAtuacao = detalhes?.tipoAtuacao ??
          TipoAtuacao.semOfertas;

      // PESQUISA POR NOME, DESCRIÇÃO E CATEGORIA
      final correspondeBusca =
          e.nome.toLowerCase().contains(busca) ||
              e.descricao.toLowerCase().contains(busca) ||
              e.categoria.toLowerCase().contains(busca) ||
              (detalhes?.ofertas.any(
                    (oferta) =>
                oferta.ativo &&
                    oferta.nome.toLowerCase().contains(busca),
              ) ??
                  false);

      // FILTRO DE CATEGORIA
      final correspondeCategoria =
          _categoria == 'Todas' ||
              e.categoria == _categoria;

      // FILTRO DE CIDADE
      final correspondeCidade =
          cidade.isEmpty ||
              e.cidade.toLowerCase().contains(cidade);

      // FILTRO DE TIPO DE ESTABELECIMENTO
      final correspondeTipo =
          _tipo == 'Todos' ||
              tipoAtuacao.rotulo == _tipo;

      // FILTRO DE AVALIAÇÃO
      final correspondeAvaliacao =
          e.avaliacao >= _avaliacaoMinima;

      // FILTRO DE FUNCIONAMENTO
      final correspondeAberto =
          !_somenteAbertos || e.aberto;

      return correspondeBusca &&
          correspondeCategoria &&
          correspondeCidade &&
          correspondeTipo &&
          correspondeAvaliacao &&
          correspondeAberto;
    }).toList();

    // ORDENAÇÃO DOS RESULTADOS
    if (_ordenacao == 'Melhor avaliação') {
      lista.sort(
            (a, b) => b.avaliacao.compareTo(a.avaliacao),
      );
    } else if (_ordenacao == 'Ordem alfabética') {
      lista.sort(
            (a, b) => a.nome.compareTo(b.nome),
      );
    } else {
      lista.sort(
            (a, b) => a.distanciaKm.compareTo(b.distanciaKm),
      );
    }

    return lista;
  }

  // LIMPAR FILTROS
  void _limparFiltros() {
    setState(() {
      _buscaController.clear();
      _cidadeController.clear();

      _categoria = 'Todas';
      _tipo = 'Todos';
      _ordenacao = 'Mais perto';
      _avaliacaoMinima = 0;
      _somenteAbertos = false;
    });
  }

  // JANELA INFERIOR DE FILTROS
  void _abrirFiltros() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,

      builder: (context) {
        return StatefulBuilder(
          builder: (context, atualizarModal) {
            void atualizar(VoidCallback alteracao) {
              setState(alteracao);
              atualizarModal(() {});
            }

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  MediaQuery.viewInsetsOf(context).bottom + 20,
                ),

                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Filtros de pesquisa',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          TextButton(
                            onPressed: () {
                              atualizar(() {
                                _cidadeController.clear();
                                _categoria = 'Todas';
                                _tipo = 'Todos';
                                _ordenacao = 'Mais perto';
                                _avaliacaoMinima = 0;
                                _somenteAbertos = false;
                              });
                            },
                            child: const Text('Limpar'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // CIDADE
                      TextField(
                        controller: _cidadeController,
                        decoration: const InputDecoration(
                          labelText: 'Cidade',
                          hintText: 'Ex.: Rio Verde',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) {
                          atualizar(() {});
                        },
                      ),

                      const SizedBox(height: 16),

                      // CATEGORIA
                      DropdownButtonFormField<String>(
                        key: ValueKey(
                          'categoria-$_categoria',
                        ),
                        initialValue: _categoria,
                        decoration: const InputDecoration(
                          labelText: 'Categoria',
                          border: OutlineInputBorder(),
                        ),
                        items: _categorias.map((categoria) {
                          return DropdownMenuItem(
                            value: categoria,
                            child: Text(categoria),
                          );
                        }).toList(),
                        onChanged: (valor) {
                          if (valor != null) {
                            atualizar(() {
                              _categoria = valor;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      // TIPO DE ESTABELECIMENTO
                      DropdownButtonFormField<String>(
                        key: ValueKey('tipo-$_tipo'),
                        initialValue: _tipo,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Tipo de estabelecimento',
                          border: OutlineInputBorder(),
                        ),
                        items: _tipos.map((tipo) {
                          return DropdownMenuItem(
                            value: tipo,
                            child: Text(tipo),
                          );
                        }).toList(),
                        onChanged: (valor) {
                          if (valor != null) {
                            atualizar(() {
                              _tipo = valor;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      // ORDENAÇÃO
                      DropdownButtonFormField<String>(
                        key: ValueKey(
                          'ordenacao-$_ordenacao',
                        ),
                        initialValue: _ordenacao,
                        decoration: const InputDecoration(
                          labelText: 'Ordenar por',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Mais perto',
                            child: Text('Mais perto'),
                          ),
                          DropdownMenuItem(
                            value: 'Melhor avaliação',
                            child: Text('Melhor avaliação'),
                          ),
                          DropdownMenuItem(
                            value: 'Ordem alfabética',
                            child: Text('Ordem alfabética'),
                          ),
                        ],
                        onChanged: (valor) {
                          if (valor != null) {
                            atualizar(() {
                              _ordenacao = valor;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      // ABERTO AGORA
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Aberto agora (demo)'),
                        value: _somenteAbertos,
                        onChanged: (valor) {
                          atualizar(() {
                            _somenteAbertos = valor;
                          });
                        },
                      ),

                      const SizedBox(height: 12),

                      // AVALIAÇÃO MÍNIMA
                      Text(
                        'Avaliação mínima: '
                            '${_avaliacaoMinima.toStringAsFixed(1)}',
                      ),

                      Slider(
                        value: _avaliacaoMinima,
                        min: 0,
                        max: 5,
                        divisions: 10,
                        label: _avaliacaoMinima
                            .toStringAsFixed(1),
                        onChanged: (valor) {
                          atualizar(() {
                            _avaliacaoMinima = valor;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Ver resultados'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // NAVEGAR PARA OS DETALHES
  void _abrirDetalhes(Estabelecimento estabelecimento) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BusinessDetailView(
          estabelecimento: estabelecimento,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resultados = _resultados;

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text(
          'Explorar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Encontre perto de você',
                  style: TextStyle(
                    color: AppTheme.brown,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _buscaController,
                        onChanged: (_) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'O que você procura?',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    IconButton.filled(
                      onPressed: _abrirFiltros,
                      icon: const Icon(Icons.tune),
                      tooltip: 'Filtros',
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Text(
                  '${resultados.length} '
                      '${resultados.length == 1 ? 'opção encontrada' : 'opções encontradas'}',
                  style: const TextStyle(
                    color: Color(0xFF705A51),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: resultados.isEmpty
                ? _estadoVazio()
                : ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              itemCount: resultados.length,

              itemBuilder: (context, index) {
                final estabelecimento =
                resultados[index];

                return EstabelecimentoCard(
                  estabelecimento: estabelecimento,
                  onTap: () {
                    _abrirDetalhes(estabelecimento);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ESTADO SEM RESULTADOS
  Widget _estadoVazio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_off_outlined,
              size: 52,
              color: AppTheme.primary,
            ),

            const SizedBox(height: 16),

            const Text(
              'Nenhum estabelecimento encontrado',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Tente outra busca ou altere os filtros.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: _limparFiltros,
              child: const Text('Limpar filtros'),
            ),
          ],
        ),
      ),
    );
  }
}
