
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: ListView(
          children: [
            // ESPAÇO DE ANÚNCIO
            Container(
              color: const Color(0xFFFFF3DC),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ESPAÇO DE ANÚNCIO',
                    style: TextStyle(
                      color: Color(0xFF8E6420),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Destaques patrocinados',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3D3521),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Anúncios aparecem aqui e não '
                        'alteram a ordem da busca.',
                    style: TextStyle(
                      color: Color(0xFF736542),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _cardEstabelecimento(
                    nome: 'Café da Praça',
                    descricao: 'Cafeteria e lanches artesanais',
                    icone: Icons.local_cafe,
                    patrocinado: true,
                  ),

                  const SizedBox(height: 12),

                  _cardEstabelecimento(
                    nome: 'Tech Cell',
                    descricao: 'Assistência técnica e acessórios',
                    icone: Icons.phone_android,
                    patrocinado: true,
                  ),
                ],
              ),
            ),

            // ESTABELECIMENTOS PRÓXIMOS
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'RESULTADOS DA SUA REGIÃO',
                    style: TextStyle(
                      color: AppTheme.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Encontre quem está perto',
                    style: TextStyle(
                      color: AppTheme.brown,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Explore estabelecimentos e serviços '
                        'da sua região.',
                  ),

                  const SizedBox(height: 20),

                  _cardEstabelecimento(
                    nome: 'Mercado Central',
                    descricao: 'Mercado e produtos alimentícios',
                    icone: Icons.store,
                    patrocinado: false,
                  ),

                  const SizedBox(height: 12),

                  _cardEstabelecimento(
                    nome: 'Barbearia Moderna',
                    descricao: 'Cortes masculinos e cuidados',
                    icone: Icons.content_cut,
                    patrocinado: false,
                  ),
                ],
              ),
            ),

            // CONVITE PARA COMERCIANTES
            Container(
              color: const Color(0xFFF4E3D7),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Seu negócio também pode ficar '
                        'mais fácil de encontrar.',
                    style: TextStyle(
                      color: AppTheme.brown,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Divulgue seus produtos e serviços '
                        'para pessoas da sua região.',
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Cadastrar negócio'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardEstabelecimento({
    required String nome,
    required String descricao,
    required IconData icone,
    required bool patrocinado,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: patrocinado
              ? const Color(0xFFE4C98F)
              : const Color(0xFFEAD7CC),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: patrocinado
                  ? const Color(0xFFFFF3DC)
                  : const Color(0xFFF4E3D7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icone,
              size: 32,
              color: AppTheme.primary,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (patrocinado)
                  const Text(
                    'ANÚNCIO',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9A612C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                Text(
                  nome,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brown,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  descricao,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF78645C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
