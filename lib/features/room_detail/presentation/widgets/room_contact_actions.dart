import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../boarding_house/domain/models/boarding_house.dart';

/// Sticky bottom contact actions ("Gọi chủ trọ", "Nhắn tin").
class RoomContactActions extends StatelessWidget {
  final BoardingHouse boardingHouse;

  const RoomContactActions({
    super.key,
    required this.boardingHouse,
  });

  void _showFeedback(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action với "${boardingHouse.ownerName}" (${boardingHouse.ownerPhone}) sẽ khả dụng ở phiên bản tiếp theo.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppDimensions.spacingLg,
        right: AppDimensions.spacingLg,
        top: AppDimensions.spacingMd,
        bottom: MediaQuery.of(context).padding.bottom + AppDimensions.spacingMd,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          top: BorderSide(color: AppColors.border),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Message Button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showFeedback(context, 'Tính năng nhắn tin'),
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: AppDimensions.iconSm),
              label: const Text('Nhắn tin'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingMd),
                shape: RoundedRectangleBorder(
                  borderRadius: AppDimensions.borderRadiusSm,
                ),
                textStyle: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingMd),

          // Call Button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showFeedback(context, 'Tính năng gọi điện'),
              icon: const Icon(Icons.phone_in_talk_rounded, size: AppDimensions.iconSm),
              label: const Text('Gọi chủ trọ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingMd),
                shape: RoundedRectangleBorder(
                  borderRadius: AppDimensions.borderRadiusSm,
                ),
                textStyle: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
