
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
  // ETAPA 6 - ADMINISTRAÇÃO COMPARTILHADA
  // ==========================================

  final AdminDemoState administracao = AdminDemoState();

  AppSession() {
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
  // ETAPA 6 - CATÁLOGO PÚBLICO
  // ==========================================

  List<Estabelecimento> get estabelecimentosPublicos {
    final todos = <Estabelecimento>[
      ...estabelecimentosMock,
      ..._negocios.map(_converterEstabelecimento),
    ];

    return List.unmodifiable(
      todos.where(
            (estabelecimento) =>
            administracao.negocioVisivel(
              estabelecimento.id,
            ),
      ),
    );
  }

  bool negocioDisponivelPublicamente(int id) {
    return administracao.negocioVisivel(id);
  }

  bool ehNegocioLocal(int id) {
    return _negocios.any(
          (negocio) => negocio.id == id,
    );
  }

  Estabelecimento? estabelecimentoPorId(int id) {
    for (final estabelecimento in estabelecimentosMock) {
      if (estabelecimento.id == id) {
        return estabelecimento;
      }
    }

    for (final negocio in _negocios) {
      if (negocio.id == id) {
        return _converterEstabelecimento(negocio);
      }
    }

    return null;
  }

  DetalhesEstabelecimento? detalhesPorId(int id) {
    final negocio = negocioPorId(id);

    if (negocio != null) {
      return DetalhesEstabelecimento(
        endereco: negocio.endereco,
        uf: negocio.uf,
        horarios: [negocio.horarios],
        ofertas: negocio.ofertas,
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
  // ETAPA 4 - CONTAS DEMONSTRATIVAS
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

  // ==========================================
  // ETAPA 7 - FAVORITOS POR CONTA
  // ==========================================

  String _chaveContaFavoritos = 'visitante';

  final Map<String, Set<int>> _favoritosPorConta = {
    'visitante': <int>{},
  };

  Set<int> get _favoritosAtuais {
    return _favoritosPorConta.putIfAbsent(
      _chaveContaFavoritos,
          () => <int>{},
    );
  }

  Set<int> get favoritos {
    return Set.unmodifiable(_favoritosAtuais);
  }

  bool isFavorite(int id) {
    return _favoritosAtuais.contains(id);
  }

  void toggleFavorite(int id) {
    final favoritosDaConta = _favoritosAtuais;

    if (!favoritosDaConta.remove(id)) {
      favoritosDaConta.add(id);
    }

    notifyListeners();
  }

  void removerFavorito(int id) {
    if (_favoritosAtuais.remove(id)) {
      notifyListeners();
    }
  }

  // ==========================================
  // ETAPA 4/7 - ENTRAR E SAIR
  // ==========================================

  void iniciarContaDemo(ContaDemo conta) {
    _tipoAcesso = conta.tipo;

    // Não utiliza o e-mail editável do perfil.
    // A chave permanece estável durante o teste.
    _chaveContaFavoritos =
        conta.email.trim().toLowerCase();

    _perfil = UsuarioPerfil(
      nome: conta.nome,
      email: conta.email,
      telefone: conta.telefone,
    );

    // Prepara o exemplo comercial apenas uma vez.
    if (ehComerciante && _negocios.isEmpty) {
      _prepararExemploComerciante();
    }

    notifyListeners();
  }

  void entrarComoVisitante() {
    _tipoAcesso = TipoAcessoDemo.visitante;
    _chaveContaFavoritos = 'visitante';

    _perfil = const UsuarioPerfil(
      nome: 'Visitante',
      email: 'Sem conta selecionada',
      telefone: '',
    );

    // Não apagamos favoritos ou cadastros.
    notifyListeners();
  }

  void encerrarAcesso() {
    entrarComoVisitante();
  }

  void atualizarPerfil(UsuarioPerfil novoPerfil) {
    _perfil = novoPerfil;
    notifyListeners();
  }

  // ==========================================
  // ETAPA 7 - PREFERÊNCIAS
  // ==========================================

  bool _mostrarDicas = true;
  bool _confirmarAoSair = true;

  bool get mostrarDicas => _mostrarDicas;
  bool get confirmarAoSair => _confirmarAoSair;

  void definirMostrarDicas(bool valor) {
    if (_mostrarDicas == valor) return;

    _mostrarDicas = valor;
    notifyListeners();
  }

  void definirConfirmarAoSair(bool valor) {
    if (_confirmarAoSair == valor) return;

    _confirmarAoSair = valor;
    notifyListeners();
  }

  void restaurarPreferencias() {
    _mostrarDicas = true;
    _confirmarAoSair = true;
    notifyListeners();
  }

  // ==========================================
  // ETAPA 5 - NEGÓCIOS DO COMERCIANTE
  // ==========================================

  final List<NegocioDemo> _negocios = [];
  final List<VendaDemo> _vendas = [];
  final Set<int> _rascunhosAnuncios = {};

  int _proximoNegocioId = 100;
  int _proximaOfertaId = 1000;
  int _proximaVendaId = 1;

  List<NegocioDemo> get negocios {
    if (ehVisitante) {
      return const [];
    }

    return List.unmodifiable(_negocios);
  }

  List<VendaDemo> vendasDoNegocio(int negocioId) {
    return List.unmodifiable(
      _vendas.where(
            (venda) => venda.negocioId == negocioId,
      ),
    );
  }

  NegocioDemo? negocioPorId(int id) {
    for (final negocio in _negocios) {
      if (negocio.id == id) {
        return negocio;
      }
    }

    return null;
  }

  int cadastrarNegocio(NegocioDemo novo) {
    final id = _proximoNegocioId++;

    final salvo = novo.copyWith(id: id);

    _negocios.add(salvo);

    administracao.sincronizarNegocioComerciante(
      salvo,
    );

    notifyListeners();

    return id;
  }

  void atualizarNegocio(NegocioDemo negocio) {
    final index = _negocios.indexWhere(
          (item) => item.id == negocio.id,
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
    _negocios.removeWhere(
          (negocio) => negocio.id == id,
    );

    _vendas.removeWhere(
          (venda) => venda.negocioId == id,
    );

    _rascunhosAnuncios.remove(id);

    administracao.removerNegocioComerciante(id);

    notifyListeners();
  }

  // ==========================================
  // ETAPA 5 - PRODUTOS E SERVIÇOS
  // ==========================================

  void salvarOferta(int negocioId, Oferta oferta) {
    final negocio = negocioPorId(negocioId);

    if (negocio == null) {
      throw StateError('Negócio não encontrado.');
    }

    final ofertas = List<Oferta>.from(
      negocio.ofertas,
    );

    final index = ofertas.indexWhere(
          (item) => item.id == oferta.id,
    );

    if (index >= 0) {
      ofertas[index] = oferta;
    } else {
      ofertas.add(
        oferta.copyWith(
          id: _proximaOfertaId++,
        ),
      );
    }

    atualizarNegocio(
      negocio.copyWith(ofertas: ofertas),
    );
  }

  void excluirOferta(
      int negocioId,
      int ofertaId,
      ) {
    final negocio = negocioPorId(negocioId);

    if (negocio == null) return;

    final ofertas = negocio.ofertas
        .where(
          (oferta) => oferta.id != ofertaId,
    )
        .toList();

    substituirOfertas(negocioId, ofertas);
  }

  void alterarStatusOferta(
      int negocioId,
      int ofertaId,
      ) {
    final negocio = negocioPorId(negocioId);

    if (negocio == null) return;

    final ofertas = negocio.ofertas.map((oferta) {
      if (oferta.id == ofertaId) {
        return oferta.copyWith(
          ativo: !oferta.ativo,
        );
      }

      return oferta;
    }).toList();

    substituirOfertas(negocioId, ofertas);
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
  // ETAPA 5 - VENDAS
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
          (item) => item.id == ofertaId,
      orElse: () => throw StateError(
        'Oferta não encontrada.',
      ),
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

      final ofertas = negocio.ofertas.map((item) {
        if (item.id == ofertaId) {
          return item.copyWith(
            estoque: estoque - quantidade,
          );
        }

        return item;
      }).toList();

      substituirOfertas(negocioId, ofertas);
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

  double receitaDemo(int negocioId) {
    return vendasDoNegocio(negocioId).fold<double>(
      0,
          (total, venda) => total + venda.total,
    );
  }

  // ==========================================
  // ETAPA 5 - ANÚNCIOS EM PRÉVIA
  // ==========================================

  bool anuncioEmPrevia(int negocioId) {
    return _rascunhosAnuncios.contains(negocioId);
  }

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

    const negocio = NegocioDemo(
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
          descricao: 'Cabo para carregamento.',
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
          descricao: 'Avaliação inicial do aparelho.',
          preco: 40,
        ),
      ],
    );

    _negocios.add(negocio);

    _proximoNegocioId = 101;
    _proximaOfertaId = 1003;

    administracao.sincronizarNegocioComerciante(
      negocio,
    );

    // Simula uma venda de duas unidades.
    registrarVenda(negocioId, 1000, 2);
  }
}
