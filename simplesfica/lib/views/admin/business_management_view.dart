
import 'package:flutter/material.dart';

import '../../models/admin_demo_models.dart';
import '../../models/detalhes_estabelecimento.dart';
import '../../state/admin_business_metrics.dart';
import '../../state/admin_demo_state.dart';
import '../../theme/app_theme.dart';

class BusinessManagementView extends StatefulWidget {
  final AdminDemoState estado;
  final FiltroAtuacaoAdmin filtroAtuacaoInicial;
  final String filtroStatusInicial;

  const BusinessManagementView({
    super.key,
    required this.estado,
    this.filtroAtuacaoInicial =
        FiltroAtuacaoAdmin.todos,
    this.filtroStatusInicial = 'todos',
  });

  @override
  State<BusinessManagementView> createState() =>
      _BusinessManagementViewState();
}

class _BusinessManagementViewState
    extends State<BusinessManagementView> {
  final _buscaController = TextEditingController();

  late FiltroAtuacaoAdmin _atuacao;
  late String _status;

  @override
  void initState() {
    super.initState();
    _atuacao = widget.filtroAtuacaoInicial;
    _status = widget.filtroStatusInicial;
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  StatusNegocioAdmin? get _statusSelecionado {
    for (final item in StatusNegocioAdmin.values) {
      if (item.name == _status) return item;
    }
    return null;
  }

  Future<bool> _confirmar(
      String titulo,
      String mensagem,
      ) async {
    final resposta = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(titulo),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            child: const Text('Confirmar teste'),
          ),
        ],
      ),
    );
    return resposta == true;
  }

  Future<void> _alterarStatus(
      NegocioAdminDemo negocio,
      ) async {
    final novo = negocio.status ==
        StatusNegocioAdmin.ativo
        ? StatusNegocioAdmin.suspenso
        : StatusNegocioAdmin.ativo;

    final ok = await _confirmar(
      'Alterar situação?',
      '${negocio.nome}\n'
          'Nova situação: ${novo.name}.\n\n'
          'As telas públicas serão atualizadas '
          'nesta demonstração.',
    );
    if (!mounted || !ok) return;

    widget.estado.alterarStatusNegocio(
      negocio.id,
      novo,
    );
  }

  Future<void> _alterarPublicacao(
      NegocioAdminDemo negocio,
      ) async {
    final publicar = !negocio.publicado;

    final ok = await _confirmar(
      publicar ? 'Publicar negócio?' : 'Retirar publicação?',
      '${negocio.nome}\n\n'
          'A publicação altera a visibilidade '
          'na Home e na busca durante esta execução.',
    );
    if (!mounted || !ok) return;

    try {
      widget.estado.alterarPublicacao(
        negocio.id,
        publicar,
      );
    } on StateError catch (erro) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro.message)),
      );
    }
  }

  void _limparFiltros() {
    _buscaController.clear();
    setState(() {
      _atuacao = FiltroAtuacaoAdmin.todos;
      _status = 'todos';
    });
  }

  Widget _cartao(NegocioAdminDemo negocio) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              negocio.nome,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.brown,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${negocio.cidade} · ${negocio.categoria}',
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                Chip(
                  label: Text(negocio.tipoAtuacao.rotulo),
                ),
                Chip(
                  label: Text(
                    '${negocio.status.name} (demo)',
                  ),
                ),
                Chip(
                  label: Text(
                    negocio.visivelPublicamente
                        ? 'Visível ao público'
                        : negocio.publicado
                        ? 'Publicado, indisponível'
                        : 'Não publicado',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _alterarStatus(negocio),
                  icon: Icon(
                    negocio.status == StatusNegocioAdmin.ativo
                        ? Icons.block_outlined
                        : Icons.check_circle_outline,
                  ),
                  label: Text(
                    negocio.status == StatusNegocioAdmin.ativo
                        ? 'Suspender (teste)'
                        : 'Ativar (teste)',
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () =>
                      _alterarPublicacao(negocio),
                  icon: Icon(
                    negocio.publicado
                        ? Icons.visibility_off_outlined
                        : Icons.public_outlined,
                  ),
                  label: Text(
                    negocio.publicado
                        ? 'Retirar publicação'
                        : 'Publicar (teste)',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.estado,
      builder: (context, _) {
        final lista = widget.estado.filtrarNegocios(
          atuacao: _atuacao,
          status: _statusSelecionado,
          pesquisa: _buscaController.text,
        );

        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            title: const Text('Estabelecimentos'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: const Color(0xFFFFF3DC),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resumo administrativo',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cadastrados: '
                            '${widget.estado.negocios.length}',
                      ),
                      Text(
                        'Visíveis ao público: '
                            '${widget.estado.negociosPublicados}',
                      ),
                      Text(
                        'Somente comerciantes: '
                            '${widget.estado.somenteComerciantes}',
                      ),
                      Text(
                        'Somente prestadores: '
                            '${widget.estado.somentePrestadores}',
                      ),
                      Text(
                        'Ambos: '
                            '${widget.estado.comerciantesEPrestadores}',
                      ),
                      Text(
                        'Sem ofertas ativas: '
                            '${widget.estado.negociosSemOfertas}',
                      ),
                      const Divider(),
                      Text(
                        'Ativos: '
                            '${widget.estado.negociosAtivos}',
                      ),
                      Text(
                        'Suspensos: '
                            '${widget.estado.negociosSuspensos}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _buscaController,
                decoration: const InputDecoration(
                  labelText: 'Pesquisar estabelecimento',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<FiltroAtuacaoAdmin>(
                key: ValueKey('atuacao-$_atuacao'),
                initialValue: _atuacao,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Tipo de atuação',
                  border: OutlineInputBorder(),
                ),
                items: FiltroAtuacaoAdmin.values.map((v) {
                  return DropdownMenuItem(
                    value: v,
                    child: Text(
                      v.rotulo,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (v) => setState(() {
                  _atuacao = v ?? FiltroAtuacaoAdmin.todos;
                }),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                key: ValueKey('status-$_status'),
                initialValue: _status,
                decoration: const InputDecoration(
                  labelText: 'Situação administrativa',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'todos',
                    child: Text('Todas'),
                  ),
                  DropdownMenuItem(
                    value: 'ativo',
                    child: Text('Ativos'),
                  ),
                  DropdownMenuItem(
                    value: 'suspenso',
                    child: Text('Suspensos'),
                  ),
                  DropdownMenuItem(
                    value: 'inativo',
                    child: Text('Inativos'),
                  ),
                ],
                onChanged: (v) => setState(() {
                  _status = v ?? 'todos';
                }),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _limparFiltros,
                  icon: const Icon(
                    Icons.filter_alt_off_outlined,
                  ),
                  label: const Text('Limpar filtros'),
                ),
              ),
              Text(
                '${lista.length} negócio(s) encontrado(s)',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              if (lista.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Nenhum negócio neste filtro.',
                    ),
                  ),
                )
              else
                ...lista.map(_cartao),
            ],
          ),
        );
      },
    );
  }
}
