
import 'oferta.dart';

enum TipoAtuacao {
  semOfertas,
  produtos,
  servicos,
  ambos,
}

extension TipoAtuacaoDescricao on TipoAtuacao {
  String get rotulo {
    switch (this) {
      case TipoAtuacao.semOfertas:
        return 'Sem ofertas';
      case TipoAtuacao.produtos:
        return 'Comerciante';
      case TipoAtuacao.servicos:
        return 'Prestador de serviços';
      case TipoAtuacao.ambos:
        return 'Produtos e serviços';
    }
  }
}

class Avaliacao {
  final String autor;
  final int nota;
  final String comentario;

  const Avaliacao({
    required this.autor,
    required this.nota,
    required this.comentario,
  });
}

class DetalhesEstabelecimento {
  final String endereco;
  final String uf;
  final List<String> horarios;
  final List<Oferta> ofertas;
  final List<Avaliacao> avaliacoes;

  const DetalhesEstabelecimento({
    required this.endereco,
    required this.uf,
    required this.horarios,
    required this.ofertas,
    required this.avaliacoes,
  });

  List<Oferta> get produtosAtivos {
    return ofertas.where((oferta) {
      return oferta.ativo &&
          oferta.tipo == TipoOferta.produto;
    }).toList();
  }

  List<Oferta> get servicosAtivos {
    return ofertas.where((oferta) {
      return oferta.ativo &&
          oferta.tipo == TipoOferta.servico;
    }).toList();
  }

  TipoAtuacao get tipoAtuacao {
    final temProdutos = produtosAtivos.isNotEmpty;
    final temServicos = servicosAtivos.isNotEmpty;

    if (temProdutos && temServicos) {
      return TipoAtuacao.ambos;
    }

    if (temProdutos) {
      return TipoAtuacao.produtos;
    }

    if (temServicos) {
      return TipoAtuacao.servicos;
    }

    return TipoAtuacao.semOfertas;
  }
}
