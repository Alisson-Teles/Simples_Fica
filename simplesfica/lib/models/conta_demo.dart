
enum TipoAcessoDemo {
  visitante,
  cliente,
  comerciante,
  administrador,
}

extension TipoAcessoDemoDescricao on TipoAcessoDemo {
  String get titulo {
    switch (this) {
      case TipoAcessoDemo.visitante:
        return 'Visitante';

      case TipoAcessoDemo.cliente:
        return 'Cliente';

      case TipoAcessoDemo.comerciante:
        return 'Comerciante';

      case TipoAcessoDemo.administrador:
        return 'Administrador';
    }
  }
}

class ContaDemo {
  final String nome;
  final String email;
  final String senha;
  final String telefone;
  final TipoAcessoDemo tipo;

  const ContaDemo({
    required this.nome,
    required this.email,
    required this.senha,
    required this.telefone,
    required this.tipo,
  });
}
