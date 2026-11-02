
import 'package:flutter/foundation.dart';

import '../models/usuario_perfil.dart';

class AppSession extends ChangeNotifier {

  // FAVORITOS
  final Set<int> _favoritos = <int>{};

  Set<int> get favoritos {
    return Set.unmodifiable(_favoritos);
  }

  bool isFavorite(int estabelecimentoId) {
    return _favoritos.contains(estabelecimentoId);
  }

  void toggleFavorite(int estabelecimentoId) {
    if (_favoritos.contains(estabelecimentoId)) {
      _favoritos.remove(estabelecimentoId);
    } else {
      _favoritos.add(estabelecimentoId);
    }

    notifyListeners();
  }

  void removerFavorito(int estabelecimentoId) {
    if (_favoritos.remove(estabelecimentoId)) {
      notifyListeners();
    }
  }

  // PERFIL DEMONSTRATIVO
  UsuarioPerfil _perfil = const UsuarioPerfil(
    nome: 'Usuário de teste',
    email: 'usuario@exemplo.com',
    telefone: '(64) 99999-0000',
  );

  UsuarioPerfil get perfil => _perfil;

  void atualizarPerfil(UsuarioPerfil novoPerfil) {
    _perfil = novoPerfil;
    notifyListeners();
  }
}
