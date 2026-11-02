import 'detalhes_estabelecimento.dart';
import 'oferta.dart';

class NegocioDemo {
  final int id;
  final String nome;
  final String descricao;
  final String categoria;
  final String cidade;
  final String bairro;
  final String uf;
  final String endereco;
  final String telefone;
  final String horarios;
  final String? imagemUrl;
  final List<Oferta> ofertas;

  const NegocioDemo({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.categoria,
    required this.cidade,
    required this.bairro,
    required this.uf,
    required this.endereco,
    required this.telefone,
    required this.horarios,
    this.imagemUrl,
    this.ofertas = const [],
  });

  TipoAtuacao get tipoAtuacao => classificarOfertas(ofertas);

  NegocioDemo copyWith({
    int? id,
    String? nome,
    String? descricao,
    String? categoria,
    String? cidade,
    String? bairro,
    String? uf,
    String? endereco,
    String? telefone,
    String? horarios,
    String? imagemUrl,
    List<Oferta>? ofertas,
  }) {
    return NegocioDemo(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      categoria: categoria ?? this.categoria,
      cidade: cidade ?? this.cidade,
      bairro: bairro ?? this.bairro,
      uf: uf ?? this.uf,
      endereco: endereco ?? this.endereco,
      telefone: telefone ?? this.telefone,
      horarios: horarios ?? this.horarios,
      imagemUrl: imagemUrl ?? this.imagemUrl,
      ofertas: List<Oferta>.unmodifiable(ofertas ?? this.ofertas),
    );
  }
}

class VendaDemo {
  final int id;
  final int negocioId;
  final int ofertaId;
  final String nomeOferta;
  final int quantidade;
  final double precoUnitario;
  final DateTime data;

  const VendaDemo({
    required this.id,
    required this.negocioId,
    required this.ofertaId,
    required this.nomeOferta,
    required this.quantidade,
    required this.precoUnitario,
    required this.data,
  });

  double get total => quantidade * precoUnitario;
}