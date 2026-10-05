import 'package:flutter/widgets.dart';
import '../domain/repositories/boarding_house_repository.dart';

/// InheritedWidget providing [BoardingHouseRepository] down the widget tree from root.
class BoardingHouseScope extends InheritedWidget {
  final BoardingHouseRepository repository;

  const BoardingHouseScope({
    super.key,
    required this.repository,
    required super.child,
  });

  static BoardingHouseRepository? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BoardingHouseScope>()?.repository;
  }

  static BoardingHouseRepository of(BuildContext context) {
    final repo = maybeOf(context);
    assert(repo != null, 'No BoardingHouseScope found in context. Make sure BoardingHouseApp wraps the app with BoardingHouseScope.');
    return repo!;
  }

  @override
  bool updateShouldNotify(BoardingHouseScope oldWidget) => repository != oldWidget.repository;
}
