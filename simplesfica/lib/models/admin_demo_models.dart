
import 'detalhes_estabelecimento.dart';

enum StatusNegocioAdmin {
  ativo,
  suspenso,
  inativo,
}

enum StatusUsuarioAdmin {
  ativo,
  inativo,
  suspenso,
  bloqueado,
}

enum StatusPagamentoAdmin {
  aprovado,
  pendente,
  vencido,
}

enum StatusAnuncioAdmin {
  ativo,
  pausado,
}

enum StatusDenunciaAdmin {
  pendente,
  analisada,
  arquivada,
}

class NegocioAdminDemo {
  final int id;
  final String nome;
  final String cidade;
  final String categoria;
  final StatusNegocioAdmin status;

  // Indica se o cadastro foi disponibilizado
  // no catálogo público da demonstração.
  final bool publicado;

  // Classificação calculada pelas ofertas ativas.
  final TipoAtuacao tipoAtuacao;

  const NegocioAdminDemo({
    required this.id,
    required this.nome,
    required this.cidade,
    required this.categoria,
    required this.status,
    this.publicado = true,
    this.tipoAtuacao = TipoAtuacao.semOfertas,
  });

  bool get visivelPublicamente =>
      publicado && status == StatusNegocioAdmin.ativo;

  NegocioAdminDemo copyWith({
    String? nome,
    String? cidade,
    String? categoria,
    StatusNegocioAdmin? status,
    bool? publicado,
    TipoAtuacao? tipoAtuacao,
  }) {
    return NegocioAdminDemo(
      id: id,
      nome: nome ?? this.nome,
      cidade: cidade ?? this.cidade,
      categoria: categoria ?? this.categoria,
      status: status ?? this.status,
      publicado: publicado ?? this.publicado,
      tipoAtuacao: tipoAtuacao ?? this.tipoAtuacao,
    );
  }
}

class UsuarioAdminDemo {
  final int id;
  final String nome;
  final String email;
  final String perfil;
  final StatusUsuarioAdmin status;

  const UsuarioAdminDemo({
    required this.id,
    required this.nome,
    required this.email,
    required this.perfil,
    required this.status,
  });

  UsuarioAdminDemo copyWith({
    StatusUsuarioAdmin? status,
  }) {
    return UsuarioAdminDemo(
      id: id,
      nome: nome,
      email: email,
      perfil: perfil,
      status: status ?? this.status,
    );
  }
}

class PagamentoAdminDemo {
  final int id;
  final int negocioId;
  final String descricao;
  final double valor;
  final StatusPagamentoAdmin status;

  const PagamentoAdminDemo({
    required this.id,
    required this.negocioId,
    required this.descricao,
    required this.valor,
    required this.status,
  });
}

class AnuncioAdminDemo {
  final int id;
  final int negocioId;
  final String titulo;
  final StatusAnuncioAdmin status;

  const AnuncioAdminDemo({
    required this.id,
    required this.negocioId,
    required this.titulo,
    required this.status,
  });

  AnuncioAdminDemo copyWith({
    StatusAnuncioAdmin? status,
  }) {
    return AnuncioAdminDemo(
      id: id,
      negocioId: negocioId,
      titulo: titulo,
      status: status ?? this.status,
    );
  }
}

class DenunciaAdminDemo {
  final int id;
  final int negocioId;
  final String motivo;
  final String comentario;
  final StatusDenunciaAdmin status;

  const DenunciaAdminDemo({
    required this.id,
    required this.negocioId,
    required this.motivo,
    required this.comentario,
    required this.status,
  });

  DenunciaAdminDemo copyWith({
    StatusDenunciaAdmin? status,
  }) {
    return DenunciaAdminDemo(
      id: id,
      negocioId: negocioId,
      motivo: motivo,
      comentario: comentario,
      status: status ?? this.status,
    );
  }
}

class RegistroAuditoriaAdminDemo {
  final int id;
  final String acao;
  final String entidade;
  final DateTime data;

  const RegistroAuditoriaAdminDemo({
    required this.id,
    required this.acao,
    required this.entidade,
    required this.data,
  });
}

class AtividadeAdminDemo {
  final String data;
  final int visualizacoes;
  final int contatos;
  final int rotas;

  const AtividadeAdminDemo({
    required this.data,
    required this.visualizacoes,
    required this.contatos,
    required this.rotas,
  });

  int get total => visualizacoes + contatos + rotas;
}
