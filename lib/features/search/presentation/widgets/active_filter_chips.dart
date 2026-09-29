import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../boarding_house/domain/models/boarding_house_filter.dart';
import '../../../boarding_house/domain/models/room_amenity.dart';
import '../../../room_detail/presentation/widgets/amenity_helper.dart';

/// Removable chips representing active filters with a "Đặt lại tất cả" action.
class ActiveFilterChips extends StatelessWidget {
  final BoardingHouseFilter filter;
  final VoidCallback onClearPrice;
  final VoidCallback onClearArea;
  final ValueChanged<RoomAmenity> onRemoveAmenity;
  final VoidCallback onClearAvailability;
  final VoidCallback onResetAll;

  const ActiveFilterChips({
    super.key,
    required this.filter,
    required this.onClearPrice,
    required this.onClearArea,
    required this.onRemoveAmenity,
    required this.onClearAvailability,
    required this.onResetAll,
  });

  String _formatPriceTag() {
    final min = filter.minPrice;
    final max = filter.maxPrice;
    if (min != null && max != null) {
      return '${(min / 1000000).toStringAsFixed(1)} - ${(max / 1000000).toStringAsFixed(1)} triệu';
    } else if (min != null) {
      return '>= ${(min / 1000000).toStringAsFixed(1)} triệu';
    } else if (max != null) {
      return '<= ${(max / 1000000).toStringAsFixed(1)} triệu';
    }
    return '';
  }

  String _formatAreaTag() {
    final min = filter.minArea;
    final max = filter.maxArea;
    if (min != null && max != null) {
      return '${min.toInt()} - ${max.toInt()} m²';
    } else if (min != null) {
      return '>= ${min.toInt()} m²';
    } else if (max != null) {
      return '<= ${max.toInt()} m²';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    if (!filter.hasActiveFilters) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Price filter tag
          if ((filter.minPrice != null && filter.minPrice! > 0) || filter.maxPrice != null)
            _ChipItem(
              label: _formatPriceTag(),
              onDeleted: onClearPrice,
            ),

          // Area filter tag
          if ((filter.minArea != null && filter.minArea! > 0) || filter.maxArea != null)
            _ChipItem(
              label: _formatAreaTag(),
              onDeleted: onClearArea,
            ),

          // Availability tag
          if (filter.onlyAvailable)
            _ChipItem(
              label: 'Còn phòng',
              onDeleted: onClearAvailability,
            ),

          // Amenity filter tags (each amenity is individually removable)
          ...filter.amenities.map(
            (amenity) => _ChipItem(
              label: AmenityHelper.getLabel(amenity),
              onDeleted: () => onRemoveAmenity(amenity),
            ),
          ),

          // Reset all text button
          TextButton(
            onPressed: onResetAll,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingSm),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Xóa tất cả',
              style: AppTypography.caption.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipItem extends StatelessWidget {
  final String label;
  final VoidCallback onDeleted;

  const _ChipItem({
    required this.label,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppDimensions.spacingSm),
      child: Chip(
        label: Text(label),
        labelStyle: AppTypography.caption.copyWith(
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: AppColors.primaryLight,
        side: BorderSide.none,
        deleteIcon: const Icon(Icons.close_rounded, size: 14, color: AppColors.primaryDark),
        onDeleted: onDeleted,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
      ),
    );
  }
}
