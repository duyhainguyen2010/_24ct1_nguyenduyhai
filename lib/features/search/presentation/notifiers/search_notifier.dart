import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../boarding_house/domain/models/boarding_house.dart';
import '../../../boarding_house/domain/models/boarding_house_filter.dart';
import '../../../boarding_house/domain/models/room_amenity.dart';
import '../../../boarding_house/domain/models/room_sort_option.dart';
import '../../../boarding_house/domain/repositories/boarding_house_repository.dart';

/// Pure Flutter state management for Search and Filter using ChangeNotifier.
class SearchNotifier extends ChangeNotifier {
  final BoardingHouseRepository _repository;

  BoardingHouseFilter _filter = const BoardingHouseFilter();
  List<BoardingHouse> _results = [];
  bool _isLoading = false;
  String? _errorMessage;

  Timer? _debounceTimer;

  SearchNotifier({required BoardingHouseRepository repository})
      : _repository = repository {
    // Initial fetch of all listings
    search();
  }

  BoardingHouseFilter get filter => _filter;
  List<BoardingHouse> get results => _results;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get totalCount => _results.length;

  /// Updates text query with a short debounce to avoid spamming the repository.
  void setQuery(String query) {
    _filter = _filter.copyWith(query: query);
    notifyListeners();

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      search();
    });
  }

  /// Changes the sort option and immediately triggers a search.
  void setSortOption(RoomSortOption sortOption) {
    if (_filter.sortOption == sortOption) return;
    _filter = _filter.copyWith(sortOption: sortOption);
    search();
  }

  /// Replaces active filter criteria and executes search.
  void applyFilter(BoardingHouseFilter newFilter) {
    _filter = newFilter;
    search();
  }

  /// Removes an individual amenity filter and refreshes.
  void removeAmenity(RoomAmenity amenity) {
    final updatedAmenities = List<RoomAmenity>.from(_filter.amenities)..remove(amenity);
    _filter = _filter.copyWith(amenities: updatedAmenities);
    search();
  }

  /// Clears price range filter and refreshes.
  void clearPriceFilter() {
    _filter = _filter.copyWith(minPrice: null, maxPrice: null);
    search();
  }

  /// Clears area range filter and refreshes.
  void clearAreaFilter() {
    _filter = _filter.copyWith(minArea: null, maxArea: null);
    search();
  }

  /// Clears onlyAvailable filter and refreshes.
  void clearAvailabilityFilter() {
    _filter = _filter.copyWith(onlyAvailable: false);
    search();
  }

  /// Resets all filters back to defaults (keeping existing query string).
  void resetAllFilters() {
    _filter = _filter.clearFilters();
    search();
  }

  /// Performs the search against the repository.
  Future<void> search() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _repository.searchBoardingHouses(_filter);
      _results = data;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Lỗi tìm kiếm: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

