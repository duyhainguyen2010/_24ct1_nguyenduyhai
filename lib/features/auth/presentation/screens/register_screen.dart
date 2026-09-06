import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/models/user_role.dart';
import '../notifiers/auth_scope.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/role_selector.dart';

/// Clean Register Screen supporting Tenant and Owner roles.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  UserRole _selectedRole = UserRole.tenant;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final authNotifier = AuthScope.of(context);
    final success = await authNotifier.register(
      fullName: _fullNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      role: _selectedRole,
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

  @override
  Widget build(BuildContext context) {
    final authNotifier = AuthScope.of(context);
    final isLoading = authNotifier.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo tài khoản'),
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
                      'Đăng ký tài khoản mới',
                      style: AppTypography.heading2,
                    ),
                    const SizedBox(height: AppDimensions.spacingXs),
                    Text(
                      'Tham gia cộng đồng kết nối trọ sinh viên tiện lợi',
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: AppDimensions.spacingXl),

                    // Role selection
                    RoleSelector(
                      selectedRole: _selectedRole,
                      onRoleChanged: (role) {
                        setState(() {
                          _selectedRole = role;
                        });
                      },
                    ),
                    const SizedBox(height: AppDimensions.spacingLg),

                    // Full Name
                    AuthTextField(
                      controller: _fullNameController,
                      label: 'Họ và tên',
                      hintText: 'Nguyễn Văn A',
                      prefixIcon: Icons.badge_outlined,
                      validator: Validators.validateFullName,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppDimensions.spacingLg),

                    // Email
                    AuthTextField(
                      controller: _emailController,
                      label: 'Email',
                      hintText: 'email@sinhvien.edu.vn',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppDimensions.spacingLg),

                    // Password
                    AuthTextField(
                      controller: _passwordController,
                      label: 'Mật khẩu',
                      hintText: 'Tối thiểu 6 ký tự, gồm chữ và số',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      validator: Validators.validatePassword,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppDimensions.spacingLg),

                    // Confirm Password
                    AuthTextField(
                      controller: _confirmPasswordController,
                      label: 'Xác nhận mật khẩu',
                      hintText: 'Nhập lại mật khẩu',
                      prefixIcon: Icons.lock_reset_outlined,
                      isPassword: true,
                      validator: (val) => Validators.validateConfirmPassword(
                        val,
                        _passwordController.text,
                      ),
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppDimensions.spacing2Xl),

                    // Register Button
                    ElevatedButton(
                      onPressed: isLoading ? null : _handleRegister,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Đăng ký'),
                    ),
                    const SizedBox(height: AppDimensions.spacingLg),

                    // Already have account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Đã có tài khoản? ', style: AppTypography.bodySmall),
                        GestureDetector(
                          onTap: isLoading ? null : () => Navigator.pop(context),
                          child: Text(
                            'Đăng nhập',
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
