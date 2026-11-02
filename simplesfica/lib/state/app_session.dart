
import 'package:flutter/foundation.dart';

import '../models/conta_demo.dart';
import '../models/negocio_demo.dart';
import '../models/oferta.dart';
import '../models/usuario_perfil.dart';

class AppSession extends ChangeNotifier {
  // ==========================================
  // ACESSO DEMONSTRATIVO
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
    // Limpa os dados de testes do acesso anterior.
    _limparDadosTemporarios();

    _tipoAcesso = conta.tipo;

    _perfil = UsuarioPerfil(
      nome: conta.nome,
      email: conta.email,
      telefone: conta.telefone,
    );

    // Fornece um cenário inicial para testar
    // a área do comerciante.
    if (ehComerciante) {
      _prepararExemploComerciante();
    }

    notifyListeners();
  }

  void entrarComoVisitante() {
    _limparDadosTemporarios();

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

  void _limparDadosTemporarios() {
    _favoritos.clear();
    _negocios.clear();
    _vendas.clear();
    _rascunhosAnuncios.clear();

    _proximoNegocioId = 100;
    _proximaOfertaId = 1000;
    _proximaVendaId = 1;
  }

  // ==========================================
  // ETAPA 3 - FAVORITOS
  // ==========================================

  final Set<int> _favoritos = <int>{};

  Set<int> get favoritos {
    return Set.unmodifiable(_favoritos);
  }

  bool isFavorite(int id) {
    return _favoritos.contains(id);
  }

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

  // ==========================================
  // ETAPA 3 - PERFIL
  // ==========================================

  void atualizarPerfil(UsuarioPerfil novoPerfil) {
    _perfil = novoPerfil;
    notifyListeners();
  }

  // ==========================================
  // ETAPA 5 - NEGÓCIOS
  // ==========================================

  final List<NegocioDemo> _negocios = [];
  final List<VendaDemo> _vendas = [];
  final Set<int> _rascunhosAnuncios = {};

  int _proximoNegocioId = 100;
  int _proximaOfertaId = 1000;
  int _proximaVendaId = 1;

  List<NegocioDemo> get negocios {
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

    _negocios.add(
      novo.copyWith(id: id),
    );

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

    notifyListeners();
  }

  void removerNegocio(int id) {
    _negocios.removeWhere(
          (n) => n.id == id,
    );

    _vendas.removeWhere(
          (venda) => venda.negocioId == id,
    );

    _rascunhosAnuncios.remove(id);

    notifyListeners();
  }

  // ==========================================
  // ETAPA 5 - CATÁLOGO
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
          (o) => o.id == oferta.id,
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

    final ofertas = negocio.ofertas.where(
          (o) => o.id != ofertaId,
    ).toList();

    substituirOfertas(negocioId, ofertas);
  }

  void alterarStatusOferta(
      int negocioId,
      int ofertaId,
      ) {
    final negocio = negocioPorId(negocioId);

    if (negocio == null) return;

    final ofertas = negocio.ofertas.map((o) {
      if (o.id == ofertaId) {
        return o.copyWith(ativo: !o.ativo);
      }

      return o;
    }).toList();

    substituirOfertas(negocioId, ofertas);
  }

  void substituirOfertas(
      int negocioId,
      List<Oferta> ofertas,
      ) {
    final index = _negocios.indexWhere(
          (n) => n.id == negocioId,
    );

    if (index < 0) {
      throw StateError('Negócio não encontrado.');
    }

    _negocios[index] = _negocios[index].copyWith(
      ofertas: ofertas,
    );

    notifyListeners();
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
          (o) => o.id == ofertaId,
      orElse: () => throw StateError(
        'Oferta não encontrada.',
      ),
    );

    if (!oferta.ativo) {
      throw StateError('Oferta desativada.');
    }

    if (oferta.preco == null ||
        oferta.preco! <= 0) {
      throw StateError(
        'Defina um preço para registrar a venda.',
      );
    }

    if (oferta.tipo == TipoOferta.produto) {
      final estoque = oferta.estoque ?? 0;

      if (quantidade > estoque) {
        throw StateError('Estoque insuficiente.');
      }

      final ofertas = negocio.ofertas.map((o) {
        if (o.id == ofertaId) {
          return o.copyWith(
            estoque: estoque - quantidade,
          );
        }

        return o;
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
  // ETAPA 5 - ANÚNCIOS
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
  // DADOS INICIAIS DO COMERCIANTE DE TESTE
  // ==========================================

  void _prepararExemploComerciante() {
    const negocioId = 100;

    _negocios.add(
      const NegocioDemo(
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
        horarios:
        'Segunda a sexta: 09h às 18h',
        ofertas: [
          Oferta(
            id: 1000,
            tipo: TipoOferta.produto,
            nome: 'Cabo USB-C',
            descricao:
            'Cabo para carregamento e '
                'transferência de dados.',
            preco: 29.90,
            estoque: 12,
            destaque: true,
          ),

          Oferta(
            id: 1001,
            tipo: TipoOferta.produto,
            nome: 'Capinha protetora',
            descricao:
            'Capinha para celulares.',
            preco: 35.00,
            estoque: 8,
          ),

          Oferta(
            id: 1002,
            tipo: TipoOferta.servico,
            nome: 'Diagnóstico de celular',
            descricao:
            'Avaliação inicial do aparelho.',
            preco: 40.00,
          ),
        ],
      ),
    );

    // Evita reutilizar IDs dos dados iniciais.
    _proximoNegocioId = 101;
    _proximaOfertaId = 1003;

    // Uma venda demonstrativa inicial.
    registrarVenda(
      negocioId,
      1000,
      2,
    );
  }
}
