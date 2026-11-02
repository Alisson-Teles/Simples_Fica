import 'package:flutter_test/flutter_test.dart';
import '../lib/models/negocio_demo.dart';
import '../lib/models/oferta.dart';
import '../lib/models/detalhes_estabelecimento.dart';
import '../lib/state/app_session.dart';

void main() {
  test('Classificação acompanha ofertas ativas', () {
    final sessao = AppSession();
    final id = sessao.cadastrarNegocio(const NegocioDemo(
      id: -1, nome: 'Teste', descricao: 'Exemplo', categoria: 'Outros',
      cidade: 'Rio Verde', bairro: 'Centro', uf: 'GO', endereco: 'Rua A',
      telefone: '64999999999', horarios: '08h - 18h',
    ));
    expect(sessao.negocioPorId(id)!.tipoAtuacao, TipoAtuacao.semOfertas);
    sessao.salvarOferta(id, const Oferta(
      id: -1, tipo: TipoOferta.produto, nome: 'Cabo',
      descricao: 'Cabo teste', preco: 20, estoque: 3,
    ));
    expect(sessao.negocioPorId(id)!.tipoAtuacao, TipoAtuacao.produtos);
    sessao.salvarOferta(id, const Oferta(
      id: -1, tipo: TipoOferta.servico, nome: 'Conserto',
      descricao: 'Reparo teste', preco: 50,
    ));
    expect(sessao.negocioPorId(id)!.tipoAtuacao, TipoAtuacao.ambos);
    sessao.dispose();
  });

  test('Venda de produto reduz estoque e soma total', () {
    final sessao = AppSession();
    final id = sessao.cadastrarNegocio(const NegocioDemo(
      id: -1, nome: 'Loja', descricao: 'Teste', categoria: 'Outros',
      cidade: 'Jataí', bairro: 'Centro', uf: 'GO', endereco: 'Rua B',
      telefone: '64999999999', horarios: '09h - 17h',
    ));
    sessao.salvarOferta(id, const Oferta(
      id: -1, tipo: TipoOferta.produto, nome: 'Peça',
      descricao: 'Peça teste', preco: 15, estoque: 5,
    ));
    final oferta = sessao.negocioPorId(id)!.ofertas.first;
    sessao.registrarVenda(id, oferta.id, 2);
    expect(sessao.negocioPorId(id)!.ofertas.first.estoque, 3);
    expect(sessao.receitaDemo(id), 30);
    expect(() => sessao.registrarVenda(id, oferta.id, 4), throwsStateError);
    sessao.dispose();
  });
}