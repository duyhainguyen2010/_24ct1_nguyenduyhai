import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:_24ct1_nguyenduyhai/firebase_options.dart';
import 'package:_24ct1_nguyenduyhai/features/boarding_house/data/boarding_house_seeder.dart';

/// Standalone script to seed Cloud Firestore with initial mock boarding houses.
/// Run via:
///   flutter run -t tool/seed_firestore.dart -d chrome (or windows / android)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final seeder = BoardingHouseSeeder();
  final seededCount = await seeder.seedInitialRoomsIfEmpty();

  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Firestore Seeder Tool')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.green, size: 64),
                const SizedBox(height: 16),
                Text(
                  seededCount > 0
                      ? 'Đã seed thành công $seededCount phòng vào Cloud Firestore collection "rooms"!'
                      : 'Collection "rooms" đã có dữ liệu trước đó (bỏ qua seed để tránh trùng lặp).',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Bạn có thể đóng cửa sổ này và chạy lại main.dart cho production app.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
