import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';

/// Clean description section displaying room information and rules.
class RoomDescriptionSection extends StatelessWidget {
  final String description;

  const RoomDescriptionSection({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mô tả chi tiết',
          style: AppTypography.heading3,
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        Text(
          description.isNotEmpty
              ? description
              : 'Chưa có thông tin mô tả chi tiết cho phòng trọ này.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
