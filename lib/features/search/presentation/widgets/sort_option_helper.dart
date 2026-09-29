import 'package:flutter/material.dart';
import '../../../boarding_house/domain/models/room_sort_option.dart';

/// Presentation helper mapping RoomSortOption to Vietnamese labels and icons.
class SortOptionHelper {
  SortOptionHelper._();

  static String getLabel(RoomSortOption option) {
    switch (option) {
      case RoomSortOption.newest:
        return 'Mới nhất';
      case RoomSortOption.priceLowToHigh:
        return 'Giá tăng dần';
      case RoomSortOption.priceHighToLow:
        return 'Giá giảm dần';
      case RoomSortOption.nearest:
        return 'Gần nhất';
    }
  }

  static IconData getIcon(RoomSortOption option) {
    switch (option) {
      case RoomSortOption.newest:
        return Icons.schedule_rounded;
      case RoomSortOption.priceLowToHigh:
        return Icons.arrow_upward_rounded;
      case RoomSortOption.priceHighToLow:
        return Icons.arrow_downward_rounded;
      case RoomSortOption.nearest:
        return Icons.near_me_rounded;
    }
  }
}
