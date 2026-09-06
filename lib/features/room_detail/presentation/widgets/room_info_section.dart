import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../boarding_house/domain/models/boarding_house.dart';

/// Pricing, availability badge, title, address, area, and mock distance.
class RoomInfoSection extends StatelessWidget {
  final BoardingHouse boardingHouse;

  const RoomInfoSection({
    super.key,
    required this.boardingHouse,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price & Status Badge
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              boardingHouse.formattedPrice,
              style: AppTypography.heading1.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingMd,
                vertical: AppDimensions.spacingXs,
              ),
              decoration: BoxDecoration(
                color: boardingHouse.isAvailable
                    ? AppColors.success.withValues(alpha: 0.12)
                    : AppColors.error.withValues(alpha: 0.12),
                borderRadius: AppDimensions.borderRadiusSm,
                border: Border.all(
                  color: boardingHouse.isAvailable ? AppColors.success : AppColors.error,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    boardingHouse.isAvailable
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                    size: 14,
                    color: boardingHouse.isAvailable ? AppColors.success : AppColors.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    boardingHouse.isAvailable ? 'Còn phòng' : 'Hết phòng',
                    style: AppTypography.caption.copyWith(
                      color: boardingHouse.isAvailable ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingSm),

        // Title
        Text(
          boardingHouse.title,
          style: AppTypography.heading2,
        ),
        const SizedBox(height: AppDimensions.spacingSm),

        // Address
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 18,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppDimensions.spacingXs),
            Expanded(
              child: Text(
                boardingHouse.address,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingMd),

        // Key stats row (Area, Distance, Featured)
        Wrap(
          spacing: AppDimensions.spacingSm,
          runSpacing: AppDimensions.spacingSm,
          children: [
            _StatChip(
              icon: Icons.aspect_ratio_rounded,
              label: 'Diện tích: ${boardingHouse.formattedArea}',
            ),
            _StatChip(
              icon: Icons.near_me_outlined,
              label: 'Cách đây: ${boardingHouse.formattedDistance}',
            ),
            if (boardingHouse.isFeatured)
              const _StatChip(
                icon: Icons.star_rounded,
                label: 'Phòng nổi bật',
                color: AppColors.primaryLight,
                textColor: AppColors.primaryDark,
              ),
          ],
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final Color? textColor;

  const _StatChip({
    required this.icon,
    required this.label,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMd,
        vertical: 6.0,
      ),
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: AppDimensions.borderRadiusSm,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor ?? AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: textColor ?? AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
