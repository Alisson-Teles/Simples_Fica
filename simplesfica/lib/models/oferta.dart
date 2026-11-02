enum TipoOferta { produto, servico }

class Oferta {
  final int id;
  final TipoOferta tipo;
  final String nome;
  final String descricao;
  final double? preco;
  final double? precoAte;
  final int? estoque;
  final String? sku;
  final String unidade;
  final String? imagemUrl;
  final bool destaque;
  final bool ativo;

  const Oferta({
    required this.id,
    required this.tipo,
    required this.nome,
    required this.descricao,
    this.preco,
    this.precoAte,
    this.estoque,
    this.sku,
    this.unidade = 'un',
    this.imagemUrl,
    this.destaque = false,
    this.ativo = true,
  });

  Oferta copyWith({int? id, int? estoque, bool? ativo}) {
    return Oferta(
      id: id ?? this.id,
      tipo: tipo,
      nome: nome,
      descricao: descricao,
      preco: preco,
      precoAte: precoAte,
      estoque: estoque ?? this.estoque,
      sku: sku,
      unidade: unidade,
      imagemUrl: imagemUrl,
      destaque: destaque,
      ativo: ativo ?? this.ativo,
    );
  }
}