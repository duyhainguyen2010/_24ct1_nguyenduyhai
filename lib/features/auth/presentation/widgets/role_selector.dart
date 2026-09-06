import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../domain/models/user_role.dart';

/// Reusable role selector between Tenant and Owner.
class RoleSelector extends StatelessWidget {
  final UserRole selectedRole;
  final ValueChanged<UserRole> onRoleChanged;

  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bạn tham gia với vai trò:',
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        Row(
          children: [
            Expanded(
              child: _RoleCard(
                title: 'Khách thuê',
                subtitle: 'Tìm và thuê phòng',
                icon: Icons.person_search_outlined,
                isSelected: selectedRole == UserRole.tenant,
                onTap: () => onRoleChanged(UserRole.tenant),
              ),
            ),
            const SizedBox(width: AppDimensions.spacingMd),
            Expanded(
              child: _RoleCard(
                title: 'Chủ trọ',
                subtitle: 'Đăng tin cho thuê',
                icon: Icons.apartment_outlined,
                isSelected: selectedRole == UserRole.owner,
                onTap: () => onRoleChanged(UserRole.owner),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? AppColors.primary : AppColors.border;
    final bgColor = isSelected ? AppColors.primaryLight : AppColors.surface;

    return InkWell(
      onTap: onTap,
      borderRadius: AppDimensions.borderRadiusMd,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: isSelected ? 2.0 : 1.0),
          borderRadius: AppDimensions.borderRadiusMd,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
              size: AppDimensions.iconLg,
            ),
            const SizedBox(height: AppDimensions.spacingXs),
            Text(
              title,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: AppTypography.caption.copyWith(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
