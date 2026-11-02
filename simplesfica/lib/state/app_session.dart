
import 'package:flutter/foundation.dart';

import '../data/detalhes_mock.dart';
import '../data/estabelecimentos_mock.dart';

import '../models/conta_demo.dart';
import '../models/detalhes_estabelecimento.dart';
import '../models/estabelecimento.dart';
import '../models/negocio_demo.dart';
import '../models/oferta.dart';
import '../models/usuario_perfil.dart';

import 'admin_demo_state.dart';

class AppSession extends ChangeNotifier {
  // ==========================================
  // ESTADO ADMINISTRATIVO COMPARTILHADO
  // ==========================================

  final AdminDemoState administracao = AdminDemoState();

  AppSession() {
    // Faz Home, Explorar, Favoritos e Perfil
    // reagirem às alterações administrativas.
    administracao.addListener(_avisarAlteracoes);
  }

  void _avisarAlteracoes() {
    notifyListeners();
  }

  @override
  void dispose() {
    administracao.removeListener(_avisarAlteracoes);
    administracao.dispose();
    super.dispose();
  }

  // ==========================================
  // CONSULTAS DO CATÁLOGO PÚBLICO
  // ==========================================

  // Inclui os mocks e negócios locais publicados.
  List<Estabelecimento> get estabelecimentosPublicos {
    final todos = [
      ...estabelecimentosMock,
      ..._negocios.map(_converterEstabelecimento),
    ];

    return List.unmodifiable(
      todos.where(
            (e) => administracao.negocioVisivel(e.id),
      ),
    );
  }

  bool negocioDisponivelPublicamente(int id) =>
      administracao.negocioVisivel(id);

  bool ehNegocioLocal(int id) =>
      _negocios.any((n) => n.id == id);

  Estabelecimento? estabelecimentoPorId(int id) {
    for (final e in estabelecimentosMock) {
      if (e.id == id) return e;
    }

    for (final n in _negocios) {
      if (n.id == id) {
        return _converterEstabelecimento(n);
      }
    }

    return null;
  }

  DetalhesEstabelecimento? detalhesPorId(int id) {
    final local = negocioPorId(id);

    if (local != null) {
      return DetalhesEstabelecimento(
        endereco: local.endereco,
        uf: local.uf,
        horarios: [local.horarios],
        ofertas: local.ofertas,
        avaliacoes: const [],
      );
    }

    return detalhesMock[id];
  }

  Estabelecimento _converterEstabelecimento(
      NegocioDemo negocio,
      ) {
    return Estabelecimento(
      id: negocio.id,
      nome: negocio.nome,
      descricao: negocio.descricao,
      categoria: negocio.categoria,
      cidade: negocio.cidade,
      bairro: negocio.bairro,
      telefone: negocio.telefone,
      avaliacao: 0,
      totalAvaliacoes: 0,
      distanciaKm: 0,
      aberto: false,
    );
  }

  // ==========================================
  // CONTAS DE TESTE
  // ==========================================

  TipoAcessoDemo _tipoAcesso =
      TipoAcessoDemo.visitante;

  TipoAcessoDemo get tipoAcesso => _tipoAcesso;

  bool get ehVisitante =>
      _tipoAcesso == TipoAcessoDemo.visitante;

  bool get ehComerciante =>
      _tipoAcesso == TipoAcessoDemo.comerciante;

  bool get ehAdministrador =>
      _tipoAcesso == TipoAcessoDemo.administrador;

  UsuarioPerfil _perfil = const UsuarioPerfil(
    nome: 'Visitante',
    email: 'Sem conta selecionada',
    telefone: '',
  );

  UsuarioPerfil get perfil => _perfil;

  void iniciarContaDemo(ContaDemo conta) {
    _favoritos.clear();

    _tipoAcesso = conta.tipo;
    _perfil = UsuarioPerfil(
      nome: conta.nome,
      email: conta.email,
      telefone: conta.telefone,
    );

    if (ehComerciante && _negocios.isEmpty) {
      _prepararExemploComerciante();
    }

    notifyListeners();
  }

