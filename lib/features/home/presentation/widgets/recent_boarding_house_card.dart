import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../boarding_house/domain/models/boarding_house.dart';
import 'room_image_placeholder.dart';

/// Clean vertical list item for recently added listings.
class RecentBoardingHouseCard extends StatelessWidget {
  final BoardingHouse boardingHouse;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;

  const RecentBoardingHouseCard({
    super.key,
    required this.boardingHouse,
    required this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingMd),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: AppDimensions.borderRadiusSm,
                child: RoomImagePlaceholder(
                  roomId: boardingHouse.id,
                  height: 90.0,
                  width: 90.0,
                  icon: Icons.hotel_rounded,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            boardingHouse.formattedPrice,
                            style: AppTypography.heading3.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.favorite_border_rounded,
                            size: 20,
                            color: AppColors.textSecondary,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: onFavoriteTap ??
                              () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Tính năng lưu yêu thích sẽ sớm ra mắt.'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacingXs),
                    Text(
                      boardingHouse.title,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.spacingXs),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            boardingHouse.address,
                            style: AppTypography.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacingSm),
                    Row(
                      children: [
                        Text(
                          boardingHouse.formattedArea,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spacingSm),
                        const Text('•', style: TextStyle(color: AppColors.border)),
                        const SizedBox(width: AppDimensions.spacingSm),
                        Text(
                          boardingHouse.formattedDistance,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
