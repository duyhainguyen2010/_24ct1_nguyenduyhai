import 'package:flutter/widgets.dart';
import 'auth_notifier.dart';

/// InheritedWidget providing AuthNotifier down the widget tree without external dependencies.
class AuthScope extends InheritedNotifier<AuthNotifier> {
  const AuthScope({
    super.key,
    required AuthNotifier notifier,
    required super.child,
  }) : super(notifier: notifier);

  static AuthNotifier of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AuthScope>();
    assert(scope != null, 'No AuthScope found in context');
    return scope!.notifier!;
  }
}