  void entrarComoVisitante() {
    _favoritos.clear();
    _tipoAcesso = TipoAcessoDemo.visitante;
    _perfil = const UsuarioPerfil(
      nome: 'Visitante',
      email: 'Sem conta selecionada',
      telefone: '',
    );
    notifyListeners();
  }

  void encerrarAcesso() {
    entrarComoVisitante();
  }

  // ==========================================
  // FAVORITOS
  // ==========================================

  final Set<int> _favoritos = {};

  Set<int> get favoritos =>
      Set.unmodifiable(_favoritos);

  bool isFavorite(int id) =>
      _favoritos.contains(id);

  void toggleFavorite(int id) {
    if (!_favoritos.remove(id)) {
      _favoritos.add(id);
    }
    notifyListeners();
  }

  void removerFavorito(int id) {
    if (_favoritos.remove(id)) {
      notifyListeners();
    }
  }

  void atualizarPerfil(UsuarioPerfil novoPerfil) {
    _perfil = novoPerfil;
    notifyListeners();
  }

  // ==========================================
  // NEGÓCIOS DO COMERCIANTE
  // ==========================================

  final List<NegocioDemo> _negocios = [];
  final List<VendaDemo> _vendas = [];
  final Set<int> _rascunhosAnuncios = {};

  int _proximoNegocioId = 100;
  int _proximaOfertaId = 1000;
  int _proximaVendaId = 1;

  // O painel do comerciante vê seus próprios
  // negócios. O estado administrativo mantém
  // a listagem global de cadastros.
  List<NegocioDemo> get negocios =>
      ehVisitante
          ? const []
          : List.unmodifiable(_negocios);

  List<VendaDemo> vendasDoNegocio(int negocioId) =>
      List.unmodifiable(
        _vendas.where((v) => v.negocioId == negocioId),
      );

  NegocioDemo? negocioPorId(int id) {
    for (final n in _negocios) {
      if (n.id == id) return n;
    }
    return null;
  }

  int cadastrarNegocio(NegocioDemo novo) {
    final id = _proximoNegocioId++;
    final salvo = novo.copyWith(id: id);

    _negocios.add(salvo);
    administracao.sincronizarNegocioComerciante(salvo);

    notifyListeners();
    return id;
  }

  void atualizarNegocio(NegocioDemo negocio) {
    final index = _negocios.indexWhere(
          (n) => n.id == negocio.id,
    );

    if (index < 0) {
      throw StateError('Negócio não encontrado.');
    }

    _negocios[index] = negocio.copyWith();

    administracao.sincronizarNegocioComerciante(
      _negocios[index],
    );

    notifyListeners();
  }

  void removerNegocio(int id) {
    _negocios.removeWhere((n) => n.id == id);
    _vendas.removeWhere((v) => v.negocioId == id);
    _rascunhosAnuncios.remove(id);

    administracao.removerNegocioComerciante(id);
    notifyListeners();
  }

  // ==========================================
  // CATÁLOGO DE PRODUTOS E SERVIÇOS
  // ==========================================

  void salvarOferta(int negocioId, Oferta oferta) {
    final negocio = negocioPorId(negocioId);
    if (negocio == null) {
      throw StateError('Negócio não encontrado.');
    }

    final ofertas = List<Oferta>.from(negocio.ofertas);
    final index = ofertas.indexWhere(
          (o) => o.id == oferta.id,
    );

    if (index >= 0) {
      ofertas[index] = oferta;
    } else {
      ofertas.add(
        oferta.copyWith(id: _proximaOfertaId++),
      );
    }

    atualizarNegocio(
      negocio.copyWith(ofertas: ofertas),
    );
  }

  void excluirOferta(int negocioId, int ofertaId) {
    final negocio = negocioPorId(negocioId);
    if (negocio == null) return;

    substituirOfertas(
      negocioId,
      negocio.ofertas
          .where((o) => o.id != ofertaId)
          .toList(),
    );
  }

  void alterarStatusOferta(
      int negocioId,
      int ofertaId,
      ) {
    final negocio = negocioPorId(negocioId);
    if (negocio == null) return;

    substituirOfertas(
      negocioId,
      negocio.ofertas.map((o) {
        return o.id == ofertaId
            ? o.copyWith(ativo: !o.ativo)
            : o;
      }).toList(),
    );
  }

