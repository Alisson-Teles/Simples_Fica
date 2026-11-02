class Estabelecimento {
  final int id;
  final String nome;
  final String descricao;
  final String categoria;
  final String cidade;
  final String bairro;
  final String telefone;
  final double avaliacao;
  final int totalAvaliacoes;
  final double distanciaKm;
  final bool aberto;

  const Estabelecimento({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.categoria,
    required this.cidade,
    required this.bairro,
    required this.telefone,
    required this.avaliacao,
    required this.totalAvaliacoes,
    required this.distanciaKm,
    required this.aberto,
  });
}