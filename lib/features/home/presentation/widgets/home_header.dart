import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../auth/presentation/notifiers/auth_scope.dart';

/// Top greeting header displaying current authenticated user's name and notification icon.
class HomeHeader extends StatelessWidget {
  final VoidCallback? onNotificationTap;

  const HomeHeader({
    super.key,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final authNotifier = AuthScope.of(context);
    final user = authNotifier.user;
    final displayName = user?.fullName.isNotEmpty == true ? user!.fullName : 'bạn sinh viên';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Xin chào, $displayName! 👋',
                style: AppTypography.heading2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppDimensions.spacingXs),
              Text(
                'Tìm trọ ưng ý, an tâm học tập',
                style: AppTypography.bodySmall,
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          onPressed: onNotificationTap ??
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thông báo sẽ được cập nhật ở các phiên bản tiếp theo.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
          style: IconButton.styleFrom(
            backgroundColor: AppColors.primaryLight,
            foregroundColor: AppColors.primaryDark,
          ),
          icon: const Icon(Icons.notifications_none_rounded),
          tooltip: 'Thông báo',
        ),
      ],
    );
  }
}
