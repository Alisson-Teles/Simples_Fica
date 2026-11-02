
import 'package:flutter/material.dart';

import 'app_session.dart';

class AppScope extends InheritedNotifier<AppSession> {
  const AppScope({
    super.key,
    required AppSession notifier,
    required super.child,
  }) : super(notifier: notifier);

  static AppSession of(BuildContext context) {
    final scope =
    context.dependOnInheritedWidgetOfExactType<AppScope>();

    if (scope == null || scope.notifier == null) {
      throw StateError(
        'AppScope não encontrado na árvore de widgets.',
      );
    }

    return scope.notifier!;
  }
}
