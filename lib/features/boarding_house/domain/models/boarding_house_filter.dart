import 'room_amenity.dart';
import 'room_sort_option.dart';

/// Represents search and filter criteria for boarding houses.
class BoardingHouseFilter {
  final String? query;
  final double? minPrice;
  final double? maxPrice;
  final double? minArea;
  final double? maxArea;
  final List<RoomAmenity> amenities;
  final bool onlyAvailable;
  final RoomSortOption sortOption;

  const BoardingHouseFilter({
    this.query,
    this.minPrice,
    this.maxPrice,
    this.minArea,
    this.maxArea,
    this.amenities = const [],
    this.onlyAvailable = false,
    this.sortOption = RoomSortOption.newest,
  });

  /// True if any criteria other than text search and default sort are active.
  bool get hasActiveFilters =>
      (minPrice != null && minPrice! > 0) ||
      maxPrice != null ||
      (minArea != null && minArea! > 0) ||
      maxArea != null ||
      amenities.isNotEmpty ||
      onlyAvailable;

  /// Total count of active filter constraints.
  /// Matches individual filter criteria (price, area, individual amenities, and availability).
  int get activeFilterCount {
    int count = 0;
    if ((minPrice != null && minPrice! > 0) || maxPrice != null) count++;
    if ((minArea != null && minArea! > 0) || maxArea != null) count++;
    count += amenities.length;
    if (onlyAvailable) count++;
    return count;
  }

  /// Safe copyWith that supports explicitly setting nullable fields to null.
  BoardingHouseFilter copyWith({
    Object? query = _sentinel,
    Object? minPrice = _sentinel,
    Object? maxPrice = _sentinel,
    Object? minArea = _sentinel,
    Object? maxArea = _sentinel,
    List<RoomAmenity>? amenities,
    bool? onlyAvailable,
    RoomSortOption? sortOption,
  }) {
    return BoardingHouseFilter(
      query: identical(query, _sentinel) ? this.query : query as String?,
      minPrice: identical(minPrice, _sentinel) ? this.minPrice : minPrice as double?,
      maxPrice: identical(maxPrice, _sentinel) ? this.maxPrice : maxPrice as double?,
      minArea: identical(minArea, _sentinel) ? this.minArea : minArea as double?,
      maxArea: identical(maxArea, _sentinel) ? this.maxArea : maxArea as double?,
      amenities: amenities ?? this.amenities,
      onlyAvailable: onlyAvailable ?? this.onlyAvailable,
      sortOption: sortOption ?? this.sortOption,
    );
  }

  /// Returns a clean filter retaining only query and sortOption.
  BoardingHouseFilter clearFilters() {
    return BoardingHouseFilter(
      query: query,
      sortOption: sortOption,
      amenities: const [],
      onlyAvailable: false,
    );
  }
}

const Object _sentinel = Object();
