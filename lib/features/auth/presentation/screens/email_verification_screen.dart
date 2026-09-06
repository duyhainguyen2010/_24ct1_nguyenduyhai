import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../notifiers/auth_scope.dart';

/// Screen requiring email verification before accessing the application shell.
class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  Future<void> _handleCheck(BuildContext context) async {
    final authNotifier = AuthScope.of(context);
    final isVerified = await authNotifier.checkEmailVerification();

    if (!context.mounted) return;
    if (!isVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email vẫn chưa được xác thực. Vui lòng kiểm tra hộp thư hoặc thư rác.'),
          backgroundColor: AppColors.warning,
        ),
      );
    }
  }

  Future<void> _handleResend(BuildContext context) async {
    final authNotifier = AuthScope.of(context);
    final success = await authNotifier.sendEmailVerification();

    if (!context.mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authNotifier.successMessage ?? 'Đã gửi lại email xác thực!'),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (authNotifier.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authNotifier.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = AuthScope.of(context);
    final user = authNotifier.user;
    final isLoading = authNotifier.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác thực Email'),
        actions: [
          IconButton(
            tooltip: 'Đăng xuất',
            icon: const Icon(Icons.logout),
            onPressed: isLoading ? null : () => authNotifier.logout(),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing2Xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppDimensions.maxContentWidth),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.mark_email_unread_outlined,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingXl),
                  const Text(
                    'Xác nhận địa chỉ email',
                    style: AppTypography.heading2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),
                  Text(
                    'Chúng tôi đã gửi một liên kết xác thực tới:\n${user?.email ?? ""}\n\nVui lòng kiểm tra hộp thư và nhấp vào liên kết để kích hoạt tài khoản.',
                    style: AppTypography.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spacing3Xl),

                  // Button to check verification
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : () => _handleCheck(context),
                    icon: const Icon(Icons.check_circle_outline, size: AppDimensions.iconSm),
                    label: isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Tôi đã xác thực (Kiểm tra lại)'),
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),

                  // Resend email
                  OutlinedButton.icon(
                    onPressed: isLoading ? null : () => _handleResend(context),
                    icon: const Icon(Icons.refresh, size: AppDimensions.iconSm),
                    label: const Text('Gửi lại email xác thực'),
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),

                  TextButton(
                    onPressed: isLoading ? null : () => authNotifier.logout(),
                    child: const Text('Đăng nhập bằng tài khoản khác'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