  void substituirOfertas(
      int negocioId,
      List<Oferta> ofertas,
      ) {
    final negocio = negocioPorId(negocioId);
    if (negocio == null) {
      throw StateError('Negócio não encontrado.');
    }

    atualizarNegocio(
      negocio.copyWith(ofertas: ofertas),
    );
  }

  // ==========================================
  // VENDAS DEMONSTRATIVAS
  // ==========================================

  void registrarVenda(
      int negocioId,
      int ofertaId,
      int quantidade,
      ) {
    if (quantidade <= 0) {
      throw StateError('Quantidade inválida.');
    }

    final negocio = negocioPorId(negocioId);
    if (negocio == null) {
      throw StateError('Negócio não encontrado.');
    }

    final oferta = negocio.ofertas.firstWhere(
          (o) => o.id == ofertaId,
      orElse: () =>
      throw StateError('Oferta não encontrada.'),
    );

    if (!oferta.ativo) {
      throw StateError('Oferta desativada.');
    }

    if (oferta.preco == null || oferta.preco! <= 0) {
      throw StateError('Defina um preço válido.');
    }

    if (oferta.tipo == TipoOferta.produto) {
      final estoque = oferta.estoque ?? 0;
      if (quantidade > estoque) {
        throw StateError('Estoque insuficiente.');
      }

      substituirOfertas(
        negocioId,
        negocio.ofertas.map((o) {
          return o.id == ofertaId
              ? o.copyWith(estoque: estoque - quantidade)
              : o;
        }).toList(),
      );
    }

    _vendas.insert(
      0,
      VendaDemo(
        id: _proximaVendaId++,
        negocioId: negocioId,
        ofertaId: ofertaId,
        nomeOferta: oferta.nome,
        quantidade: quantidade,
        precoUnitario: oferta.preco!,
        data: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  double receitaDemo(int negocioId) =>
      vendasDoNegocio(negocioId).fold<double>(
        0,
            (total, venda) => total + venda.total,
      );

  // ==========================================
  // PRÉVIAS DE ANÚNCIOS DO COMERCIANTE
  // ==========================================

  bool anuncioEmPrevia(int negocioId) =>
      _rascunhosAnuncios.contains(negocioId);

  void alternarPreviaAnuncio(int negocioId) {
    if (!_rascunhosAnuncios.remove(negocioId)) {
      _rascunhosAnuncios.add(negocioId);
    }
    notifyListeners();
  }

  // ==========================================
  // CENÁRIO INICIAL DO COMERCIANTE
  // ==========================================

  void _prepararExemploComerciante() {
    const negocioId = 100;

    final negocio = const NegocioDemo(
      id: negocioId,
      nome: 'Tech Cell — Demonstração',
      descricao:
      'Loja fictícia de acessórios e '
          'assistência técnica de celulares.',
      categoria: 'Tecnologia',
      cidade: 'Rio Verde',
      bairro: 'Centro',
      uf: 'GO',
      endereco: 'Rua de Exemplo, 100',
      telefone: '(64) 99999-2000',
      horarios: 'Segunda a sexta: 09h às 18h',
      ofertas: [
        Oferta(
          id: 1000,
          tipo: TipoOferta.produto,
          nome: 'Cabo USB-C',
          descricao: 'Cabo de carregamento.',
          preco: 29.90,
          estoque: 12,
          destaque: true,
        ),
        Oferta(
          id: 1001,
          tipo: TipoOferta.produto,
          nome: 'Capinha protetora',
          descricao: 'Capinha para celular.',
          preco: 35,
          estoque: 8,
        ),
        Oferta(
          id: 1002,
          tipo: TipoOferta.servico,
          nome: 'Diagnóstico de celular',
          descricao: 'Avaliação inicial.',
          preco: 40,
        ),
      ],
    );

    _negocios.add(negocio);
    _proximoNegocioId = 101;
    _proximaOfertaId = 1003;

    administracao.sincronizarNegocioComerciante(negocio);

    // Venda de teste: estoque de 12 para 10.
    registrarVenda(negocioId, 1000, 2);
  }
}
