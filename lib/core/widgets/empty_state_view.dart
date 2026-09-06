import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_strings.dart';
import '../constants/app_typography.dart';

/// Reusable widget for empty states.
class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final Widget? action;

  const EmptyStateView({
    super.key,
    this.icon = Icons.inbox_outlined,
    this.title = AppStrings.emptyData,
    this.description,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing2Xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingLg),
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppDimensions.iconXl,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            Text(
              title,
              style: AppTypography.heading3,
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: AppDimensions.spacingSm),
              Text(
                description!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: AppDimensions.spacing2Xl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
