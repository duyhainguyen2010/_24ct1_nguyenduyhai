import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/models/boarding_house.dart';
import '../domain/models/boarding_house_filter.dart';
import '../domain/models/room_amenity.dart';
import '../domain/models/room_sort_option.dart';
import '../domain/repositories/boarding_house_repository.dart';

/// Cloud Firestore implementation of [BoardingHouseRepository].
/// Reads boarding house listings from the 'rooms' collection.
class FirebaseBoardingHouseRepository implements BoardingHouseRepository {
  final FirebaseFirestore _firestore;
  static const String collectionName = 'rooms';

  FirebaseBoardingHouseRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _roomsCollection =>
      _firestore.collection(collectionName);

  /// Converts a Firestore document snapshot / map into a [BoardingHouse] domain entity.
  static BoardingHouse fromFirestore(Map<String, dynamic> data, String id) {
    final rawCreatedAt = data['createdAt'];
    final DateTime createdAt;
    if (rawCreatedAt is Timestamp) {
      createdAt = rawCreatedAt.toDate();
    } else if (rawCreatedAt is String) {
      createdAt = DateTime.tryParse(rawCreatedAt) ?? DateTime.now();
    } else if (rawCreatedAt is int) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(rawCreatedAt);
    } else {
      createdAt = DateTime.now();
    }

    final rawAmenities = data['amenities'] as List<dynamic>? ?? [];
    final amenities = rawAmenities
        .map((e) => e?.toString())
        .whereType<String>()
        .map((name) => RoomAmenity.values.where((a) => a.name == name).firstOrNull)
        .whereType<RoomAmenity>()
        .toList();

    return BoardingHouse(
      id: id,
      title: data['title'] as String? ?? '',
      monthlyPrice: (data['monthlyPrice'] as num?)?.toDouble() ?? 0.0,
      address: data['address'] as String? ?? '',
      area: (data['area'] as num?)?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl'] as String?,
      isFeatured: data['isFeatured'] as bool? ?? false,
      isAvailable: data['isAvailable'] as bool? ?? true,
      createdAt: createdAt,
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      mockDistanceKm: (data['mockDistanceKm'] as num?)?.toDouble() ?? 1.0,
      description: data['description'] as String? ?? '',
      amenities: amenities,
      ownerName: data['ownerName'] as String? ?? 'Chủ nhà trọ',
      ownerPhone: data['ownerPhone'] as String? ?? '0905 123 456',
    );
  }

  /// Converts a [BoardingHouse] domain entity to a Firestore document map.
  static Map<String, dynamic> toFirestore(BoardingHouse house) {
    return {
      'title': house.title,
      'monthlyPrice': house.monthlyPrice,
      'address': house.address,
      'area': house.area,
      'imageUrl': house.imageUrl,
      'isFeatured': house.isFeatured,
      'isAvailable': house.isAvailable,
      'createdAt': Timestamp.fromDate(house.createdAt),
      'latitude': house.latitude,
      'longitude': house.longitude,
      'mockDistanceKm': house.mockDistanceKm,
      'description': house.description,
      'amenities': house.amenities.map((a) => a.name).toList(),
      'ownerName': house.ownerName,
      'ownerPhone': house.ownerPhone,
    };
  }

  @override
  Future<List<BoardingHouse>> getFeaturedBoardingHouses() async {
    final snapshot = await _roomsCollection
        .where('isFeatured', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => fromFirestore(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<List<BoardingHouse>> getNearbyBoardingHouses() async {
    final snapshot = await _roomsCollection.get();
    final list = snapshot.docs
        .map((doc) => fromFirestore(doc.data(), doc.id))
        .toList();

    list.sort((a, b) => a.mockDistanceKm.compareTo(b.mockDistanceKm));
    return list.take(5).toList();
  }

  @override
  Future<List<BoardingHouse>> getRecentBoardingHouses() async {
    final snapshot = await _roomsCollection
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => fromFirestore(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<BoardingHouse?> getBoardingHouseById(String id) async {
    final doc = await _roomsCollection.doc(id).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return fromFirestore(doc.data()!, doc.id);
  }

  @override
  Future<List<BoardingHouse>> searchBoardingHouses(BoardingHouseFilter filter) async {
    // 1. Fetch from Firestore (optimize available filter when requested)
    Query<Map<String, dynamic>> query = _roomsCollection;
    if (filter.onlyAvailable) {
      query = query.where('isAvailable', isEqualTo: true);
    }

    final snapshot = await query.get();
    var results = snapshot.docs
        .map((doc) => fromFirestore(doc.data(), doc.id))
        .toList();

    // 2. Text Search (title & address, case-insensitive, trimmed)
    if (filter.query != null && filter.query!.trim().isNotEmpty) {
      final q = filter.query!.trim().toLowerCase();
      results = results.where((item) {
        final titleMatch = item.title.toLowerCase().contains(q);
        final addressMatch = item.address.toLowerCase().contains(q);
        return titleMatch || addressMatch;
      }).toList();
    }

    // 3. Monthly Price Range
    if (filter.minPrice != null && filter.minPrice! > 0) {
      results = results.where((item) => item.monthlyPrice >= filter.minPrice!).toList();
    }
    if (filter.maxPrice != null && filter.maxPrice! > 0) {
      results = results.where((item) => item.monthlyPrice <= filter.maxPrice!).toList();
    }

    // 4. Room Area Range
    if (filter.minArea != null && filter.minArea! > 0) {
      results = results.where((item) => item.area >= filter.minArea!).toList();
    }
    if (filter.maxArea != null && filter.maxArea! > 0) {
      results = results.where((item) => item.area <= filter.maxArea!).toList();
    }

    // 5. Amenities Filter (must contain ALL selected amenities)
    if (filter.amenities.isNotEmpty) {
      results = results.where((item) {
        for (final amenity in filter.amenities) {
          if (!item.amenities.contains(amenity)) {
            return false;
          }
        }
        return true;
      }).toList();
    }

    // 6. Sorting
    switch (filter.sortOption) {
      case RoomSortOption.newest:
        results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case RoomSortOption.priceLowToHigh:
        results.sort((a, b) => a.monthlyPrice.compareTo(b.monthlyPrice));
        break;
      case RoomSortOption.priceHighToLow:
        results.sort((a, b) => b.monthlyPrice.compareTo(a.monthlyPrice));
        break;
      case RoomSortOption.nearest:
        results.sort((a, b) => a.mockDistanceKm.compareTo(b.mockDistanceKm));
        break;
    }

    return results;
  }
}
