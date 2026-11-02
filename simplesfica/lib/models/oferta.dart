
enum TipoOferta {
  produto,
  servico,
}

class Oferta {
  final int id;
  final TipoOferta tipo;
  final String nome;
  final String descricao;
  final double? preco;
  final int? estoque;
  final bool destaque;
  final bool ativo;

  const Oferta({
    required this.id,
    required this.tipo,
    required this.nome,
    required this.descricao,
    this.preco,
    this.estoque,
    this.destaque = false,
    this.ativo = true,
  });
}
