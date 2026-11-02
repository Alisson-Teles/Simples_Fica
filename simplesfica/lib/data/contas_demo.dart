
import '../models/conta_demo.dart';

// Credenciais públicas e fictícias.
// APENAS para testes locais de interface.
// Nunca utilizar como autenticação de produção.

const List<ContaDemo> contasDemo = [
  ContaDemo(
    nome: 'Cliente de Teste',
    email: 'cliente@simplesfica.test',
    senha: 'Cliente123!',
    telefone: '(64) 99999-1001',
    tipo: TipoAcessoDemo.cliente,
  ),

  ContaDemo(
    nome: 'Comerciante de Teste',
    email: 'comerciante@simplesfica.test',
    senha: 'Comerciante123!',
    telefone: '(64) 99999-1002',
    tipo: TipoAcessoDemo.comerciante,
  ),

  ContaDemo(
    nome: 'Administrador de Teste',
    email: 'admin@simplesfica.test',
    senha: 'Admin123!',
    telefone: '(64) 99999-1003',
    tipo: TipoAcessoDemo.administrador,
  ),
];

ContaDemo? buscarContaDemo(
    String email,
    String senha,
    ) {
  final emailNormalizado =
  email.trim().toLowerCase();

  for (final conta in contasDemo) {
    if (conta.email.toLowerCase() ==
        emailNormalizado &&
        conta.senha == senha) {
      return conta;
    }
  }

  return null;
}
