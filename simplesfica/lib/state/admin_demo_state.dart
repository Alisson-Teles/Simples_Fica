
import 'package:flutter/foundation.dart';

import '../data/detalhes_mock.dart';
import '../data/estabelecimentos_mock.dart';
import '../models/admin_demo_models.dart';
import '../models/detalhes_estabelecimento.dart';
import '../models/negocio_demo.dart';

class AdminDemoState extends ChangeNotifier {
  // ======================================
  // ESTABELECIMENTOS
  // ======================================

  late final List<NegocioAdminDemo> _negocios =
  estabelecimentosMock.map((e) {
    return NegocioAdminDemo(
      id: e.id,
      nome: e.nome,
      cidade: e.cidade,
      categoria: e.categoria,
      tipoAtuacao: detalhesMock[e.id]?.tipoAtuacao ??
          TipoAtuacao.semOfertas,
      status: e.id == 3
          ? StatusNegocioAdmin.suspenso
          : e.id == 5
          ? StatusNegocioAdmin.inativo
          : StatusNegocioAdmin.ativo,
      publicado: true,
    );
  }).toList();

  List<NegocioAdminDemo> get negocios =>
      List.unmodifiable(_negocios);

  NegocioAdminDemo? negocioPorId(int id) {
    for (final negocio in _negocios) {
      if (negocio.id == id) return negocio;
    }
    return null;
  }

  bool negocioVisivel(int id) =>
      negocioPorId(id)?.visivelPublicamente ?? false;

  int get negociosAtivos => _negocios
      .where((n) => n.status == StatusNegocioAdmin.ativo)
      .length;

  int get negociosSuspensos => _negocios
      .where((n) => n.status == StatusNegocioAdmin.suspenso)
      .length;

  int get negociosPublicados => _negocios
      .where((n) => n.visivelPublicamente)
      .length;

  void alterarStatusNegocio(
      int id,
      StatusNegocioAdmin novoStatus,
      ) {
    final index = _negocios.indexWhere((n) => n.id == id);
    if (index < 0) {
      throw StateError('Negócio não encontrado.');
    }

    final anterior = _negocios[index];
    if (anterior.status == novoStatus) return;

    _negocios[index] = anterior.copyWith(status: novoStatus);

    _registrarAuditoria(
      'Situação alterada para ${novoStatus.name}',
      anterior.nome,
    );
    notifyListeners();
  }

  void alterarPublicacao(int id, bool publicar) {
    final index = _negocios.indexWhere((n) => n.id == id);
    if (index < 0) {
      throw StateError('Negócio não encontrado.');
    }

    final anterior = _negocios[index];
    if (anterior.publicado == publicar) return;

    if (publicar &&
        anterior.status != StatusNegocioAdmin.ativo) {
      throw StateError(
        'Ative o estabelecimento antes de publicá-lo.',
      );
    }

    if (publicar &&
        anterior.tipoAtuacao == TipoAtuacao.semOfertas) {
      throw StateError(
        'Cadastre pelo menos uma oferta ativa.',
      );
    }

    _negocios[index] = anterior.copyWith(
      publicado: publicar,
    );

    _registrarAuditoria(
      publicar ? 'Publicação aprovada (demo)'
          : 'Publicação retirada (demo)',
      anterior.nome,
    );
    notifyListeners();
  }

  // Atualiza o cadastro administrativo quando
  // o Comerciante cria ou modifica um negócio.
  void sincronizarNegocioComerciante(NegocioDemo negocio) {
    final index = _negocios.indexWhere(
          (n) => n.id == negocio.id,
    );

    if (index < 0) {
      _negocios.add(
        NegocioAdminDemo(
          id: negocio.id,
          nome: negocio.nome,
          cidade: negocio.cidade,
          categoria: negocio.categoria,
          status: StatusNegocioAdmin.ativo,
          publicado: false,
          tipoAtuacao: negocio.tipoAtuacao,
        ),
      );

      _registrarAuditoria(
        'Cadastro do comerciante recebido (demo)',
        negocio.nome,
      );
    } else {
      final anterior = _negocios[index];

      // Preserva a suspensão e a publicação
      // determinadas pelo Administrador.
      _negocios[index] = anterior.copyWith(
        nome: negocio.nome,
        cidade: negocio.cidade,
        categoria: negocio.categoria,
        tipoAtuacao: negocio.tipoAtuacao,
      );

      _registrarAuditoria(
        'Cadastro do comerciante atualizado (demo)',
        negocio.nome,
      );
    }

    notifyListeners();
  }

  void removerNegocioComerciante(int id) {
    final index = _negocios.indexWhere(
          (n) => n.id == id,
    );
    if (index < 0) return;

    final nome = _negocios[index].nome;
    _negocios.removeAt(index);

    _registrarAuditoria(
      'Cadastro removido pelo comerciante (demo)',
      nome,
    );
    notifyListeners();
  }

