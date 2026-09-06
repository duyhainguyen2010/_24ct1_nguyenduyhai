import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../boarding_house/domain/models/boarding_house.dart';
import '../../../home/presentation/widgets/room_image_placeholder.dart';

/// Top image carousel supporting multiple visual placeholders,
/// dot indicator, back button, and local favorite toggle.
class RoomDetailImageCarousel extends StatefulWidget {
  final BoardingHouse boardingHouse;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const RoomDetailImageCarousel({
    super.key,
    required this.boardingHouse,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  State<RoomDetailImageCarousel> createState() => _RoomDetailImageCarouselState();
}

class _RoomDetailImageCarouselState extends State<RoomDetailImageCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  static const int _mockImageCount = 3;

  static const List<IconData> _imageIcons = [
    Icons.apartment_rounded,
    Icons.bedroom_parent_outlined,
    Icons.balcony_outlined,
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280.0,
      child: Stack(
        children: [
          // Swipeable Image Carousel
          PageView.builder(
            controller: _pageController,
            itemCount: _mockImageCount,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return RoomImagePlaceholder(
                roomId: '${widget.boardingHouse.id}-$index',
                height: 280.0,
                icon: _imageIcons[index % _imageIcons.length],
              );
            },
          ),

          // Top Action Buttons (Back + Favorite)
          Positioned(
            top: MediaQuery.of(context).padding.top + AppDimensions.spacingSm,
            left: AppDimensions.spacingLg,
            right: AppDimensions.spacingLg,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  child: IconButton(
                    icon: Icon(
                      widget.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: widget.isFavorite ? AppColors.error : AppColors.textPrimary,
                    ),
                    onPressed: widget.onFavoriteToggle,
                  ),
                ),
              ],
            ),
          ),

          // Page Dot Indicator
          Positioned(
            bottom: AppDimensions.spacingMd,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_mockImageCount, (index) {
                final isSelected = _currentPage == index;
                return Container(
                  width: isSelected ? 18.0 : 6.0,
                  height: 6.0,
                  margin: const EdgeInsets.symmetric(horizontal: 3.0),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                );
              }),
            ),
          ),

          // Photo Counter Badge
          Positioned(
            bottom: AppDimensions.spacingMd,
            right: AppDimensions.spacingLg,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: AppDimensions.borderRadiusSm,
              ),
              child: Text(
                '${_currentPage + 1}/$_mockImageCount',
                style: AppTypography.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
