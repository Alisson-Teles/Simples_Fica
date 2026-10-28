
import 'package:flutter/material.dart';

import 'home_view.dart';
import 'explore_view.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() =>
      _MainNavigationViewState();
}

class _MainNavigationViewState
    extends State<MainNavigationView> {

  int _indiceSelecionado = 0;

  final List<Widget> _telas = const [
    HomeView(),
    ExploreView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indiceSelecionado,
        children: _telas,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indiceSelecionado,
        onDestinationSelected: (indice) {
          setState(() {
            _indiceSelecionado = indice;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Explorar',
          ),
        ],
      ),
    );
  }
}
