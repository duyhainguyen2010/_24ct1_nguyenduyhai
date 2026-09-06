import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../boarding_house/domain/models/boarding_house.dart';

/// Compact visual map preview showing location coordinates and map explore CTA.
class RoomLocationPreview extends StatelessWidget {
  final BoardingHouse boardingHouse;
  final VoidCallback onMapTap;

  const RoomLocationPreview({
    super.key,
    required this.boardingHouse,
    required this.onMapTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Vị trí phòng trọ',
              style: AppTypography.heading3,
            ),
            TextButton(
              onPressed: onMapTap,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Xem trên bản đồ',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        InkWell(
          onTap: onMapTap,
          borderRadius: AppDimensions.borderRadiusMd,
          child: Container(
            height: 120.0,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0FE),
              borderRadius: AppDimensions.borderRadiusMd,
              border: Border.all(color: AppColors.border),
            ),
            child: Stack(
              children: [
                // Subtle map grid background representation
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.spacingSm),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingXs),
                      Text(
                        'Tọa độ: (${boardingHouse.latitude.toStringAsFixed(4)}, ${boardingHouse.longitude.toStringAsFixed(4)})',
                        style: AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Chạm để xem bản đồ chi tiết',
                        style: AppTypography.caption.copyWith(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
