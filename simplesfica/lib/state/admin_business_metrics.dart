
import '../models/admin_demo_models.dart';
import '../models/detalhes_estabelecimento.dart';
import 'admin_demo_state.dart';

enum FiltroAtuacaoAdmin {
  todos,
  comAtuacao,
  somenteComerciantes,
  somentePrestadores,
  ambos,
  semOfertas,
}

extension FiltroAtuacaoAdminDescricao on FiltroAtuacaoAdmin {
  String get rotulo {
    switch (this) {
      case FiltroAtuacaoAdmin.todos:
        return 'Todos os estabelecimentos';
      case FiltroAtuacaoAdmin.comAtuacao:
        return 'Comerciantes / Prestadores';
      case FiltroAtuacaoAdmin.somenteComerciantes:
        return 'Somente comerciantes';
      case FiltroAtuacaoAdmin.somentePrestadores:
        return 'Somente prestadores';
      case FiltroAtuacaoAdmin.ambos:
        return 'Ambos (produtos e serviços)';
      case FiltroAtuacaoAdmin.semOfertas:
        return 'Sem ofertas ativas';
    }
  }
}

extension AdminBusinessMetrics on AdminDemoState {
  TipoAtuacao atuacaoDe(NegocioAdminDemo negocio) =>
      negocio.tipoAtuacao;

  int get totalComerciantesPrestadores => negocios
      .where((n) => n.tipoAtuacao != TipoAtuacao.semOfertas)
      .length;

  int get somenteComerciantes => negocios
      .where((n) => n.tipoAtuacao == TipoAtuacao.produtos)
      .length;

  int get somentePrestadores => negocios
      .where((n) => n.tipoAtuacao == TipoAtuacao.servicos)
      .length;

  int get comerciantesEPrestadores => negocios
      .where((n) => n.tipoAtuacao == TipoAtuacao.ambos)
      .length;

  int get negociosSemOfertas => negocios
      .where((n) => n.tipoAtuacao == TipoAtuacao.semOfertas)
      .length;

  int get comerciantesSuspensos => negocios.where(
        (n) =>
    n.status == StatusNegocioAdmin.suspenso &&
        n.tipoAtuacao == TipoAtuacao.produtos,
  ).length;

  int get prestadoresSuspensos => negocios.where(
        (n) =>
    n.status == StatusNegocioAdmin.suspenso &&
        n.tipoAtuacao == TipoAtuacao.servicos,
  ).length;

  int get ambosSuspensos => negocios.where(
        (n) =>
    n.status == StatusNegocioAdmin.suspenso &&
        n.tipoAtuacao == TipoAtuacao.ambos,
  ).length;

  int get clientesSuspensos => usuarios.where(
        (u) =>
    u.perfil == 'Cliente' &&
        u.status == StatusUsuarioAdmin.suspenso,
  ).length;

  bool correspondeFiltroAtuacao(
      NegocioAdminDemo negocio,
      FiltroAtuacaoAdmin filtro,
      ) {
    final tipo = negocio.tipoAtuacao;

    switch (filtro) {
      case FiltroAtuacaoAdmin.todos:
        return true;
      case FiltroAtuacaoAdmin.comAtuacao:
        return tipo != TipoAtuacao.semOfertas;
      case FiltroAtuacaoAdmin.somenteComerciantes:
        return tipo == TipoAtuacao.produtos;
      case FiltroAtuacaoAdmin.somentePrestadores:
        return tipo == TipoAtuacao.servicos;
      case FiltroAtuacaoAdmin.ambos:
        return tipo == TipoAtuacao.ambos;
      case FiltroAtuacaoAdmin.semOfertas:
        return tipo == TipoAtuacao.semOfertas;
    }
  }

  List<NegocioAdminDemo> filtrarNegocios({
    FiltroAtuacaoAdmin atuacao =
        FiltroAtuacaoAdmin.todos,
    StatusNegocioAdmin? status,
    String pesquisa = '',
  }) {
    final termo = pesquisa.trim().toLowerCase();

    return negocios.where((n) {
      return correspondeFiltroAtuacao(n, atuacao) &&
          (status == null || n.status == status) &&
          (n.nome.toLowerCase().contains(termo) ||
              n.cidade.toLowerCase().contains(termo) ||
              n.categoria.toLowerCase().contains(termo));
    }).toList();
  }
}
