import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:_24ct1_nguyenduyhai/features/boarding_house/data/firebase_boarding_house_repository.dart';
import 'package:_24ct1_nguyenduyhai/features/boarding_house/domain/models/boarding_house.dart';
import 'package:_24ct1_nguyenduyhai/features/boarding_house/domain/models/room_amenity.dart';

void main() {
  group('FirebaseBoardingHouseRepository Serialization Tests', () {
    test('toFirestore serializes BoardingHouse properly into Firestore Map', () {
      final now = DateTime(2026, 10, 5, 12, 0);
      final house = BoardingHouse(
        id: 'test-room-1',
        title: 'Phòng trọ sinh viên',
        monthlyPrice: 2000000.0,
        address: '123 Nguyễn Lương Bằng',
        area: 20.0,
        imageUrl: 'https://example.com/image.jpg',
        isFeatured: true,
        isAvailable: true,
        createdAt: now,
        latitude: 16.05,
        longitude: 108.20,
        mockDistanceKm: 1.5,
        description: 'Mô tả chi tiết phòng',
        amenities: const [
          RoomAmenity.wifi,
          RoomAmenity.airConditioner,
          RoomAmenity.parking,
        ],
        ownerName: 'Anh Nam',
        ownerPhone: '0905 123 456',
      );

      final map = FirebaseBoardingHouseRepository.toFirestore(house);

      expect(map['title'], 'Phòng trọ sinh viên');
      expect(map['monthlyPrice'], 2000000.0);
      expect(map['address'], '123 Nguyễn Lương Bằng');
      expect(map['area'], 20.0);
      expect(map['imageUrl'], 'https://example.com/image.jpg');
      expect(map['isFeatured'], true);
      expect(map['isAvailable'], true);
      expect(map['createdAt'], isA<Timestamp>());
      expect((map['createdAt'] as Timestamp).toDate(), now);
      expect(map['latitude'], 16.05);
      expect(map['longitude'], 108.20);
      expect(map['mockDistanceKm'], 1.5);
      expect(map['description'], 'Mô tả chi tiết phòng');
      expect(map['amenities'], ['wifi', 'airConditioner', 'parking']);
      expect(map['ownerName'], 'Anh Nam');
      expect(map['ownerPhone'], '0905 123 456');
    });

    test('fromFirestore deserializes Firestore Map correctly into BoardingHouse', () {
      final now = DateTime(2026, 10, 5, 12, 0);
      final firestoreData = <String, dynamic>{
        'title': 'Căn hộ mini cao cấp',
        'monthlyPrice': 3500000, // integer from Firestore
        'address': '24 Núi Thành',
        'area': 35, // integer from Firestore
        'imageUrl': null,
        'isFeatured': false,
        'isAvailable': true,
        'createdAt': Timestamp.fromDate(now),
        'latitude': 16.0598,
        'longitude': 108.2215,
        'mockDistanceKm': 2.1,
        'description': 'Đầy đủ tiện nghi',
        'amenities': ['wifi', 'kitchen', 'washingMachine', 'unknownAmenity'],
        'ownerName': 'Chị Hà',
        'ownerPhone': '0978 223 344',
      };

      final house = FirebaseBoardingHouseRepository.fromFirestore(
        firestoreData,
        'bh-100',
      );

      expect(house.id, 'bh-100');
      expect(house.title, 'Căn hộ mini cao cấp');
      expect(house.monthlyPrice, 3500000.0);
      expect(house.address, '24 Núi Thành');
      expect(house.area, 35.0);
      expect(house.imageUrl, isNull);
      expect(house.isFeatured, false);
      expect(house.isAvailable, true);
      expect(house.createdAt, now);
      expect(house.latitude, 16.0598);
      expect(house.longitude, 108.2215);
      expect(house.mockDistanceKm, 2.1);
      expect(house.description, 'Đầy đủ tiện nghi');
      expect(house.amenities, [
        RoomAmenity.wifi,
        RoomAmenity.kitchen,
        RoomAmenity.washingMachine,
      ]);
      expect(house.ownerName, 'Chị Hà');
      expect(house.ownerPhone, '0978 223 344');
    });

    test('fromFirestore handles fallback values safely when fields are missing', () {
      final emptyData = <String, dynamic>{};
      final house = FirebaseBoardingHouseRepository.fromFirestore(
        emptyData,
        'fallback-id',
      );

      expect(house.id, 'fallback-id');
      expect(house.title, '');
      expect(house.monthlyPrice, 0.0);
      expect(house.address, '');
      expect(house.area, 0.0);
      expect(house.imageUrl, isNull);
      expect(house.isFeatured, false);
      expect(house.isAvailable, true);
      expect(house.createdAt, isA<DateTime>());
      expect(house.latitude, 0.0);
      expect(house.longitude, 0.0);
      expect(house.mockDistanceKm, 1.0);
      expect(house.description, '');
      expect(house.amenities, isEmpty);
      expect(house.ownerName, 'Chủ nhà trọ');
      expect(house.ownerPhone, '0905 123 456');
    });
  });
}
