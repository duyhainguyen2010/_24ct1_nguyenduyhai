import '../../../search/presentation/screens/search_screen.dart';
import '../../../home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../auth/presentation/notifiers/auth_scope.dart';
import '../widgets/shell_tab_placeholder.dart';

/// Navigation shell managing top-level tabs via IndexedStack and NavigationBar.
class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  static const List<String> _titles = [
    AppStrings.tabHome,
    AppStrings.tabSearch,
    AppStrings.tabMap,
    AppStrings.tabFavorites,
    AppStrings.tabProfile,
  ];

  void _onDestinationSelected(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  Widget _buildProfileTab(BuildContext context) {
    final authNotifier = AuthScope.of(context);
    final user = authNotifier.user;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing2Xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppDimensions.maxContentWidth),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingLg),
              Text(
                user?.fullName ?? 'Người dùng',
                style: AppTypography.heading2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingXs),
              Text(
                user?.email ?? '',
                style: AppTypography.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingMd,
                  vertical: AppDimensions.spacingXs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: AppDimensions.borderRadiusSm,
                ),
                child: Text(
                  'Vai trò: ${user?.role.label ?? "Chưa xác định"}',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacing2Xl),

              // Action buttons for Auth module testing
              ListTile(
                leading: const Icon(Icons.lock_outline, color: AppColors.primary),
                title: const Text('Đổi mật khẩu', style: AppTypography.bodyMedium),
                trailing: const Icon(Icons.chevron_right, size: AppDimensions.iconSm),
                shape: RoundedRectangleBorder(
                  borderRadius: AppDimensions.borderRadiusSm,
                  side: const BorderSide(color: AppColors.border),
                ),
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.changePassword);
                },
              ),
              const SizedBox(height: AppDimensions.spacingMd),

              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: Text(
                  'Đăng xuất',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: AppDimensions.borderRadiusSm,
                  side: const BorderSide(color: AppColors.border),
                ),
                onTap: () async {
                  await authNotifier.logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomeScreen(
        onNavigateToTab: _onDestinationSelected,
      ),
      const SearchScreen(),
      const ShellTabPlaceholder(
        title: AppStrings.tabMap,
        icon: Icons.map_rounded,
      ),
      const ShellTabPlaceholder(
        title: AppStrings.tabFavorites,
        icon: Icons.favorite_rounded,
      ),
      _buildProfileTab(context),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: tabs,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: AppStrings.tabHome,
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search_rounded),
            label: AppStrings.tabSearch,
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map_rounded),
            label: AppStrings.tabMap,
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: AppStrings.tabFavorites,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: AppStrings.tabProfile,
          ),
        ],
      ),
    );
  }
}


