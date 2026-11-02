
import '../models/oferta.dart';
import '../models/detalhes_estabelecimento.dart';

const Map<int, DetalhesEstabelecimento> detalhesMock = {
  // 1 - CAFÉ DA PRAÇA: SOMENTE PRODUTOS
  1: DetalhesEstabelecimento(
    endereco: 'Praça Central, 100',
    uf: 'GO',
    horarios: [
      'Segunda a sexta: 08:00 às 19:00',
      'Sábado: 08:00 às 14:00',
      'Domingo: fechado',
    ],
    ofertas: [
      Oferta(
        id: 1,
        tipo: TipoOferta.produto,
        nome: 'Café especial',
        descricao: 'Café preparado na hora.',
        preco: 9.50,
        estoque: 25,
        destaque: true,
      ),
      Oferta(
        id: 2,
        tipo: TipoOferta.produto,
        nome: 'Bolo de chocolate',
        descricao: 'Fatia de bolo artesanal.',
        preco: 12.00,
        estoque: 8,
      ),
      Oferta(
        id: 3,
        tipo: TipoOferta.servico,
        nome: 'Coffee break para eventos',
        descricao: 'Serviço temporariamente desativado.',
        preco: 180.00,
        ativo: false,
      ),
    ],
    avaliacoes: [
      Avaliacao(
        autor: 'Ana',
        nota: 5,
        comentario: 'Café delicioso e ótimo atendimento.',
      ),
    ],
  ),

  // 2 - TECH CELL: PRODUTOS E SERVIÇOS
  2: DetalhesEstabelecimento(
    endereco: 'Rua das Flores, 220',
    uf: 'GO',
    horarios: [
      'Segunda a sexta: 09:00 às 18:00',
      'Sábado: 09:00 às 12:00',
      'Domingo: fechado',
    ],
    ofertas: [
      Oferta(
        id: 4,
        tipo: TipoOferta.produto,
        nome: 'Cabo USB-C',
        descricao: 'Cabo para recarga de celular.',
        preco: 29.90,
        estoque: 12,
        destaque: true,
      ),
      Oferta(
        id: 5,
        tipo: TipoOferta.produto,
        nome: 'Capinha protetora',
        descricao: 'Capinhas para modelos variados.',
        preco: 35.00,
        estoque: 0,
      ),
      Oferta(
        id: 6,
        tipo: TipoOferta.servico,
        nome: 'Diagnóstico de celular',
        descricao: 'Avaliação inicial do aparelho.',
        preco: 40.00,
      ),
      Oferta(
        id: 7,
        tipo: TipoOferta.servico,
        nome: 'Troca de tela',
        descricao: 'Valor conforme o modelo.',
      ),
    ],
    avaliacoes: [
      Avaliacao(
        autor: 'Marina',
        nota: 5,
        comentario: 'Atendimento muito profissional.',
      ),
    ],
  ),

  // 3 - BARBEARIA MODERNA: SOMENTE SERVIÇOS
  3: DetalhesEstabelecimento(
    endereco: 'Rua Goiás, 350',
    uf: 'GO',
    horarios: [
      'Terça a sábado: 09:00 às 19:00',
      'Domingo e segunda: fechado',
    ],
    ofertas: [
      Oferta(
        id: 8,
        tipo: TipoOferta.servico,
        nome: 'Corte masculino',
        descricao: 'Corte tradicional ou moderno.',
        preco: 40.00,
        destaque: true,
      ),
      Oferta(
        id: 9,
        tipo: TipoOferta.servico,
        nome: 'Barba completa',
        descricao: 'Modelagem e acabamento.',
        preco: 25.00,
      ),
    ],
    avaliacoes: [
      Avaliacao(
        autor: 'Carlos',
        nota: 5,
        comentario: 'Excelente corte e atendimento.',
      ),
    ],
  ),

  // 4 - MERCADO CENTRAL: SOMENTE PRODUTOS
  4: DetalhesEstabelecimento(
    endereco: 'Avenida Central, 450',
    uf: 'GO',
    horarios: [
      'Segunda a sábado: 07:00 às 21:00',
      'Domingo: 08:00 às 13:00',
    ],
    ofertas: [
      Oferta(
        id: 10,
        tipo: TipoOferta.produto,
        nome: 'Arroz 5 kg',
        descricao: 'Pacote de arroz branco.',
        preco: 24.90,
        estoque: 30,
      ),
      Oferta(
        id: 11,
        tipo: TipoOferta.produto,
        nome: 'Leite integral',
        descricao: 'Caixa de 1 litro.',
        preco: 5.49,
        estoque: 45,
      ),
    ],
    avaliacoes: [
      Avaliacao(
        autor: 'Paula',
        nota: 4,
        comentario: 'Boa variedade de produtos.',
      ),
    ],
  ),

  // 5 - OFICINA RÁPIDA: SOMENTE SERVIÇOS
  5: DetalhesEstabelecimento(
    endereco: 'Avenida dos Trabalhadores, 90',
    uf: 'GO',
    horarios: [
      'Segunda a sexta: 08:00 às 18:00',
      'Sábado: 08:00 às 12:00',
      'Domingo: fechado',
    ],
    ofertas: [
      Oferta(
        id: 12,
        tipo: TipoOferta.servico,
        nome: 'Troca de óleo',
        descricao: 'Mão de obra para troca de óleo.',
        preco: 50.00,
      ),
      Oferta(
        id: 13,
        tipo: TipoOferta.servico,
        nome: 'Diagnóstico mecânico',
        descricao: 'Inspeção inicial do veículo.',
        preco: 80.00,
      ),
    ],
    avaliacoes: [
      Avaliacao(
        autor: 'João',
        nota: 5,
        comentario: 'Resolveram o problema rapidamente.',
      ),
    ],
  ),
};
