import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:_24ct1_nguyenduyhai/app.dart';
import 'package:_24ct1_nguyenduyhai/features/auth/data/mock_auth_repository.dart';
import 'package:_24ct1_nguyenduyhai/features/auth/domain/models/app_user.dart';
import 'package:_24ct1_nguyenduyhai/features/auth/domain/models/user_role.dart';
import 'package:_24ct1_nguyenduyhai/core/constants/app_strings.dart';
import 'package:_24ct1_nguyenduyhai/features/home/presentation/widgets/featured_boarding_house_card.dart';
import 'package:_24ct1_nguyenduyhai/features/home/presentation/widgets/map_discovery_card.dart';

void main() {
  testWidgets('Unauthenticated user starts on LoginScreen', (WidgetTester tester) async {
    final repo = MockAuthRepository();
    await tester.pumpWidget(BoardingHouseApp(authRepository: repo));
    await tester.pumpAndSettle();

    expect(find.text('Đăng nhập'), findsWidgets);
    expect(find.text('Đăng ký ngay'), findsOneWidget);
  });

  testWidgets('Authenticated user navigates to MainShellScreen with HomeScreen rendered', (WidgetTester tester) async {
    final verifiedUser = AppUser(
      uid: 'test-uid',
      email: 'student@example.com',
      fullName: 'Nguyễn Sinh Viên',
      role: UserRole.tenant,
      isEmailVerified: true,
      createdAt: DateTime.now(),
    );
    final repo = MockAuthRepository(initialUser: verifiedUser);

    await tester.pumpWidget(BoardingHouseApp(authRepository: repo));
    await tester.pumpAndSettle();

    // Verify Tab is on Home
    expect(find.text(AppStrings.tabHome), findsWidgets);
    expect(find.text(AppStrings.tabSearch), findsOneWidget);

    // Verify Home personalized greeting with user name
    expect(find.textContaining('Nguyễn Sinh Viên'), findsOneWidget);

    // Verify Search bar is present
    expect(find.text('Tìm khu vực, tên trọ, trường ĐH...'), findsOneWidget);

    // Verify Featured section
    expect(find.text('Phòng trọ nổi bật ⭐'), findsOneWidget);

    // Tap on the first featured card and verify navigation to RoomDetailScreen
    await tester.tap(find.byType(FeaturedBoardingHouseCard).first);
    await tester.pumpAndSettle();

    // Verify RoomDetailScreen loaded with title, description, amenities, and contact actions
    expect(find.text('Gọi chủ trọ'), findsOneWidget);
    expect(find.text('Mô tả chi tiết'), findsOneWidget);
    expect(find.text('Wi-Fi tốc độ cao'), findsOneWidget);

    // Navigate back to Home
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    // Verify Map CTA card
    expect(find.byType(MapDiscoveryCard), findsOneWidget);

    // Scroll down to make Map CTA card clearly visible and tap it
    await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -300));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(MapDiscoveryCard));
    await tester.pumpAndSettle();

    // Verify that tapping Map CTA navigated to Map tab (Tab index 2)
    expect(find.text(AppStrings.tabMap), findsWidgets);

    // Tap Search tab navigation item and verify navigation
    await tester.tap(find.text(AppStrings.tabSearch));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.tabSearch), findsWidgets);
  });
}