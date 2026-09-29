import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/error_state_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../boarding_house/data/mock_boarding_house_repository.dart';
import '../../../boarding_house/domain/models/boarding_house.dart';
import '../../../boarding_house/domain/repositories/boarding_house_repository.dart';
import '../notifiers/search_notifier.dart';
import '../widgets/active_filter_chips.dart';
import '../widgets/search_filter_sheet.dart';
import '../widgets/search_input.dart';
import '../widgets/search_result_card.dart';
import '../widgets/sort_selector.dart';

/// Complete Search & Filter screen.
class SearchScreen extends StatefulWidget {
  final BoardingHouseRepository? repository;
  final String? initialQuery;

  const SearchScreen({
    super.key,
    this.repository,
    this.initialQuery,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final SearchNotifier _notifier;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _notifier = SearchNotifier(
      repository: widget.repository ?? MockBoardingHouseRepository(),
    );
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _notifier.setQuery(widget.initialQuery!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _notifier.dispose();
    super.dispose();
  }

  void _openFilterSheet() {
    SearchFilterSheet.show(
      context,
      currentFilter: _notifier.filter,
      onApply: (newFilter) {
        _notifier.applyFilter(newFilter);
      },
    );
  }

  void _handleCardTap(BoardingHouse item) {
    Navigator.pushNamed(
      context,
      AppRoutes.roomDetail,
      arguments: item,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _notifier,
          builder: (context, _) {
            final filter = _notifier.filter;
            final results = _notifier.results;
            final isLoading = _notifier.isLoading;
            final errorMessage = _notifier.errorMessage;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimensions.spacingMd),

                  // 1. Top Search Bar & Filter trigger
                  SearchInput(
                    controller: _searchController,
                    onChanged: (val) => _notifier.setQuery(val),
                    onClear: () {
                      _searchController.clear();
                      _notifier.setQuery('');
                    },
                    onFilterTap: _openFilterSheet,
                    activeFilterCount: filter.activeFilterCount,
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),

                  // 2. Active filter chips
                  if (filter.hasActiveFilters) ...[
                    ActiveFilterChips(
                      filter: filter,
                      onClearPrice: _notifier.clearPriceFilter,
                      onClearArea: _notifier.clearAreaFilter,
                      onRemoveAmenity: _notifier.removeAmenity,
                      onClearAvailability: _notifier.clearAvailabilityFilter,
                      onResetAll: _notifier.resetAllFilters,
                    ),
                    const SizedBox(height: AppDimensions.spacingSm),
                  ],

                  // 3. Results count and Sort Selector
                  SortSelector(
                    totalCount: _notifier.totalCount,
                    currentSort: filter.sortOption,
                    onSortChanged: (option) => _notifier.setSortOption(option),
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),

                  // 4. Content state (Loading, Error, Empty, List)
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (isLoading && results.isEmpty) {
                          return const LoadingIndicator(
                            message: 'Đang tìm kiếm phòng trọ...',
                          );
                        }

                        if (errorMessage != null) {
                          return ErrorStateView(
                            message: errorMessage,
                            onRetry: () => _notifier.search(),
                          );
                        }

                        if (results.isEmpty) {
                          return EmptyStateView(
                            icon: Icons.search_off_rounded,
                            title: 'Không tìm thấy phòng trọ',
                            description:
                                'Thử thay đổi từ khóa hoặc điều chỉnh khoảng giá, tiện ích trong bộ lọc.',
                            action: filter.hasActiveFilters
                                ? OutlinedButton(
                                    onPressed: _notifier.resetAllFilters,
                                    child: const Text('Xóa bộ lọc'),
                                  )
                                : null,
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: () => _notifier.search(),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(
                              top: AppDimensions.spacingSm,
                              bottom: AppDimensions.spacing2Xl,
                            ),
                            itemCount: results.length,
                            itemBuilder: (context, index) {
                              final item = results[index];
                              return SearchResultCard(
                                boardingHouse: item,
                                onTap: () => _handleCardTap(item),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
