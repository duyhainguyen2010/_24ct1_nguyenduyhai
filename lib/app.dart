import 'package:flutter/material.dart';
import 'core/constants/app_strings.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/notifiers/auth_notifier.dart';
import 'features/auth/presentation/notifiers/auth_scope.dart';
import 'features/auth/presentation/screens/auth_gate.dart';
import 'features/boarding_house/domain/repositories/boarding_house_repository.dart';
import 'features/boarding_house/presentation/boarding_house_scope.dart';

/// Root application widget configuring Theme, AuthScope, BoardingHouseScope, and Dynamic Routing.
class BoardingHouseApp extends StatefulWidget {
  final AuthRepository authRepository;
  final BoardingHouseRepository boardingHouseRepository;

  const BoardingHouseApp({
    super.key,
    required this.authRepository,
    required this.boardingHouseRepository,
  });

  @override
  State<BoardingHouseApp> createState() => _BoardingHouseAppState();
}

class _BoardingHouseAppState extends State<BoardingHouseApp> {
  late final AuthNotifier _authNotifier;

  @override
  void initState() {
    super.initState();
    _authNotifier = AuthNotifier(repository: widget.authRepository);
  }

  @override
  void dispose() {
    _authNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BoardingHouseScope(
      repository: widget.boardingHouseRepository,
      child: AuthScope(
        notifier: _authNotifier,
        child: MaterialApp(
          title: AppStrings.appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const AuthGate(),
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      ),
    );
  }
}
