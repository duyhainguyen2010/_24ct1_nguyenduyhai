import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../boarding_house/domain/models/boarding_house.dart';
import '../../../home/presentation/widgets/room_image_placeholder.dart';
import '../../../room_detail/presentation/widgets/amenity_helper.dart';

/// Card rendering a single boarding house search result item.
class SearchResultCard extends StatelessWidget {
  final BoardingHouse boardingHouse;
  final VoidCallback onTap;

  const SearchResultCard({
    super.key,
    required this.boardingHouse,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final item = boardingHouse;

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image thumbnail
                  ClipRRect(
                    borderRadius: AppDimensions.borderRadiusSm,
                    child: RoomImagePlaceholder(
                      roomId: item.id,
                      height: 85.0,
                      width: 85.0,
                      icon: Icons.hotel_rounded,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingMd),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price and Availability
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.formattedPrice,
                              style: AppTypography.heading3.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 2.0,
                              ),
                              decoration: BoxDecoration(
                                color: item.isAvailable
                                    ? AppColors.success.withValues(alpha: 0.1)
                                    : AppColors.error.withValues(alpha: 0.1),
                                borderRadius: AppDimensions.borderRadiusSm,
                              ),
                              child: Text(
                                item.isAvailable ? 'Còn phòng' : 'Hết phòng',
                                style: AppTypography.caption.copyWith(
                                  color: item.isAvailable ? AppColors.success : AppColors.error,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacingXs),

                        // Title
                        Text(
                          item.title,
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppDimensions.spacingXs),

                        // Address
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
                                item.address,
                                style: AppTypography.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              const Divider(),
              const SizedBox(height: AppDimensions.spacingXs),

              // Bottom features row: Area, Distance, Amenities preview
              Row(
                children: [
                  Text(
                    item.formattedArea,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  const Text('•', style: TextStyle(color: AppColors.border)),
                  const SizedBox(width: AppDimensions.spacingSm),
                  Text(
                    item.formattedDistance,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),

                  // Preview up to 3 amenity icons
                  ...item.amenities.take(3).map((amenity) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Tooltip(
                        message: AmenityHelper.getLabel(amenity),
                        child: Icon(
                          AmenityHelper.getIcon(amenity),
                          size: 16.0,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }),
                  if (item.amenities.length > 3)
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        '+${item.amenities.length - 3}',
                        style: AppTypography.caption.copyWith(
                          fontSize: 10,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
