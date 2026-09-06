import '../models/boarding_house.dart';

/// Contract for querying boarding house listings.
abstract class BoardingHouseRepository {
  /// Fetches featured listings for high-visibility carousels.
  Future<List<BoardingHouse>> getFeaturedBoardingHouses();

  /// Fetches listings close to the user location (with mock distance).
  Future<List<BoardingHouse>> getNearbyBoardingHouses();

  /// Fetches recently published boarding houses.
  Future<List<BoardingHouse>> getRecentBoardingHouses();

  /// Fetches a single listing by its identifier.
  Future<BoardingHouse?> getBoardingHouseById(String id);
}
