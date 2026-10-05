import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'firebase_boarding_house_repository.dart';
import 'mock_boarding_house_repository.dart';

/// Standalone development tool for seeding mock boarding houses to Cloud Firestore.
/// NOT executed automatically by production main.dart.
class BoardingHouseSeeder {
  final FirebaseFirestore _firestore;

  BoardingHouseSeeder({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Seeds initial mock boarding houses into the 'rooms' collection.
  /// If [force] is false (default), it safely aborts if the collection already contains data.
  /// Uses fixed document IDs (e.g., bh-001) with WriteBatch to guarantee idempotency.
  Future<int> seedInitialRoomsIfEmpty({bool force = false}) async {
    final roomsRef = _firestore.collection(FirebaseBoardingHouseRepository.collectionName);

    if (!force) {
      final existingDocs = await roomsRef.limit(1).get();
      if (existingDocs.docs.isNotEmpty) {
        debugPrint('[BoardingHouseSeeder] Collection "rooms" already contains documents. Seeding skipped.');
        return 0;
      }
    }

    final initialRooms = MockBoardingHouseRepository.initialMockData;
    final batch = _firestore.batch();

    for (final room in initialRooms) {
      final docRef = roomsRef.doc(room.id);
      batch.set(docRef, FirebaseBoardingHouseRepository.toFirestore(room));
    }

    await batch.commit();
    debugPrint('[BoardingHouseSeeder] Successfully seeded ${initialRooms.length} rooms to Firestore collection "rooms".');
    return initialRooms.length;
  }
}
