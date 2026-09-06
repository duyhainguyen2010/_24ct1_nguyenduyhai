import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../notifiers/auth_scope.dart';
import '../widgets/auth_text_field.dart';

/// Screen allowing authenticated users to change their password.
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final authNotifier = AuthScope.of(context);
    final success = await authNotifier.changePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
    );

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authNotifier.successMessage ?? 'Đổi mật khẩu thành công!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
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
    final isLoading = authNotifier.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đổi mật khẩu'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing2Xl,
              vertical: AppDimensions.spacingLg,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppDimensions.maxContentWidth),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Tạo mật khẩu mới',
                      style: AppTypography.heading2,
                    ),
                    const SizedBox(height: AppDimensions.spacingXs),
                    Text(
                      'Mật khẩu mới phải có ít nhất 6 ký tự, gồm chữ và số',
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: AppDimensions.spacing2Xl),

                    // Current password
                    AuthTextField(
                      controller: _currentPasswordController,
                      label: 'Mật khẩu hiện tại',
                      hintText: 'Nhập mật khẩu hiện tại',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Vui lòng nhập mật khẩu hiện tại';
                        }
                        return null;
                      },
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppDimensions.spacingLg),

                    // New password
                    AuthTextField(
                      controller: _newPasswordController,
                      label: 'Mật khẩu mới',
                      hintText: 'Nhập mật khẩu mới',
                      prefixIcon: Icons.lock_reset,
                      isPassword: true,
                      validator: Validators.validatePassword,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppDimensions.spacingLg),

                    // Confirm new password
                    AuthTextField(
                      controller: _confirmPasswordController,
                      label: 'Xác nhận mật khẩu mới',
                      hintText: 'Nhập lại mật khẩu mới',
                      prefixIcon: Icons.lock_reset,
                      isPassword: true,
                      validator: (val) => Validators.validateConfirmPassword(
                        val,
                        _newPasswordController.text,
                      ),
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppDimensions.spacing2Xl),

                    ElevatedButton(
                      onPressed: isLoading ? null : _handleChangePassword,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Cập nhật mật khẩu'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
