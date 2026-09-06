import 'package:flutter/material.dart';
import '../../../../features/shell/presentation/screens/main_shell_screen.dart';
import '../notifiers/auth_scope.dart';
import 'email_verification_screen.dart';
import 'login_screen.dart';

/// AuthGate observes AuthNotifier state and decides which root view to display:
/// - Unauthenticated -> LoginScreen
/// - Authenticated but unverified -> EmailVerificationScreen
/// - Authenticated and verified -> MainShellScreen
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authNotifier = AuthScope.of(context);

    if (!authNotifier.isAuthenticated) {
      return const LoginScreen();
    }

    if (!authNotifier.isEmailVerified) {
      return const EmailVerificationScreen();
    }

    return const MainShellScreen();
  }
}
