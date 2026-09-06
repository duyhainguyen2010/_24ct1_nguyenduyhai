import '../../features/boarding_house/domain/models/boarding_house.dart';
import '../../features/room_detail/presentation/screens/room_detail_screen.dart';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/screens/change_password_screen.dart';
import '../../features/auth/presentation/screens/email_verification_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/shell/presentation/screens/main_shell_screen.dart';
import 'app_routes.dart';

/// Route generator for the application.
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.initial:
      case AppRoutes.shell:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MainShellScreen(),
        );
      case AppRoutes.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );
      case AppRoutes.register:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const RegisterScreen(),
        );
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ForgotPasswordScreen(),
        );
      case AppRoutes.verifyEmail:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const EmailVerificationScreen(),
        );
      case AppRoutes.roomDetail:
        final boardingHouse = settings.arguments as BoardingHouse;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => RoomDetailScreen(boardingHouse: boardingHouse),
        );
      case AppRoutes.changePassword:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ChangePasswordScreen(),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Không tìm thấy trang')),
            body: Center(
              child: Text('Trang ${settings.name} không tồn tại.'),
            ),
          ),
        );
    }
  }
}

