
import 'package:flutter/material.dart';

import '../data/estabelecimentos_mock.dart';
import '../models/estabelecimento.dart';
import '../theme/app_theme.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final TextEditingController _buscaController =
  TextEditingController();

  String _cidade = '';
  String _categoria = 'Todas';
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

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  List<Estabelecimento> get _resultados {
    final busca = _buscaController.text.toLowerCase().trim();

    final lista = estabelecimentosMock.where((e) {
      final correspondeBusca =
          e.nome.toLowerCase().contains(busca) ||
              e.descricao.toLowerCase().contains(busca) ||
              e.categoria.toLowerCase().contains(busca);

      final correspondeCategoria =
          _categoria == 'Todas' ||
              e.categoria == _categoria;

      final correspondeCidade =
          _cidade.isEmpty ||
              e.cidade.toLowerCase().contains(
                _cidade.toLowerCase().trim(),
              );

      final correspondeAvaliacao =
          e.avaliacao >= _avaliacaoMinima;

      final correspondeAberto =
          !_somenteAbertos || e.aberto;

      return correspondeBusca &&
          correspondeCategoria &&
          correspondeCidade &&
          correspondeAvaliacao &&
          correspondeAberto;
    }).toList();

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

  void _limparFiltros() {
    setState(() {
      _buscaController.clear();
      _cidade = '';
      _categoria = 'Todas';
      _ordenacao = 'Mais perto';
      _avaliacaoMinima = 0;
      _somenteAbertos = false;
    });
  }

  void _abrirFiltros() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, atualizarModal) {
            void atualizar(void Function() alteracao) {
              atualizarModal(() {
                setState(alteracao);
              });
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
                              atualizar(_limparCampos);
                            },
                            child: const Text('Limpar'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        initialValue: _cidade,
                        decoration: const InputDecoration(
                          labelText: 'Cidade',
                          hintText: 'Ex.: Rio Verde',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (valor) {
                          atualizar(() => _cidade = valor);
                        },
                      ),

                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
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
                            atualizar(
                                  () => _categoria = valor,
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
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
                            atualizar(
                                  () => _ordenacao = valor,
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Aberto agora'),
                        value: _somenteAbertos,
                        onChanged: (valor) {
                          atualizar(
                                () => _somenteAbertos = valor,
                          );
                        },
                      ),

                      const SizedBox(height: 12),

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
                          atualizar(
                                () => _avaliacaoMinima = valor,
                          );
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

  void _limparCampos() {
    _cidade = '';
    _categoria = 'Todas';
    _ordenacao = 'Mais perto';
    _avaliacaoMinima = 0;
    _somenteAbertos = false;
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
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Encontre perto de você',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brown,
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _buscaController,
                        onChanged: (_) => setState(() {}),
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
                return _cardEstabelecimento(
                  resultados[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _cardEstabelecimento(
      Estabelecimento estabelecimento,
      ) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4E3D7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.storefront,
                    color: AppTheme.primary,
                    size: 30,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        estabelecimento.nome,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        '${estabelecimento.categoria} · '
                            '${estabelecimento.bairro}',
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(estabelecimento.descricao),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  estabelecimento.avaliacao
                      .toStringAsFixed(1),
                ),
                Text(
                  ' (${estabelecimento.totalAvaliacoes})',
                ),
                const Spacer(),
                Text(
                  '${estabelecimento.distanciaKm.toStringAsFixed(1)} km',
                ),
              ],
            ),

            const SizedBox(height: 8),

            Chip(
              label: Text(
                estabelecimento.aberto
                    ? 'Aberto'
                    : 'Fechado',
              ),
              backgroundColor: estabelecimento.aberto
                  ? const Color(0xFFE2F2E4)
                  : const Color(0xFFF5E5E5),
            ),
          ],
        ),
      ),
    );
  }
}