  // ======================================
  // USUÁRIOS
  // ======================================

  final List<UsuarioAdminDemo> _usuarios = [
    const UsuarioAdminDemo(
      id: 1,
      nome: 'Cliente de Teste',
      email: 'cliente@simplesfica.test',
      perfil: 'Cliente',
      status: StatusUsuarioAdmin.ativo,
    ),
    const UsuarioAdminDemo(
      id: 2,
      nome: 'Comerciante de Teste',
      email: 'comerciante@simplesfica.test',
      perfil: 'Comerciante',
      status: StatusUsuarioAdmin.ativo,
    ),
    const UsuarioAdminDemo(
      id: 3,
      nome: 'Administrador de Teste',
      email: 'admin@simplesfica.test',
      perfil: 'Administrador',
      status: StatusUsuarioAdmin.ativo,
    ),
    const UsuarioAdminDemo(
      id: 4,
      nome: 'Ana Exemplo',
      email: 'ana@exemplo.test',
      perfil: 'Cliente',
      status: StatusUsuarioAdmin.inativo,
    ),
    const UsuarioAdminDemo(
      id: 5,
      nome: 'Marcos Exemplo',
      email: 'marcos@exemplo.test',
      perfil: 'Comerciante',
      status: StatusUsuarioAdmin.bloqueado,
    ),
  ];

  List<UsuarioAdminDemo> get usuarios =>
      List.unmodifiable(_usuarios);

  int get clientes =>
      _usuarios.where((u) => u.perfil == 'Cliente').length;

  int get clientesAtivos => _usuarios.where(
        (u) => u.perfil == 'Cliente' &&
        u.status == StatusUsuarioAdmin.ativo,
  ).length;

  int get clientesInativos => _usuarios.where(
        (u) => u.perfil == 'Cliente' &&
        u.status != StatusUsuarioAdmin.ativo,
  ).length;

  int get comerciantes => _usuarios.where(
        (u) => u.perfil == 'Comerciante',
  ).length;

  void alterarStatusUsuario(
      int id,
      StatusUsuarioAdmin novoStatus,
      ) {
    final index = _usuarios.indexWhere((u) => u.id == id);
    if (index < 0) {
      throw StateError('Usuário não encontrado.');
    }

    final anterior = _usuarios[index];
    if (anterior.status == novoStatus) return;

    _usuarios[index] = anterior.copyWith(
      status: novoStatus,
    );

    _registrarAuditoria(
      'Situação de usuário: ${novoStatus.name}',
      anterior.nome,
    );
    notifyListeners();
  }

  // ======================================
  // FINANCEIRO
  // ======================================

  final List<PagamentoAdminDemo> _pagamentos = [
    const PagamentoAdminDemo(
      id: 1,
      negocioId: 1,
      descricao: 'Assinatura demonstrativa',
      valor: 49.90,
      status: StatusPagamentoAdmin.aprovado,
    ),
    const PagamentoAdminDemo(
      id: 2,
      negocioId: 2,
      descricao: 'Assinatura demonstrativa',
      valor: 59.90,
      status: StatusPagamentoAdmin.pendente,
    ),
    const PagamentoAdminDemo(
      id: 3,
      negocioId: 3,
      descricao: 'Assinatura demonstrativa',
      valor: 59.90,
      status: StatusPagamentoAdmin.vencido,
    ),
    const PagamentoAdminDemo(
      id: 4,
      negocioId: 4,
      descricao: 'Assinatura demonstrativa',
      valor: 49.90,
      status: StatusPagamentoAdmin.aprovado,
    ),
    const PagamentoAdminDemo(
      id: 5,
      negocioId: 5,
      descricao: 'Assinatura demonstrativa',
      valor: 39.90,
      status: StatusPagamentoAdmin.vencido,
    ),
  ];

  List<PagamentoAdminDemo> get pagamentos =>
      List.unmodifiable(_pagamentos);

  double get receitaAprovada => _pagamentos
      .where((p) => p.status == StatusPagamentoAdmin.aprovado)
      .fold<double>(0, (total, p) => total + p.valor);

  int get inadimplentes => _pagamentos
      .where((p) => p.status == StatusPagamentoAdmin.vencido)
      .map((p) => p.negocioId)
      .toSet()
      .length;

  // ======================================
  // ANÚNCIOS
  // ======================================

  final List<AnuncioAdminDemo> _anuncios = [
    const AnuncioAdminDemo(
      id: 1,
      negocioId: 1,
      titulo: 'Café especial em destaque',
      status: StatusAnuncioAdmin.ativo,
    ),
    const AnuncioAdminDemo(
      id: 2,
      negocioId: 2,
      titulo: 'Acessórios para celular',
      status: StatusAnuncioAdmin.pausado,
    ),
    const AnuncioAdminDemo(
      id: 3,
      negocioId: 4,
      titulo: 'Ofertas do mercado',
      status: StatusAnuncioAdmin.ativo,
    ),
  ];

