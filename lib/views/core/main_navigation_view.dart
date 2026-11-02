
import 'package:flutter/material.dart';

import '../public/home_view.dart';
import '../public/explore_view.dart';

import '../account/favorites_view.dart';
import '../account/profile_view.dart';

import '../../theme/app_theme.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() =>
      _MainNavigationViewState();
}

class _MainNavigationViewState
    extends State<MainNavigationView> {
  int _indiceSelecionado = 0;

  void _selecionarAba(int indice) {
    setState(() {
      _indiceSelecionado = indice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indiceSelecionado,

        children: [
          const HomeView(),
          const ExploreView(),

          FavoritesView(
            onExplorarPressed: () {
              _selecionarAba(1);
            },
          ),

          ProfileView(
            onFavoritosPressed: () {
              _selecionarAba(2);
            },
          ),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _indiceSelecionado,

        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFF4E3D7),

        onDestinationSelected: _selecionarAba,

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(
              Icons.home,
              color: AppTheme.primary,
            ),
            label: 'Início',
          ),

          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(
              Icons.search,
              color: AppTheme.primary,
            ),
            label: 'Explorar',
          ),

          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(
              Icons.favorite,
              color: AppTheme.primary,
            ),
            label: 'Favoritos',
          ),

          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(
              Icons.person,
              color: AppTheme.primary,
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
