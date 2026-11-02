
enum TipoConta {
  cliente,
  comerciante,
}

extension TipoContaDescricao on TipoConta {
  String get titulo {
    switch (this) {
      case TipoConta.cliente:
        return 'Cliente';

      case TipoConta.comerciante:
        return 'Comerciante';
    }
  }

  String get descricao {
    switch (this) {
      case TipoConta.cliente:
        return 'Encontre produtos e serviços, '
            'salve favoritos e avalie estabelecimentos.';

      case TipoConta.comerciante:
        return 'Divulgue seu estabelecimento, '
            'produtos e serviços na plataforma.';
    }
  }
}
