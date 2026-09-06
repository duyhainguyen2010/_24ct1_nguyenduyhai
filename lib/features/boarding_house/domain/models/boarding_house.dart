import 'room_amenity.dart';

/// Core business entity representing a boarding house / rental room.
/// Shared across Home, Room Detail, Search, Map, Favorites, and Management modules.
class BoardingHouse {
  final String id;
  final String title;
  final double monthlyPrice;
  final String address;
  final double area; // in m²
  final String? imageUrl;
  final bool isFeatured;
  final bool isAvailable;
  final DateTime createdAt;
  final double latitude;
  final double longitude;
  final double mockDistanceKm;

  // Enriched detail fields
  final String description;
  final List<RoomAmenity> amenities;
  final String ownerName;
  final String ownerPhone;

  const BoardingHouse({
    required this.id,
    required this.title,
    required this.monthlyPrice,
    required this.address,
    required this.area,
    this.imageUrl,
    this.isFeatured = false,
    this.isAvailable = true,
    required this.createdAt,
    required this.latitude,
    required this.longitude,
    this.mockDistanceKm = 1.0,
    this.description = '',
    this.amenities = const [],
    this.ownerName = 'Chủ nhà trọ',
    this.ownerPhone = '0905 123 456',
  });

  /// Human-readable monthly price in Vietnamese Dong.
  /// Formats e.g. 2500000 -> "2.5 triệu/tháng", 1800000 -> "1.8 triệu/tháng"
  String get formattedPrice {
    if (monthlyPrice >= 1000000) {
      final millions = monthlyPrice / 1000000;
      final text = millions == millions.roundToDouble()
          ? millions.toInt().toString()
          : millions.toStringAsFixed(1);
      return '$text triệu/tháng';
    } else {
      return '${monthlyPrice.toInt()} đ/tháng';
    }
  }

  /// Formatted area string (e.g. "25 m²")
  String get formattedArea {
    return '${area == area.roundToDouble() ? area.toInt() : area.toStringAsFixed(1)} m²';
  }

  /// Formatted mock distance (e.g. "0.8 km")
  String get formattedDistance {
    return '${mockDistanceKm.toStringAsFixed(1)} km';
  }

  BoardingHouse copyWith({
    String? id,
    String? title,
    double? monthlyPrice,
    String? address,
    double? area,
    String? imageUrl,
    bool? isFeatured,
    bool? isAvailable,
    DateTime? createdAt,
    double? latitude,
    double? longitude,
    double? mockDistanceKm,
    String? description,
    List<RoomAmenity>? amenities,
    String? ownerName,
    String? ownerPhone,
  }) {
    return BoardingHouse(
      id: id ?? this.id,
      title: title ?? this.title,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      address: address ?? this.address,
      area: area ?? this.area,
      imageUrl: imageUrl ?? this.imageUrl,
      isFeatured: isFeatured ?? this.isFeatured,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      mockDistanceKm: mockDistanceKm ?? this.mockDistanceKm,
      description: description ?? this.description,
      amenities: amenities ?? this.amenities,
      ownerName: ownerName ?? this.ownerName,
      ownerPhone: ownerPhone ?? this.ownerPhone,
    );
  }
}
