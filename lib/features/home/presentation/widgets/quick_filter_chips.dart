import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';

/// Visual filter chips acting as shortcuts on Home.
class QuickFilterChips extends StatelessWidget {
  final ValueChanged<String>? onFilterSelected;

  const QuickFilterChips({
    super.key,
    this.onFilterSelected,
  });

  static const List<Map<String, dynamic>> _filters = [
    {'label': 'Gần tôi', 'icon': Icons.near_me_outlined},
    {'label': 'Dưới 2 triệu', 'icon': Icons.payments_outlined},
    {'label': '2 - 3 triệu', 'icon': Icons.account_balance_wallet_outlined},
    {'label': 'Có máy lạnh', 'icon': Icons.ac_unit_outlined},
    {'label': 'Có chỗ để xe', 'icon': Icons.two_wheeler_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((filter) {
          final label = filter['label'] as String;
          final icon = filter['icon'] as IconData;

          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spacingSm),
            child: ActionChip(
              avatar: Icon(icon, size: AppDimensions.iconSm, color: AppColors.primary),
              label: Text(label),
              labelStyle: AppTypography.caption.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: AppColors.surface,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              onPressed: () {
                if (onFilterSelected != null) {
                  onFilterSelected!(label);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Bộ lọc "$label" sẽ áp dụng trong module Tìm kiếm.'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

