
import 'package:flutter/material.dart';

import '../../models/admin_demo_models.dart';
import '../../state/admin_demo_state.dart';
import '../../theme/app_theme.dart';

class UsersManagementView extends StatefulWidget {
  final AdminDemoState estado;

  // Filtros recebidos do Dashboard.
  final String perfilInicial;
  final String filtroStatusInicial;

  const UsersManagementView({
    super.key,
    required this.estado,
    this.perfilInicial = 'Todos',
    this.filtroStatusInicial = 'todos',
  });

  @override
  State<UsersManagementView> createState() =>
      _UsersManagementViewState();
}

class _UsersManagementViewState
    extends State<UsersManagementView> {
  final _buscaController = TextEditingController();

  late String _perfilSelecionado;
  late String _filtroStatus;

  @override
  void initState() {
    super.initState();

    _perfilSelecionado = widget.perfilInicial;
    _filtroStatus = widget.filtroStatusInicial;
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  // =====================================
  // RÓTULO DA SITUAÇÃO
  // =====================================


  String _rotuloStatus(StatusUsuarioAdmin status) {
    switch (status) {
      case StatusUsuarioAdmin.ativo:
        return 'Ativo';

      case StatusUsuarioAdmin.inativo:
        return 'Inativo';

      case StatusUsuarioAdmin.suspenso:
        return 'Suspenso';

      case StatusUsuarioAdmin.bloqueado:
        return 'Bloqueado';
    }
  }


  // =====================================
  // APLICAR FILTRO DE SITUAÇÃO
  // =====================================

  bool _correspondeStatus(
      UsuarioAdminDemo usuario,
      ) {
    switch (_filtroStatus) {
      case 'ativo':
        return usuario.status ==
            StatusUsuarioAdmin.ativo;

      case 'inativos':
      // Inclui inativos e bloqueados.
        return usuario.status !=
            StatusUsuarioAdmin.ativo;

      case 'inativo':
        return usuario.status ==
            StatusUsuarioAdmin.inativo;

      case 'bloqueado':
        return usuario.status ==
            StatusUsuarioAdmin.bloqueado;

      default:
        return true;
    }
  }

  // =====================================
  // ALTERAÇÃO DEMONSTRATIVA
  // =====================================

  Future<void> _alterarUsuario(
      UsuarioAdminDemo usuario,
      StatusUsuarioAdmin novoStatus,
      ) async {
    if (usuario.perfil == 'Administrador') {
      return;
    }

    if (usuario.status == novoStatus) {
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,

      builder: (dialogContext) => AlertDialog(
        title: const Text(
          'Alterar situação de teste?',
        ),

        content: Text(
          'Usuário: ${usuario.nome}\n\n'
              'Situação atual: '
              '${_rotuloStatus(usuario.status)}\n'
              'Nova situação: '
              '${_rotuloStatus(novoStatus)}\n\n'
              'Nenhuma conta real será alterada.',
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(false);
            },

            child: const Text('Cancelar'),
          ),

          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
            },

            child: const Text(
              'Confirmar simulação',
            ),
          ),
        ],
      ),
    );

    if (!mounted || confirmar != true) return;

    widget.estado.alterarStatusUsuario(
      usuario.id,
      novoStatus,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Situação demonstrativa atualizada '
              'e registrada na auditoria local.',
        ),
      ),
    );
  }

  // =====================================
  // MENU DE AÇÕES DO USUÁRIO
  // =====================================

  Widget _menuAcoes(UsuarioAdminDemo usuario) {
    if (usuario.perfil == 'Administrador') {
      return const Text(
        'Perfil administrativo protegido '
            'nesta demonstração.',
        style: TextStyle(fontSize: 12),
      );
    }

    return Align(
      alignment: Alignment.centerRight,

      child: PopupMenuButton<StatusUsuarioAdmin>(
        tooltip: 'Alterar situação de teste',

        onSelected: (status) {
          _alterarUsuario(usuario, status);
        },

        itemBuilder: (context) {
          return [
            if (usuario.status !=
                StatusUsuarioAdmin.ativo)
              const PopupMenuItem(
                value: StatusUsuarioAdmin.ativo,
                child: Text('Ativar (teste)'),
              ),

            if (usuario.status !=
                StatusUsuarioAdmin.inativo)
              const PopupMenuItem(
                value: StatusUsuarioAdmin.inativo,
                child: Text('Inativar (teste)'),
              ),

            if (usuario.status !=
                StatusUsuarioAdmin.bloqueado)
              const PopupMenuItem(
                value: StatusUsuarioAdmin.bloqueado,
                child: Text('Bloquear (teste)'),
              ),
          ];
        },

        child: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),

          child: Row(
            mainAxisSize: MainAxisSize.min,

            children: [
              Icon(
                Icons.edit_outlined,
                size: 18,
                color: AppTheme.primary,
              ),

              SizedBox(width: 8),

              Text(
                'Alterar situação',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),

              Icon(
                Icons.arrow_drop_down,
                color: AppTheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================
  // CARTÃO DE USUÁRIO
  // =====================================

  Widget _cartaoUsuario(UsuarioAdminDemo usuario) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),

      child: Padding(
        padding: const EdgeInsets.all(14),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [
            Text(
              usuario.nome,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppTheme.brown,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              usuario.email,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              runSpacing: 6,

              children: [
                Chip(
                  label: Text(usuario.perfil),
                ),

                Chip(
                  label: Text(
                    '${_rotuloStatus(usuario.status)} '
                        '(demo)',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            _menuAcoes(usuario),
          ],
        ),
      ),
    );
  }

  // =====================================
  // INTERFACE
  // =====================================

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.estado,

      builder: (context, _) {
        final termo = _buscaController.text
            .trim()
            .toLowerCase();

        final usuarios = widget.estado.usuarios.where(
              (usuario) {
            final correspondeBusca =
                usuario.nome
                    .toLowerCase()
                    .contains(termo) ||
                    usuario.email
                        .toLowerCase()
                        .contains(termo);

            final correspondePerfil =
                _perfilSelecionado == 'Todos' ||
                    usuario.perfil == _perfilSelecionado;

            return correspondeBusca &&
                correspondePerfil &&
                _correspondeStatus(usuario);
          },
        ).toList();

        return Scaffold(
          backgroundColor: AppTheme.background,

          appBar: AppBar(
            title: const Text(
              'Gerenciar usuários',
            ),
          ),

          body: ListView(
            padding: const EdgeInsets.all(16),

            children: [
              // RESUMO
              Card(
                color: const Color(0xFFFFF3DC),

                child: Padding(
                  padding: const EdgeInsets.all(14),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      const Text(
                        'Resumo de clientes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Total: ${widget.estado.clientes}',
                      ),

                      Text(
                        'Ativos: '
                            '${widget.estado.clientesAtivos}',
                      ),

                      Text(
                        'Inativos: '
                            '${widget.estado.clientesInativos}',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // PESQUISA
              TextField(
                controller: _buscaController,

                decoration: const InputDecoration(
                  labelText: 'Pesquisar usuário',
                  hintText: 'Nome ou e-mail',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),

                onChanged: (_) {
                  setState(() {});
                },
              ),

              const SizedBox(height: 14),

              // FILTRO POR PERFIL
              DropdownButtonFormField<String>(
                initialValue: _perfilSelecionado,
                isExpanded: true,

                decoration: const InputDecoration(
                  labelText: 'Tipo de perfil',
                  border: OutlineInputBorder(),
                ),

                items: const [
                  DropdownMenuItem(
                    value: 'Todos',
                    child: Text('Todos'),
                  ),

                  DropdownMenuItem(
                    value: 'Cliente',
                    child: Text('Cliente'),
                  ),

                  DropdownMenuItem(
                    value: 'Comerciante',
                    child: Text('Comerciante'),
                  ),

                  DropdownMenuItem(
                    value: 'Administrador',
                    child: Text('Administrador'),
                  ),
                ],

                onChanged: (valor) {
                  setState(() {
                    _perfilSelecionado =
                        valor ?? 'Todos';
                  });
                },
              ),

              const SizedBox(height: 14),

              // FILTRO POR SITUAÇÃO
              DropdownButtonFormField<String>(
                initialValue: _filtroStatus,
                isExpanded: true,

                decoration: const InputDecoration(
                  labelText: 'Situação cadastral',
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
                    value: 'inativos',
                    child: Text(
                      'Inativos (inclui bloqueados)',
                    ),
                  ),

                  DropdownMenuItem(
                    value: 'inativo',
                    child: Text('Somente inativos'),
                  ),

                  DropdownMenuItem(
                    value: 'bloqueado',
                    child: Text('Somente bloqueados'),
                  ),
                ],

                onChanged: (valor) {
                  setState(() {
                    _filtroStatus = valor ?? 'todos';
                  });
                },
              ),

              const SizedBox(height: 16),

              Text(
                '${usuarios.length} usuário(s) '
                    'encontrado(s)',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              if (usuarios.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),

                    child: Text(
                      'Nenhum usuário encontrado '
                          'com os filtros selecionados.',
                    ),
                  ),
                )
              else
                ...usuarios.map(_cartaoUsuario),

              const SizedBox(height: 16),

              const Text(
                'Os estados desta lista são '
                    'demonstrativos. Ativar, inativar '
                    'ou bloquear aqui não altera '
                    'o login real de nenhuma pessoa.',
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF78645C),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
