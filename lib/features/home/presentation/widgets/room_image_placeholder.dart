import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Clean placeholder widget for boarding house cards.
/// Dynamically derives a soft, consistent pastel gradient based on the room's ID,
/// guaranteeing that the UI never breaks or flickers even without external images.
class RoomImagePlaceholder extends StatelessWidget {
  final String roomId;
  final double height;
  final double? width;
  final BorderRadius? borderRadius;
  final IconData icon;

  const RoomImagePlaceholder({
    super.key,
    required this.roomId,
    this.height = 140.0,
    this.width,
    this.borderRadius,
    this.icon = Icons.home_work_outlined,
  });

  @override
  Widget build(BuildContext context) {
    // Generate deterministic colors based on room id hash
    final hash = roomId.hashCode.abs();
    final List<Color> palette = [
      const Color(0xFFE0F2F1), // Teal 50
      const Color(0xFFE1F5FE), // Light Blue 50
      const Color(0xFFEDE7F6), // Deep Purple 50
      const Color(0xFFF3E5F5), // Purple 50
      const Color(0xFFFFF3E0), // Orange 50
      const Color(0xFFE8F5E9), // Green 50
    ];
    final color1 = palette[hash % palette.length];
    final color2 = palette[(hash + 2) % palette.length];

    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color1, color2],
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 40.0,
          color: AppColors.primary.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
