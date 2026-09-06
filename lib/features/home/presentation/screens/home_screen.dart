import '../../../../core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/error_state_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../boarding_house/data/mock_boarding_house_repository.dart';
import '../../../boarding_house/domain/models/boarding_house.dart';
import '../../../boarding_house/domain/repositories/boarding_house_repository.dart';
import '../widgets/featured_boarding_house_card.dart';
import '../widgets/home_header.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/map_discovery_card.dart';
import '../widgets/nearby_boarding_house_card.dart';
import '../widgets/quick_filter_chips.dart';
import '../widgets/recent_boarding_house_card.dart';
import '../widgets/section_header.dart';

/// Complete, polished Home screen for boarding house discovery.
class HomeScreen extends StatefulWidget {
  final BoardingHouseRepository? repository;
  final ValueChanged<int>? onNavigateToTab;

  const HomeScreen({
    super.key,
    this.repository,
    this.onNavigateToTab,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final BoardingHouseRepository _repository;

  bool _isLoading = true;
  String? _errorMessage;

  List<BoardingHouse> _featuredList = [];
  List<BoardingHouse> _nearbyList = [];
  List<BoardingHouse> _recentList = [];

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? MockBoardingHouseRepository();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        _repository.getFeaturedBoardingHouses(),
        _repository.getNearbyBoardingHouses(),
        _repository.getRecentBoardingHouses(),
      ]);

      if (!mounted) return;

      setState(() {
        _featuredList = results[0];
        _nearbyList = results[1];
        _recentList = results[2];
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Không thể tải dữ liệu phòng trọ: $e';
        _isLoading = false;
      });
    }
  }

  void _navigateToSearch() {
    if (widget.onNavigateToTab != null) {
      widget.onNavigateToTab!(1); // Index 1 is Search
    }
  }

  void _navigateToMap() {
    if (widget.onNavigateToTab != null) {
      widget.onNavigateToTab!(2); // Index 2 is Map
    }
  }

  void _handleItemTap(BoardingHouse item) {
    Navigator.pushNamed(
      context,
      AppRoutes.roomDetail,
      arguments: item,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: LoadingIndicator(message: 'Đang tải danh sách phòng trọ...'),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: ErrorStateView(
          message: _errorMessage!,
          onRetry: _loadData,
        ),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header (User greeting + notifications)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
                child: HomeHeader(),
              ),
              const SizedBox(height: AppDimensions.spacingLg),

              // 2. Search Entry Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
                child: HomeSearchBar(
                  onTap: _navigateToSearch,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingLg),

              // 3. Quick Filter Shortcuts
              Padding(
                padding: const EdgeInsets.only(left: AppDimensions.spacingLg),
                child: QuickFilterChips(
                  onFilterSelected: (filter) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã chọn bộ lọc "$filter". Kết quả sẽ hiển thị trong Tìm kiếm.'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppDimensions.spacing2Xl),

              // 4. Featured Boarding Houses (Horizontal list)
              if (_featuredList.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
                  child: SectionHeader(
                    title: 'Phòng trọ nổi bật ⭐',
                    onActionTap: _navigateToSearch,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingMd),
                SizedBox(
                  height: 290.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
                    itemCount: _featuredList.length,
                    itemBuilder: (context, index) {
                      final item = _featuredList[index];
                      return FeaturedBoardingHouseCard(
                        boardingHouse: item,
                        onTap: () => _handleItemTap(item),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXl),
              ],

              // 5. Map Discovery CTA Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
                child: MapDiscoveryCard(
                  onTap: _navigateToMap,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing2Xl),

              // 6. Nearby Boarding Houses
              if (_nearbyList.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
                  child: SectionHeader(
                    title: 'Gần vị trí của bạn 📍',
                    onActionTap: _navigateToSearch,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingMd),
                SizedBox(
                  height: 215.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
                    itemCount: _nearbyList.length,
                    itemBuilder: (context, index) {
                      final item = _nearbyList[index];
                      return NearbyBoardingHouseCard(
                        boardingHouse: item,
                        onTap: () => _handleItemTap(item),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing2Xl),
              ],

              // 7. Recently Added Boarding Houses (Vertical list)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
                child: SectionHeader(
                  title: 'Mới đăng gần đây 🕒',
                  onActionTap: _navigateToSearch,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              if (_recentList.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(AppDimensions.spacing2Xl),
                  child: EmptyStateView(
                    title: 'Chưa có bài đăng nào',
                    description: 'Các bài đăng phòng trọ mới sẽ được cập nhật sớm.',
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
                  itemCount: _recentList.length,
                  itemBuilder: (context, index) {
                    final item = _recentList[index];
                    return RecentBoardingHouseCard(
                      boardingHouse: item,
                      onTap: () => _handleItemTap(item),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}


