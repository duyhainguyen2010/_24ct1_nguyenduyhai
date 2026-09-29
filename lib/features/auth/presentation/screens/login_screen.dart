import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/utils/validators.dart';
import '../notifiers/auth_scope.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_auth_button.dart';

/// Clean, responsive Login Screen.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authNotifier = AuthScope.of(context);
    final success = await authNotifier.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;
    if (!success && authNotifier.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authNotifier.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _handleGoogleLogin() async {
    final authNotifier = AuthScope.of(context);
    final success = await authNotifier.loginWithGoogle();

    if (!mounted) return;
    if (!success && authNotifier.errorMessage != null) {
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing2Xl,
              vertical: AppDimensions.spacingLg,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppDimensions.maxContentWidth,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Brand header
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.home_work_rounded,
                        size: 36,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingLg),
                    const Text(
                      'Đăng nhập',
                      style: AppTypography.heading1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.spacingXs),
                    Text(
                      'Chào mừng bạn trở lại với Tìm Trọ Sinh Viên',
                      style: AppTypography.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.spacing3Xl),

                    // Quick Demo hint banner
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.spacingMd),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryLight,
                        borderRadius: AppDimensions.borderRadiusSm,
                        border: Border.all(
                          color: AppColors.secondary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 20,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: AppDimensions.spacingSm),
                          Expanded(
                            child: Text(
                              'Tài khoản mẫu: tenant@example.com / password123',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingLg),

                    // Email Field
                    AuthTextField(
                      controller: _emailController,
                      label: 'Email',
                      hintText: 'vidu@sinhvien.edu.vn',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppDimensions.spacingLg),

                    // Password Field
                    AuthTextField(
                      controller: _passwordController,
                      label: 'Mật khẩu',
                      hintText: 'Nhập mật khẩu',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      validator: Validators.validatePassword,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppDimensions.spacingSm),

                    // Forgot Password link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: isLoading
                            ? null
                            : () => Navigator.pushNamed(
                                context,
                                AppRoutes.forgotPassword,
                              ),
                        child: Text(
                          'Quên mật khẩu?',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingMd),

                    // Submit Button
                    ElevatedButton(
                      onPressed: isLoading ? null : _handleLogin,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Đăng nhập'),
                    ),
                    const SizedBox(height: AppDimensions.spacingLg),

                    // Divider
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacingMd,
                          ),
                          child: Text('hoặc', style: AppTypography.caption),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacingLg),

                    // Google Login Button
                    SocialAuthButton(
                      onPressed: _handleGoogleLogin,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: AppDimensions.spacing2Xl),

                    // Register Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Chưa có tài khoản? ',
                          style: AppTypography.bodySmall,
                        ),
                        GestureDetector(
                          onTap: isLoading
                              ? null
                              : () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.register,
                                ),
                          child: Text(
                            'Đăng ký ngay',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
