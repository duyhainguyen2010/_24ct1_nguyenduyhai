import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:_24ct1_nguyenduyhai/core/theme/app_theme.dart';
import 'package:_24ct1_nguyenduyhai/features/boarding_house/domain/models/boarding_house.dart';
import 'package:_24ct1_nguyenduyhai/features/boarding_house/domain/models/room_amenity.dart';
import 'package:_24ct1_nguyenduyhai/features/room_detail/presentation/screens/room_detail_screen.dart';

void main() {
  final sampleAvailableRoom = BoardingHouse(
    id: 'test-room-1',
    title: 'Phòng trọ sinh viên tiện nghi',
    monthlyPrice: 2500000,
    address: '123 Đường Hải Phòng, Hải Châu, Đà Nẵng',
    area: 25.0,
    isFeatured: true,
    isAvailable: true,
    createdAt: DateTime.now(),
    latitude: 16.07,
    longitude: 108.21,
    mockDistanceKm: 0.8,
    description: 'Phòng đầy đủ tiện nghi, an ninh tốt, gần trường đại học.',
    amenities: const [
      RoomAmenity.wifi,
      RoomAmenity.airConditioner,
      RoomAmenity.parking,
      RoomAmenity.washingMachine,
    ],
    ownerName: 'Bác Nam',
    ownerPhone: '0905 111 222',
  );

  final sampleUnavailableRoom = sampleAvailableRoom.copyWith(
    id: 'test-room-2',
    isAvailable: false,
    title: 'Phòng đã cho thuê hết',
  );

  testWidgets('RoomDetailScreen renders available room details properly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: RoomDetailScreen(boardingHouse: sampleAvailableRoom),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title and Price
    expect(find.text('Phòng trọ sinh viên tiện nghi'), findsOneWidget);
    expect(find.text('2.5 triệu/tháng'), findsOneWidget);

    // Verify "Còn phòng" status badge
    expect(find.text('Còn phòng'), findsOneWidget);

    // Verify Address & stats
    expect(find.text('123 Đường Hải Phòng, Hải Châu, Đà Nẵng'), findsOneWidget);
    expect(find.text('Diện tích: 25 m²'), findsOneWidget);
    expect(find.text('Cách đây: 0.8 km'), findsOneWidget);

    // Verify Description
    expect(find.text('Mô tả chi tiết'), findsOneWidget);
    expect(find.text('Phòng đầy đủ tiện nghi, an ninh tốt, gần trường đại học.'), findsOneWidget);

    // Verify Amenities
    expect(find.text('Wi-Fi tốc độ cao'), findsOneWidget);
    expect(find.text('Máy lạnh Inverter'), findsOneWidget);
    expect(find.text('Nhà để xe'), findsOneWidget);
    expect(find.text('Máy giặt'), findsOneWidget);

    // Verify Owner info
    expect(find.text('Bác Nam'), findsOneWidget);
    expect(find.text('0905 111 222'), findsOneWidget);

    // Verify Action buttons
    expect(find.text('Gọi chủ trọ'), findsOneWidget);
    expect(find.text('Nhắn tin'), findsOneWidget);

    // Test Contact actions tap
    await tester.tap(find.text('Gọi chủ trọ'));
    await tester.pump();
    expect(find.textContaining('Tính năng gọi điện'), findsOneWidget);

    // Test Favorite local toggle
    await tester.tap(find.byIcon(Icons.favorite_border_rounded));
    await tester.pump();
    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
  });

  testWidgets('RoomDetailScreen displays "Hết phòng" badge for unavailable room', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: RoomDetailScreen(boardingHouse: sampleUnavailableRoom),
      ),
    );
    await tester.pumpAndSettle();

    // Verify "Hết phòng" status badge
    expect(find.text('Hết phòng'), findsOneWidget);
    expect(find.text('Phòng đã cho thuê hết'), findsOneWidget);
  });
}
