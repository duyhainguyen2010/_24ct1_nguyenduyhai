import 'package:flutter_test/flutter_test.dart';
import 'package:_24ct1_nguyenduyhai/features/boarding_house/data/mock_boarding_house_repository.dart';
import 'package:_24ct1_nguyenduyhai/features/boarding_house/domain/models/boarding_house_filter.dart';
import 'package:_24ct1_nguyenduyhai/features/boarding_house/domain/models/room_amenity.dart';
import 'package:_24ct1_nguyenduyhai/features/boarding_house/domain/models/room_sort_option.dart';

void main() {
  group('BoardingHouseFilter & Search Tests', () {
    late MockBoardingHouseRepository repository;

    setUp(() {
      repository = MockBoardingHouseRepository();
    });

    test('Filter text search by title (case-insensitive & trimmed)', () async {
      final results = await repository.searchBoardingHouses(
        const BoardingHouseFilter(query: '  bách khoa  '),
      );
      expect(results.isNotEmpty, isTrue);
      for (final r in results) {
        expect(
          r.title.toLowerCase().contains('bách khoa') ||
              r.address.toLowerCase().contains('bách khoa'),
          isTrue,
        );
      }
    });

    test('Filter text search by address', () async {
      final results = await repository.searchBoardingHouses(
        const BoardingHouseFilter(query: 'Hải Châu'),
      );
      expect(results.isNotEmpty, isTrue);
      for (final r in results) {
        expect(
          r.title.toLowerCase().contains('hải châu') ||
              r.address.toLowerCase().contains('hải châu'),
          isTrue,
        );
      }
    });

    test('Filter by price range (minPrice & maxPrice)', () async {
      final results = await repository.searchBoardingHouses(
        const BoardingHouseFilter(minPrice: 2000000, maxPrice: 3000000),
      );
      expect(results.isNotEmpty, isTrue);
      for (final r in results) {
        expect(r.monthlyPrice >= 2000000 && r.monthlyPrice <= 3000000, isTrue);
      }
    });

    test('Filter by area range (minArea & maxArea)', () async {
      final results = await repository.searchBoardingHouses(
        const BoardingHouseFilter(minArea: 20, maxArea: 30),
      );
      expect(results.isNotEmpty, isTrue);
      for (final r in results) {
        expect(r.area >= 20 && r.area <= 30, isTrue);
      }
    });

    test('Filter by single amenity', () async {
      final results = await repository.searchBoardingHouses(
        const BoardingHouseFilter(amenities: [RoomAmenity.airConditioner]),
      );
      expect(results.isNotEmpty, isTrue);
      for (final r in results) {
        expect(r.amenities.contains(RoomAmenity.airConditioner), isTrue);
      }
    });

    test('Filter by multiple amenities (room must contain ALL selected amenities)', () async {
      final results = await repository.searchBoardingHouses(
        const BoardingHouseFilter(
          amenities: [
            RoomAmenity.wifi,
            RoomAmenity.airConditioner,
            RoomAmenity.kitchen,
          ],
        ),
      );
      expect(results.isNotEmpty, isTrue);
      for (final r in results) {
        expect(r.amenities.contains(RoomAmenity.wifi), isTrue);
        expect(r.amenities.contains(RoomAmenity.airConditioner), isTrue);
        expect(r.amenities.contains(RoomAmenity.kitchen), isTrue);
      }
    });

    test('Filter by onlyAvailable returns only available rooms', () async {
      final results = await repository.searchBoardingHouses(
        const BoardingHouseFilter(onlyAvailable: true),
      );
      expect(results.isNotEmpty, isTrue);
      for (final r in results) {
        expect(r.isAvailable, isTrue);
      }
    });

    test('Sort by price low to high', () async {
      final results = await repository.searchBoardingHouses(
        const BoardingHouseFilter(sortOption: RoomSortOption.priceLowToHigh),
      );
      expect(results.isNotEmpty, isTrue);
      for (int i = 0; i < results.length - 1; i++) {
        expect(results[i].monthlyPrice <= results[i + 1].monthlyPrice, isTrue);
      }
    });

    test('Sort by price high to low', () async {
      final results = await repository.searchBoardingHouses(
        const BoardingHouseFilter(sortOption: RoomSortOption.priceHighToLow),
      );
      expect(results.isNotEmpty, isTrue);
      for (int i = 0; i < results.length - 1; i++) {
        expect(results[i].monthlyPrice >= results[i + 1].monthlyPrice, isTrue);
      }
    });

    test('Sort by nearest', () async {
      final results = await repository.searchBoardingHouses(
        const BoardingHouseFilter(sortOption: RoomSortOption.nearest),
      );
      expect(results.isNotEmpty, isTrue);
      for (int i = 0; i < results.length - 1; i++) {
        expect(results[i].mockDistanceKm <= results[i + 1].mockDistanceKm, isTrue);
      }
    });

    test('Sort by newest', () async {
      final results = await repository.searchBoardingHouses(
        const BoardingHouseFilter(sortOption: RoomSortOption.newest),
      );
      expect(results.isNotEmpty, isTrue);
      for (int i = 0; i < results.length - 1; i++) {
        expect(
          results[i].createdAt.isAfter(results[i + 1].createdAt) ||
              results[i].createdAt.isAtSameMomentAs(results[i + 1].createdAt),
          isTrue,
        );
      }
    });

    test('Reset filters preserves query and sortOption', () {
      const filter = BoardingHouseFilter(
        query: 'Đà Nẵng',
        minPrice: 1000000,
        maxPrice: 3000000,
        minArea: 15,
        maxArea: 35,
        amenities: [RoomAmenity.wifi, RoomAmenity.parking],
        onlyAvailable: true,
        sortOption: RoomSortOption.priceLowToHigh,
      );

      final reset = filter.clearFilters();
      expect(reset.query, 'Đà Nẵng');
      expect(reset.sortOption, RoomSortOption.priceLowToHigh);
      expect(reset.minPrice, isNull);
      expect(reset.maxPrice, isNull);
      expect(reset.minArea, isNull);
      expect(reset.maxArea, isNull);
      expect(reset.amenities.isEmpty, isTrue);
      expect(reset.onlyAvailable, isFalse);
      expect(reset.hasActiveFilters, isFalse);
    });

    test('Returns empty list when criteria match no rooms', () async {
      final results = await repository.searchBoardingHouses(
        const BoardingHouseFilter(
          query: 'Cụm từ không hề tồn tại xyz123',
        ),
      );
      expect(results.isEmpty, isTrue);
    });
  });
}