import 'package:flutter/material.dart';
import 'app.dart';
import 'features/auth/data/mock_auth_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Active authentication repository.
  // To switch to live Firebase when credentials and configuration are provided later:
  // final authRepository = FirebaseAuthRepository();
  final authRepository = MockAuthRepository();

  runApp(BoardingHouseApp(authRepository: authRepository));
}
