import 'package:flutter/material.dart';
import '../../../boarding_house/domain/models/room_amenity.dart';

/// Helper mapping RoomAmenity to Vietnamese label and appropriate icon.
class AmenityHelper {
  AmenityHelper._();

  static String getLabel(RoomAmenity amenity) {
    switch (amenity) {
      case RoomAmenity.wifi:
        return 'Wi-Fi tốc độ cao';
      case RoomAmenity.airConditioner:
        return 'Máy lạnh Inverter';
      case RoomAmenity.parking:
        return 'Nhà để xe';
      case RoomAmenity.washingMachine:
        return 'Máy giặt';
      case RoomAmenity.privateBathroom:
        return 'Vệ sinh khép kín';
      case RoomAmenity.kitchen:
        return 'Khu bếp riêng';
      case RoomAmenity.refrigerator:
        return 'Tủ lạnh';
      case RoomAmenity.securityCamera:
        return 'Camera an ninh 24/7';
    }
  }

  static IconData getIcon(RoomAmenity amenity) {
    switch (amenity) {
      case RoomAmenity.wifi:
        return Icons.wifi_rounded;
      case RoomAmenity.airConditioner:
        return Icons.ac_unit_rounded;
      case RoomAmenity.parking:
        return Icons.two_wheeler_rounded;
      case RoomAmenity.washingMachine:
        return Icons.local_laundry_service_rounded;
      case RoomAmenity.privateBathroom:
        return Icons.bathtub_outlined;
      case RoomAmenity.kitchen:
        return Icons.countertops_outlined;
      case RoomAmenity.refrigerator:
        return Icons.kitchen_rounded;
      case RoomAmenity.securityCamera:
        return Icons.videocam_outlined;
    }
  }
}