  List<AnuncioAdminDemo> get anuncios =>
      List.unmodifiable(_anuncios);

  // Apenas anúncios ativos de negócios visíveis.
  int get anunciosAtivos => _anuncios.where(
        (a) => a.status == StatusAnuncioAdmin.ativo &&
        negocioVisivel(a.negocioId),
  ).length;

  List<int> get negociosPatrocinados => _anuncios
      .where((a) =>
  a.status == StatusAnuncioAdmin.ativo &&
      negocioVisivel(a.negocioId))
      .map((a) => a.negocioId)
      .toSet()
      .toList();

  void alterarStatusAnuncio(
      int id,
      StatusAnuncioAdmin novoStatus,
      ) {
    final index = _anuncios.indexWhere((a) => a.id == id);
    if (index < 0) {
      throw StateError('Anúncio não encontrado.');
    }

    final anterior = _anuncios[index];
    if (anterior.status == novoStatus) return;

    _anuncios[index] = anterior.copyWith(
      status: novoStatus,
    );

    _registrarAuditoria(
      'Anúncio alterado para ${novoStatus.name}',
      anterior.titulo,
    );
    notifyListeners();
  }

  // ======================================
  // DENÚNCIAS
  // ======================================

  final List<DenunciaAdminDemo> _denuncias = [
    const DenunciaAdminDemo(
      id: 1,
      negocioId: 2,
      motivo: 'Conteúdo inadequado',
      comentario: 'Avaliação de teste denunciada.',
      status: StatusDenunciaAdmin.pendente,
    ),
    const DenunciaAdminDemo(
      id: 2,
      negocioId: 3,
      motivo: 'Informação incorreta',
      comentario: 'Comentário fictício para moderação.',
      status: StatusDenunciaAdmin.pendente,
    ),
    const DenunciaAdminDemo(
      id: 3,
      negocioId: 1,
      motivo: 'Possível spam',
      comentario: 'Caso demonstrativo já analisado.',
      status: StatusDenunciaAdmin.analisada,
    ),
    const DenunciaAdminDemo(
      id: 4,
      negocioId: 4,
      motivo: 'Conteúdo repetido',
      comentario: 'Caso fictício arquivado.',
      status: StatusDenunciaAdmin.arquivada,
    ),
  ];

  List<DenunciaAdminDemo> get denuncias =>
      List.unmodifiable(_denuncias);

  int get denunciasPendentes => _denuncias.where(
        (d) => d.status == StatusDenunciaAdmin.pendente,
  ).length;

  void alterarStatusDenuncia(
      int id,
      StatusDenunciaAdmin novoStatus,
      ) {
    final index = _denuncias.indexWhere((d) => d.id == id);
    if (index < 0) {
      throw StateError('Denúncia não encontrada.');
    }

    final anterior = _denuncias[index];
    if (anterior.status == novoStatus) return;

    _denuncias[index] = anterior.copyWith(
      status: novoStatus,
    );

    _registrarAuditoria(
      'Denúncia alterada para ${novoStatus.name}',
      'Denúncia #$id',
    );
    notifyListeners();
  }

  // ======================================
  // ATIVIDADE FICTÍCIA
  // ======================================

  late final List<AtividadeAdminDemo> _atividade =
  List.generate(14, (indice) {
    final dia = DateTime.now().subtract(
      Duration(days: 13 - indice),
    );

    return AtividadeAdminDemo(
      data: '${dia.day.toString().padLeft(2, '0')}/'
          '${dia.month.toString().padLeft(2, '0')}',
      visualizacoes: 12 + (indice * 3) % 17,
      contatos: 2 + indice % 6,
      rotas: 1 + indice % 4,
    );
  });

  List<AtividadeAdminDemo> get atividade =>
      List.unmodifiable(_atividade);

  // ======================================
  // AUDITORIA
  // ======================================

  int _proximoLogId = 3;

  final List<RegistroAuditoriaAdminDemo> _auditoria = [
    RegistroAuditoriaAdminDemo(
      id: 2,
      acao: 'Anúncio demonstrativo cadastrado',
      entidade: 'Ofertas do mercado',
      data: DateTime.now().subtract(
        const Duration(hours: 4),
      ),
    ),
    RegistroAuditoriaAdminDemo(
      id: 1,
      acao: 'Negócio fictício cadastrado',
      entidade: 'Café da Praça',
      data: DateTime.now().subtract(
        const Duration(days: 1),
      ),
    ),
  ];

  List<RegistroAuditoriaAdminDemo> get auditoria =>
      List.unmodifiable(_auditoria);

  void _registrarAuditoria(String acao, String entidade) {
    _auditoria.insert(
      0,
      RegistroAuditoriaAdminDemo(
        id: _proximoLogId++,
        acao: acao,
        entidade: entidade,
        data: DateTime.now(),
      ),
    );
  }
}
