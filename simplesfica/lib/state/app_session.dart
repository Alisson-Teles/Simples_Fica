import 'package:flutter/foundation.dart';

import '../models/negocio_demo.dart';
import '../models/oferta.dart';
import '../models/usuario_perfil.dart';

class AppSession extends ChangeNotifier {
  // Estado da Etapa 3: favoritos e perfil demonstrativo.
  final Set<int> _favoritos = <int>{};
  Set<int> get favoritos => Set.unmodifiable(_favoritos);

  bool isFavorite(int id) => _favoritos.contains(id);

  void toggleFavorite(int id) {
    if (!_favoritos.remove(id)) _favoritos.add(id);
    notifyListeners();
  }

  void removerFavorito(int id) {
    if (_favoritos.remove(id)) notifyListeners();
  }

  UsuarioPerfil _perfil = const UsuarioPerfil(
    nome: 'Usuário de teste',
    email: 'usuario@exemplo.com',
    telefone: '(64) 99999-0000',
  );
  UsuarioPerfil get perfil => _perfil;

  void atualizarPerfil(UsuarioPerfil novoPerfil) {
    _perfil = novoPerfil;
    notifyListeners();
  }

  // Etapa 5: catálogo e vendas APENAS NA MEMÓRIA.
  final List<NegocioDemo> _negocios = [];
  final List<VendaDemo> _vendas = [];
  final Set<int> _rascunhosAnuncios = {};
  int _proximoNegocioId = 100;
  int _proximaOfertaId = 1000;
  int _proximaVendaId = 1;

  List<NegocioDemo> get negocios => List.unmodifiable(_negocios);
  List<VendaDemo> vendasDoNegocio(int negocioId) => List.unmodifiable(
    _vendas.where((venda) => venda.negocioId == negocioId),
  );

  NegocioDemo? negocioPorId(int id) {
    for (final negocio in _negocios) {
      if (negocio.id == id) return negocio;
    }
    return null;
  }

  int cadastrarNegocio(NegocioDemo novo) {
    final id = _proximoNegocioId++;
    _negocios.add(novo.copyWith(id: id));
    notifyListeners();
    return id;
  }

  void atualizarNegocio(NegocioDemo negocio) {
    final index = _negocios.indexWhere((n) => n.id == negocio.id);
    if (index < 0) throw StateError('Negócio não encontrado.');
    _negocios[index] = negocio.copyWith();
    notifyListeners();
  }

  void removerNegocio(int id) {
    _negocios.removeWhere((n) => n.id == id);
    _vendas.removeWhere((v) => v.negocioId == id);
    _rascunhosAnuncios.remove(id);
    notifyListeners();
  }

  void salvarOferta(int negocioId, Oferta oferta) {
    final negocio = negocioPorId(negocioId);
    if (negocio == null) throw StateError('Negócio não encontrado.');
    final ofertas = List<Oferta>.from(negocio.ofertas);
    final index = ofertas.indexWhere((o) => o.id == oferta.id);
    if (index >= 0) {
      ofertas[index] = oferta;
    } else {
      ofertas.add(oferta.copyWith(id: _proximaOfertaId++));
    }
    atualizarNegocio(negocio.copyWith(ofertas: ofertas));
  }

  void excluirOferta(int negocioId, int ofertaId) {
    final negocio = negocioPorId(negocioId);
    if (negocio == null) return;
    final ofertas = negocio.ofertas.where((o) => o.id != ofertaId).toList();
    substituirOfertas(negocioId, ofertas);
  }

  void alterarStatusOferta(int negocioId, int ofertaId) {
    final negocio = negocioPorId(negocioId);
    if (negocio == null) return;
    final ofertas = negocio.ofertas.map((o) {
      return o.id == ofertaId ? o.copyWith(ativo: !o.ativo) : o;
    }).toList();
    substituirOfertas(negocioId, ofertas);
  }

  void substituirOfertas(int negocioId, List<Oferta> ofertas) {
    final index = _negocios.indexWhere((n) => n.id == negocioId);
    if (index < 0) throw StateError('Negócio não encontrado.');
    _negocios[index] = _negocios[index].copyWith(ofertas: ofertas);
    notifyListeners();
  }

  // Se for produto, uma venda de teste reduz o estoque disponível.
  void registrarVenda(int negocioId, int ofertaId, int quantidade) {
    if (quantidade <= 0) throw StateError('Quantidade inválida.');
    final negocio = negocioPorId(negocioId);
    if (negocio == null) throw StateError('Negócio não encontrado.');
    final oferta = negocio.ofertas.firstWhere((o) => o.id == ofertaId);
    if (!oferta.ativo) throw StateError('Oferta desativada.');
    if (oferta.preco == null || oferta.preco! <= 0) {
      throw StateError('Defina um preço para registrar a venda.');
    }
    if (oferta.tipo == TipoOferta.produto) {
      final estoque = oferta.estoque ?? 0;
      if (quantidade > estoque) throw StateError('Estoque insuficiente.');
      final ofertas = negocio.ofertas.map((o) {
        return o.id == ofertaId
            ? o.copyWith(estoque: estoque - quantidade)
            : o;
      }).toList();
      substituirOfertas(negocioId, ofertas);
    }
    _vendas.insert(0, VendaDemo(
      id: _proximaVendaId++,
      negocioId: negocioId,
      ofertaId: ofertaId,
      nomeOferta: oferta.nome,
      quantidade: quantidade,
      precoUnitario: oferta.preco!,
      data: DateTime.now(),
    ));
    notifyListeners();
  }

  double receitaDemo(int negocioId) => vendasDoNegocio(negocioId)
      .fold<double>(0, (total, venda) => total + venda.total);

  bool anuncioEmPrevia(int negocioId) => _rascunhosAnuncios.contains(negocioId);

  void alternarPreviaAnuncio(int negocioId) {
    if (!_rascunhosAnuncios.remove(negocioId)) {
      _rascunhosAnuncios.add(negocioId);
    }
    notifyListeners();
  }
}