import 'dart:async';
import '../domain/models/boarding_house.dart';
import '../domain/models/room_amenity.dart';
import '../domain/repositories/boarding_house_repository.dart';

/// In-memory mock repository providing realistic university boarding house data.
class MockBoardingHouseRepository implements BoardingHouseRepository {
  static final List<BoardingHouse> _mockData = [
    BoardingHouse(
      id: 'bh-001',
      title: 'Phòng trọ cao cấp gần ĐH Sư Phạm - ĐH Bách Khoa',
      monthlyPrice: 2500000,
      address: '48 Cao Thắng, Q. Hải Châu, Đà Nẵng',
      area: 25.0,
      isFeatured: true,
      isAvailable: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      latitude: 16.0754,
      longitude: 108.2198,
      mockDistanceKm: 0.6,
      description:
          'Phòng trọ mới xây sạch đẹp, thoáng mát, ban công đón gió tự nhiên. Nằm trong khu vực an ninh yên tĩnh, gần chợ, siêu thị và các trường đại học lớn. Giờ giấc tự do, không chung chủ.',
      amenities: const [
        RoomAmenity.wifi,
        RoomAmenity.airConditioner,
        RoomAmenity.parking,
        RoomAmenity.privateBathroom,
        RoomAmenity.washingMachine,
        RoomAmenity.securityCamera,
      ],
      ownerName: 'Cô Nguyễn Thị Mai',
      ownerPhone: '0905 888 999',
    ),
    BoardingHouse(
      id: 'bh-002',
      title: 'Phòng khép kín full nội thất, máy lạnh, ban công thoáng mát',
      monthlyPrice: 3200000,
      address: '120 Nguyễn Lương Bằng, Q. Liên Chiểu, Đà Nẵng',
      area: 30.0,
      isFeatured: true,
      isAvailable: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      latitude: 16.0682,
      longitude: 108.1567,
      mockDistanceKm: 1.2,
      description:
          'Căn hộ mini đầy đủ tiện nghi: giường nệm cao cấp, tủ quần áo, bàn học, máy lạnh Inverter tiết kiệm điện. Khóa cổng vân tay hiện đại, đảm bảo an toàn tuyệt đối.',
      amenities: const [
        RoomAmenity.wifi,
        RoomAmenity.airConditioner,
        RoomAmenity.parking,
        RoomAmenity.privateBathroom,
        RoomAmenity.kitchen,
        RoomAmenity.refrigerator,
        RoomAmenity.securityCamera,
      ],
      ownerName: 'Chú Trần Văn Đức',
      ownerPhone: '0935 112 233',
    ),
    BoardingHouse(
      id: 'bh-003',
      title: 'Studio mini sinh viên có gác lửng, giờ giấc tự do',
      monthlyPrice: 1900000,
      address: '15 Ngô Sĩ Liên, Q. Liên Chiểu, Đà Nẵng',
      area: 20.0,
      isFeatured: true,
      isAvailable: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      latitude: 16.0712,
      longitude: 108.1534,
      mockDistanceKm: 0.9,
      description:
          'Phòng có gác lửng đúc kiên cố, ốp gạch men sạch sẽ từ sàn tới trần. Phù hợp cho 1-2 bạn sinh viên ở ghép tiết kiệm chi phí. Điện nước tính theo công tơ riêng giá nhà nước.',
      amenities: const [
        RoomAmenity.wifi,
        RoomAmenity.parking,
        RoomAmenity.privateBathroom,
        RoomAmenity.securityCamera,
      ],
      ownerName: 'Anh Lê Hoàng Quân',
      ownerPhone: '0914 445 566',
    ),
    BoardingHouse(
      id: 'bh-004',
      title: 'Phòng trọ mới xây, có camera an ninh, nhà để xe rộng rãi',
      monthlyPrice: 1800000,
      address: '88 Tôn Đức Thắng, Q. Cẩm Lệ, Đà Nẵng',
      area: 18.0,
      isFeatured: false,
      isAvailable: false, // Demo unavailable room (Hết phòng)
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      latitude: 16.0421,
      longitude: 108.1812,
      mockDistanceKm: 1.5,
      description:
          'Phòng trọ khu vực trung tâm Cẩm Lệ, giao thông thuận tiện. Nhà trọ vừa hết phòng trong tháng này, quý khách vui lòng liên hệ trước để đặt chỗ cho tháng sau.',
      amenities: const [
        RoomAmenity.wifi,
        RoomAmenity.parking,
        RoomAmenity.privateBathroom,
        RoomAmenity.securityCamera,
      ],
      ownerName: 'Bác Phạm Văn Hùng',
      ownerPhone: '0903 777 888',
    ),
    BoardingHouse(
      id: 'bh-005',
      title: 'Chung cư mini 1 phòng ngủ, bếp riêng, máy giặt chung',
      monthlyPrice: 3500000,
      address: '24 Núi Thành, Q. Hải Châu, Đà Nẵng',
      area: 35.0,
      isFeatured: true,
      isAvailable: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
      latitude: 16.0598,
      longitude: 108.2215,
      mockDistanceKm: 2.1,
      description:
          'Chung cư mini cao cấp có thang máy, khu giặt phơi trên sân thượng có mái che. Phòng ngủ tách biệt với phòng khách và bếp, view nhìn thẳng ra đường lớn.',
      amenities: const [
        RoomAmenity.wifi,
        RoomAmenity.airConditioner,
        RoomAmenity.parking,
        RoomAmenity.washingMachine,
        RoomAmenity.privateBathroom,
        RoomAmenity.kitchen,
        RoomAmenity.refrigerator,
        RoomAmenity.securityCamera,
      ],
      ownerName: 'Chị Đặng Thu Hà',
      ownerPhone: '0978 223 344',
    ),
    BoardingHouse(
      id: 'bh-006',
      title: 'Phòng trọ giá rẻ cho sinh viên năm nhất, gần bến xe',
      monthlyPrice: 1500000,
      address: '52 Nam Trân, Q. Liên Chiểu, Đà Nẵng',
      area: 16.0,
      isFeatured: false,
      isAvailable: true,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      latitude: 16.0645,
      longitude: 108.1712,
      mockDistanceKm: 0.8,
      description:
          'Phòng trọ bình dân thoáng mát, chủ nhà thân thiện tốt bụng thường xuyên hỗ trợ các bạn tân sinh viên. Nước sinh hoạt máy lạnh và giếng khoan dự phòng.',
      amenities: const [
        RoomAmenity.wifi,
        RoomAmenity.parking,
        RoomAmenity.privateBathroom,
      ],
      ownerName: 'Cô Bùi Thị Lan',
      ownerPhone: '0989 334 455',
    ),
    BoardingHouse(
      id: 'bh-007',
      title: 'Phòng trọ an ninh, sạch sẽ, có sân phơi chung tầng thượng',
      monthlyPrice: 2200000,
      address: '33 Dũng Sĩ Thanh Khê, Q. Thanh Khê, Đà Nẵng',
      area: 22.0,
      isFeatured: false,
      isAvailable: true,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      latitude: 16.0699,
      longitude: 108.1856,
      mockDistanceKm: 1.8,
      description:
          'Nhà trọ 3 tầng xây mới, hành lang rộng rãi, ban công view biển Thanh Khê mát rượi. Đầy đủ tiện ích cơ bản cho sinh viên và người đi làm.',
      amenities: const [
        RoomAmenity.wifi,
        RoomAmenity.airConditioner,
        RoomAmenity.parking,
        RoomAmenity.privateBathroom,
        RoomAmenity.securityCamera,
      ],
      ownerName: 'Chú Hoàng Văn Nam',
      ownerPhone: '0905 667 788',
    ),
  ];

  @override
  Future<List<BoardingHouse>> getFeaturedBoardingHouses() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _mockData.where((b) => b.isFeatured).toList();
  }

  @override
  Future<List<BoardingHouse>> getNearbyBoardingHouses() async {
    await Future.delayed(const Duration(milliseconds: 150));
    final list = List<BoardingHouse>.from(_mockData);
    list.sort((a, b) => a.mockDistanceKm.compareTo(b.mockDistanceKm));
    return list.take(5).toList();
  }

  @override
  Future<List<BoardingHouse>> getRecentBoardingHouses() async {
    await Future.delayed(const Duration(milliseconds: 150));
    final list = List<BoardingHouse>.from(_mockData);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<BoardingHouse?> getBoardingHouseById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _mockData.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }
}
