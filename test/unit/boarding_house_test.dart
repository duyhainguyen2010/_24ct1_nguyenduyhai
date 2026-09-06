import 'package:flutter_test/flutter_test.dart';
import 'package:_24ct1_nguyenduyhai/features/boarding_house/data/mock_boarding_house_repository.dart';
import 'package:_24ct1_nguyenduyhai/features/boarding_house/domain/models/boarding_house.dart';
import 'package:_24ct1_nguyenduyhai/features/boarding_house/domain/models/room_amenity.dart';

void main() {
  group('BoardingHouse Model Tests', () {
    test('formattedPrice formats millions correctly', () {
      final bh1 = BoardingHouse(
        id: '1',
        title: 'Room 1',
        monthlyPrice: 2500000,
        address: 'Danang',
        area: 25.0,
        createdAt: DateTime.now(),
        latitude: 16.0,
        longitude: 108.0,
        description: 'Mô tả phòng',
        amenities: const [RoomAmenity.wifi, RoomAmenity.airConditioner],
        ownerName: 'Chủ trọ',
        ownerPhone: '0905123456',
      );
      expect(bh1.formattedPrice, '2.5 triệu/tháng');
      expect(bh1.description, 'Mô tả phòng');
      expect(bh1.amenities.contains(RoomAmenity.wifi), isTrue);
      expect(bh1.ownerName, 'Chủ trọ');

      final bh2 = bh1.copyWith(monthlyPrice: 3000000);
      expect(bh2.formattedPrice, '3 triệu/tháng');

      final bh3 = bh1.copyWith(monthlyPrice: 800000);
      expect(bh3.formattedPrice, '800000 đ/tháng');
    });

    test('formattedArea and formattedDistance format properly', () {
      final bh = BoardingHouse(
        id: '1',
        title: 'Room 1',
        monthlyPrice: 2000000,
        address: 'Danang',
        area: 20.5,
        mockDistanceKm: 0.84,
        createdAt: DateTime.now(),
        latitude: 16.0,
        longitude: 108.0,
      );
      expect(bh.formattedArea, '20.5 m²');
      expect(bh.formattedDistance, '0.8 km');
    });
  });

  group('MockBoardingHouseRepository Tests', () {
    late MockBoardingHouseRepository repository;

    setUp(() {
      repository = MockBoardingHouseRepository();
    });

    test('getFeaturedBoardingHouses returns only featured listings', () async {
      final featured = await repository.getFeaturedBoardingHouses();
      expect(featured.isNotEmpty, isTrue);
      for (final item in featured) {
        expect(item.isFeatured, isTrue);
      }
    });

    test('getNearbyBoardingHouses returns listings sorted by distance', () async {
      final nearby = await repository.getNearbyBoardingHouses();
      expect(nearby.isNotEmpty, isTrue);
      for (int i = 0; i < nearby.length - 1; i++) {
        expect(nearby[i].mockDistanceKm <= nearby[i + 1].mockDistanceKm, isTrue);
      }
    });

    test('getRecentBoardingHouses returns all mock listings sorted by date', () async {
      final recent = await repository.getRecentBoardingHouses();
      expect(recent.isNotEmpty, isTrue);
      for (int i = 0; i < recent.length - 1; i++) {
        expect(recent[i].createdAt.isAfter(recent[i + 1].createdAt) ||
            recent[i].createdAt.isAtSameMomentAs(recent[i + 1].createdAt), isTrue);
      }
    });

    test('getBoardingHouseById retrieves correct item with details', () async {
      final item = await repository.getBoardingHouseById('bh-001');
      expect(item, isNotNull);
      expect(item?.id, 'bh-001');
      expect(item?.description.isNotEmpty, isTrue);
      expect(item?.amenities.isNotEmpty, isTrue);
      expect(item?.ownerName.isNotEmpty, isTrue);
      expect(item?.isAvailable, isTrue);

      final unavailableItem = await repository.getBoardingHouseById('bh-004');
      expect(unavailableItem, isNotNull);
      expect(unavailableItem?.isAvailable, isFalse);

      final nonExistent = await repository.getBoardingHouseById('invalid-id');
      expect(nonExistent, isNull);
    });
  });
}
