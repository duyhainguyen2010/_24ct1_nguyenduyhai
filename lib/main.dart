import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'features/auth/data/firebase_auth_repository.dart';
import 'features/boarding_house/data/firebase_boarding_house_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase SDK with configured platform options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Active authentication repository backed by Firebase Authentication
  final authRepository = FirebaseAuthRepository();

  // Active boarding house repository backed by Cloud Firestore
  final boardingHouseRepository = FirebaseBoardingHouseRepository();

  runApp(
    BoardingHouseApp(
      authRepository: authRepository,
      boardingHouseRepository: boardingHouseRepository,
    ),
  );
}

