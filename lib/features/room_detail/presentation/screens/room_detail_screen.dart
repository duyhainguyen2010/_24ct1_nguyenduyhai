import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../boarding_house/domain/models/boarding_house.dart';
import '../widgets/amenities_section.dart';
import '../widgets/owner_info_card.dart';
import '../widgets/room_contact_actions.dart';
import '../widgets/room_description_section.dart';
import '../widgets/room_detail_image_carousel.dart';
import '../widgets/room_info_section.dart';
import '../widgets/room_location_preview.dart';

/// Complete Room Detail screen presenting comprehensive boarding house information.
class RoomDetailScreen extends StatefulWidget {
  final BoardingHouse boardingHouse;

  const RoomDetailScreen({
    super.key,
    required this.boardingHouse,
  });

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  // Local favorite state for UI demonstration (non-persistent)
  bool _isFavorite = false;

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite
              ? 'Đã thêm "${widget.boardingHouse.title}" vào danh sách yêu thích (Demo tạm thời).'
              : 'Đã bỏ lưu phòng trọ.',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handleMapTap() {
    Navigator.pop(context); // Return to shell
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Đang xem vị trí phòng trọ (${widget.boardingHouse.latitude}, ${widget.boardingHouse.longitude}) trên bản đồ.',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final room = widget.boardingHouse;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Large Top Image Carousel
            RoomDetailImageCarousel(
              boardingHouse: room,
              isFavorite: _isFavorite,
              onFavoriteToggle: _toggleFavorite,
            ),

            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Pricing, Status, Title, Address & Key stats
                  RoomInfoSection(boardingHouse: room),
                  const SizedBox(height: AppDimensions.spacingXl),
                  const Divider(),
                  const SizedBox(height: AppDimensions.spacingLg),

                  // 3. Description
                  RoomDescriptionSection(description: room.description),
                  const SizedBox(height: AppDimensions.spacingXl),
                  const Divider(),
                  const SizedBox(height: AppDimensions.spacingLg),

                  // 4. Amenities Grid
                  AmenitiesSection(amenities: room.amenities),
                  const SizedBox(height: AppDimensions.spacingXl),
                  const Divider(),
                  const SizedBox(height: AppDimensions.spacingLg),

                  // 5. Owner Information Card
                  OwnerInfoCard(
                    ownerName: room.ownerName,
                    ownerPhone: room.ownerPhone,
                  ),
                  const SizedBox(height: AppDimensions.spacingXl),
                  const Divider(),
                  const SizedBox(height: AppDimensions.spacingLg),

                  // 6. Map & Location Preview
                  RoomLocationPreview(
                    boardingHouse: room,
                    onMapTap: _handleMapTap,
                  ),
                  const SizedBox(height: AppDimensions.spacing3Xl),
                ],
              ),
            ),
          ],
        ),
      ),
      // 7. Sticky Bottom Contact Actions
      bottomNavigationBar: RoomContactActions(boardingHouse: room),
    );
  }
}
