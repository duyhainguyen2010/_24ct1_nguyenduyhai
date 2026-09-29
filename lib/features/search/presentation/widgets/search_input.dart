import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';

/// Top search bar with text input, clear action, and filter trigger button with badge.
class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onFilterTap;
  final int activeFilterCount;

  const SearchInput({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.onFilterTap,
    this.activeFilterCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters = activeFilterCount > 0;

    return Row(
      children: [
        // Text field
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppDimensions.borderRadiusMd,
              border: Border.all(color: AppColors.border),
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Tìm theo tên trọ, đường, quận...',
                hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: AppDimensions.iconSm),
                        onPressed: onClear,
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingMd,
                  vertical: AppDimensions.spacingMd,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingSm),

        // Filter button with badge
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton.filledTonal(
              onPressed: onFilterTap,
              style: IconButton.styleFrom(
                backgroundColor: hasActiveFilters ? AppColors.primaryLight : AppColors.surface,
                foregroundColor: hasActiveFilters ? AppColors.primaryDark : AppColors.textPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: AppDimensions.borderRadiusMd,
                  side: BorderSide(
                    color: hasActiveFilters ? AppColors.primary : AppColors.border,
                  ),
                ),
                padding: const EdgeInsets.all(AppDimensions.spacingMd),
              ),
              icon: const Icon(Icons.tune_rounded),
              tooltip: 'Bộ lọc',
            ),
            if (hasActiveFilters)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$activeFilterCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
