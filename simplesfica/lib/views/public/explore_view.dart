
import 'package:flutter/material.dart';

import '../../models/detalhes_estabelecimento.dart';
import '../../models/estabelecimento.dart';
import '../../state/app_scope.dart';
import '../../state/app_session.dart';
import '../../theme/app_theme.dart';
import '../../widgets/business/estabelecimento_card.dart';

import 'business_detail_view.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final _buscaController = TextEditingController();
  final _cidadeController = TextEditingController();

  String _categoria = 'Todas';
  String _tipo = 'Todos';
  String _ordenacao = 'Mais perto';

  double _avaliacaoMinima = 0;
  bool _somenteAbertos = false;

  final _tipos = const [
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

  List<Estabelecimento> _filtrar(AppSession sessao) {
    final busca = _buscaController.text
        .trim()
        .toLowerCase();

    final cidade = _cidadeController.text
        .trim()
        .toLowerCase();

    final resultados =
    sessao.estabelecimentosPublicos.where((e) {
      final detalhes = sessao.detalhesPorId(e.id);

      final tipoAtuacao = detalhes?.tipoAtuacao ??
          TipoAtuacao.semOfertas;

      final textoCorresponde =
          e.nome.toLowerCase().contains(busca) ||
              e.descricao.toLowerCase().contains(busca) ||
              e.categoria.toLowerCase().contains(busca) ||
              (detalhes?.ofertas.any(
                    (oferta) =>
                oferta.ativo &&
                    oferta.nome.toLowerCase().contains(busca),
              ) ??
                  false);

      final categoriaCorresponde =
          _categoria == 'Todas' ||
              e.categoria == _categoria;

      final cidadeCorresponde =
          cidade.isEmpty ||
              e.cidade.toLowerCase().contains(cidade);

      final tipoCorresponde =
          _tipo == 'Todos' ||
              tipoAtuacao.rotulo == _tipo;

      final avaliacaoCorresponde =
          e.avaliacao >= _avaliacaoMinima;

      // Negócios locais ainda não têm horários
      // estruturados para calcular aberto agora.
      final abertoCorresponde =
          !_somenteAbertos ||
              (!sessao.ehNegocioLocal(e.id) && e.aberto);

      return textoCorresponde &&
          categoriaCorresponde &&
          cidadeCorresponde &&
          tipoCorresponde &&
          avaliacaoCorresponde &&
          abertoCorresponde;
    }).toList();

    if (_ordenacao == 'Melhor avaliação') {
      resultados.sort(
            (a, b) => b.avaliacao.compareTo(a.avaliacao),
      );
    } else if (_ordenacao == 'Ordem alfabética') {
      resultados.sort(
            (a, b) => a.nome.compareTo(b.nome),
      );
    } else {
      resultados.sort((a, b) {
        final aSemDistancia =
        sessao.ehNegocioLocal(a.id);
        final bSemDistancia =
        sessao.ehNegocioLocal(b.id);

        if (aSemDistancia != bSemDistancia) {
          return aSemDistancia ? 1 : -1;
        }

        return a.distanciaKm.compareTo(b.distanciaKm);
      });
    }

    return resultados;
  }

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

  void _abrirFiltros(AppSession sessao) {
    final categorias = {
      'Todas',
      ...sessao.estabelecimentosPublicos.map(
            (e) => e.categoria,
      ),
    }.toList();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (modalContext, atualizarModal) {
            void atualizar(VoidCallback acao) {
              setState(acao);
              atualizarModal(() {});
            }

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  MediaQuery.viewInsetsOf(modalContext)
                      .bottom +
                      20,
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
                      TextField(
                        controller: _cidadeController,
                        decoration: const InputDecoration(
                          labelText: 'Cidade',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => atualizar(() {}),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        key: ValueKey('categoria-$_categoria'),
                        initialValue: categorias.contains(_categoria)
                            ? _categoria
                            : 'Todas',
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Categoria',
                          border: OutlineInputBorder(),
                        ),
                        items: categorias.map((categoria) {
                          return DropdownMenuItem(
                            value: categoria,
                            child: Text(categoria),
                          );
                        }).toList(),
                        onChanged: (v) {
                          if (v != null) {
                            atualizar(() => _categoria = v);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
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
                        onChanged: (v) {
                          if (v != null) {
                            atualizar(() => _tipo = v);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        key: ValueKey('ordenacao-$_ordenacao'),
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
                        onChanged: (v) {
                          if (v != null) {
                            atualizar(() => _ordenacao = v);
                          }
                        },
                      ),
                      const SizedBox(height: 14),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Aberto agora (demo)'),
                        value: _somenteAbertos,
                        onChanged: (v) {
                          atualizar(() => _somenteAbertos = v);
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
                        onChanged: (v) {
                          atualizar(
                                () => _avaliacaoMinima = v,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.pop(modalContext),
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

  void _abrirDetalhes(Estabelecimento e) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BusinessDetailView(
          estabelecimento: e,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessao = AppScope.of(context);
    final resultados = _filtrar(sessao);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Explorar'),
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
                        decoration: const InputDecoration(
                          hintText: 'O que você procura?',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filled(
                      onPressed: () =>
                          _abrirFiltros(sessao),
                      icon: const Icon(Icons.tune),
                      tooltip: 'Filtros',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '${resultados.length} opção(ões) '
                      'encontrada(s)',
                ),
              ],
            ),
          ),
          Expanded(
            child: resultados.isEmpty
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Nenhum estabelecimento '
                      'disponível com esses filtros.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              itemCount: resultados.length,
              itemBuilder: (context, index) {
                final e = resultados[index];
                return EstabelecimentoCard(
                  estabelecimento: e,
                  onTap: () => _abrirDetalhes(e),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
