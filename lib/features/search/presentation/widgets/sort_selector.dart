import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../boarding_house/domain/models/room_sort_option.dart';
import 'sort_option_helper.dart';

/// Row showing the total result count and a dropdown for choosing RoomSortOption.
class SortSelector extends StatelessWidget {
  final int totalCount;
  final RoomSortOption currentSort;
  final ValueChanged<RoomSortOption> onSortChanged;

  const SortSelector({
    super.key,
    required this.totalCount,
    required this.currentSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Result count
        Text(
          '$totalCount kết quả',
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),

        // Sort menu
        PopupMenuButton<RoomSortOption>(
          initialValue: currentSort,
          onSelected: onSortChanged,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusSm,
            side: const BorderSide(color: AppColors.border),
          ),
          itemBuilder: (context) {
            return RoomSortOption.values.map((option) {
              final isSelected = option == currentSort;
              return PopupMenuItem<RoomSortOption>(
                value: option,
                child: Row(
                  children: [
                    Icon(
                      SortOptionHelper.getIcon(option),
                      size: AppDimensions.iconSm,
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppDimensions.spacingSm),
                    Text(
                      SortOptionHelper.getLabel(option),
                      style: AppTypography.bodyMedium.copyWith(
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingMd,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppDimensions.borderRadiusSm,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  SortOptionHelper.getIcon(currentSort),
                  size: 14.0,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4.0),
                Text(
                  SortOptionHelper.getLabel(currentSort),
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 2.0),
                const Icon(
                  Icons.arrow_drop_down_rounded,
                  size: 18.0,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
