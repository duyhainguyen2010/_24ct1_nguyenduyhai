import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:_24ct1_nguyenduyhai/core/routing/app_router.dart';
import 'package:_24ct1_nguyenduyhai/core/theme/app_theme.dart';
import 'package:_24ct1_nguyenduyhai/features/boarding_house/data/mock_boarding_house_repository.dart';
import 'package:_24ct1_nguyenduyhai/features/search/presentation/screens/search_screen.dart';
import 'package:_24ct1_nguyenduyhai/features/search/presentation/widgets/search_result_card.dart';

void main() {
  testWidgets('SearchScreen renders results, handles search query, and opens RoomDetail', (WidgetTester tester) async {
    final repository = MockBoardingHouseRepository();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        onGenerateRoute: AppRouter.onGenerateRoute,
        home: SearchScreen(repository: repository),
      ),
    );
    await tester.pumpAndSettle();

    // Verify search input is present
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Tìm theo tên trọ, đường, quận...'), findsOneWidget);

    // Verify initial results are displayed
    expect(find.byType(SearchResultCard), findsWidgets);
    expect(find.textContaining('kết quả'), findsOneWidget);

    // Enter search text "Bách Khoa"
    await tester.enterText(find.byType(TextField), 'Bách Khoa');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    // Verify filtered result contains "Bách Khoa"
    expect(find.text('Phòng trọ cao cấp gần ĐH Sư Phạm - ĐH Bách Khoa'), findsOneWidget);

    // Tap search result card to open RoomDetailScreen
    await tester.tap(find.byType(SearchResultCard).first);
    await tester.pumpAndSettle();

    // Verify RoomDetailScreen loaded
    expect(find.text('Gọi chủ trọ'), findsOneWidget);
    expect(find.text('Mô tả chi tiết'), findsOneWidget);

    // Pop back to SearchScreen
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    // Enter unmatched search text to verify Empty State
    await tester.enterText(find.byType(TextField), 'KhongTheTimThayTuKhoaNay999');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.text('Không tìm thấy phòng trọ'), findsOneWidget);
  });
}