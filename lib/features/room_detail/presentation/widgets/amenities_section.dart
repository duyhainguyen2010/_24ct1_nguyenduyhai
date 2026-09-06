import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../boarding_house/domain/models/room_amenity.dart';
import 'amenity_helper.dart';

/// Clean 2-column grid of room amenities with Material 3 icons.
class AmenitiesSection extends StatelessWidget {
  final List<RoomAmenity> amenities;

  const AmenitiesSection({
    super.key,
    required this.amenities,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tiện ích & Cơ sở vật chất',
          style: AppTypography.heading3,
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        if (amenities.isEmpty)
          Text(
            'Liên hệ chủ trọ để biết thêm chi tiết tiện ích.',
            style: AppTypography.bodySmall,
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: amenities.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3.5,
              crossAxisSpacing: AppDimensions.spacingMd,
              mainAxisSpacing: AppDimensions.spacingSm,
            ),
            itemBuilder: (context, index) {
              final amenity = amenities[index];
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingMd,
                  vertical: AppDimensions.spacingXs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppDimensions.borderRadiusSm,
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Icon(
                      AmenityHelper.getIcon(amenity),
                      size: 20.0,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppDimensions.spacingSm),
                    Expanded(
                      child: Text(
                        AmenityHelper.getLabel(amenity),
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
