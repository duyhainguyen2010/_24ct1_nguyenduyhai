import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../boarding_house/domain/models/boarding_house_filter.dart';
import '../../../boarding_house/domain/models/room_amenity.dart';
import '../../../room_detail/presentation/widgets/amenity_helper.dart';

/// Modal bottom sheet allowing users to configure detailed search filters.
class SearchFilterSheet extends StatefulWidget {
  final BoardingHouseFilter initialFilter;
  final ValueChanged<BoardingHouseFilter> onApply;

  const SearchFilterSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required BoardingHouseFilter currentFilter,
    required ValueChanged<BoardingHouseFilter> onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SearchFilterSheet(
        initialFilter: currentFilter,
        onApply: onApply,
      ),
    );
  }

  @override
  State<SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends State<SearchFilterSheet> {
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;
  late final TextEditingController _minAreaController;
  late final TextEditingController _maxAreaController;

  late List<RoomAmenity> _selectedAmenities;
  late bool _onlyAvailable;

  String? _validationError;

  @override
  void initState() {
    super.initState();
    final f = widget.initialFilter;
    _minPriceController = TextEditingController(
      text: f.minPrice != null ? (f.minPrice! / 1000000).toStringAsFixed(1).replaceAll('.0', '') : '',
    );
    _maxPriceController = TextEditingController(
      text: f.maxPrice != null ? (f.maxPrice! / 1000000).toStringAsFixed(1).replaceAll('.0', '') : '',
    );
    _minAreaController = TextEditingController(
      text: f.minArea != null ? f.minArea!.toInt().toString() : '',
    );
    _maxAreaController = TextEditingController(
      text: f.maxArea != null ? f.maxArea!.toInt().toString() : '',
    );

    _selectedAmenities = List<RoomAmenity>.from(f.amenities);
    _onlyAvailable = f.onlyAvailable;
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _minAreaController.dispose();
    _maxAreaController.dispose();
    super.dispose();
  }

  void _handleReset() {
    setState(() {
      _minPriceController.clear();
      _maxPriceController.clear();
      _minAreaController.clear();
      _maxAreaController.clear();
      _selectedAmenities = [];
      _onlyAvailable = false;
      _validationError = null;
    });
  }

  void _handleApply() {
    setState(() {
      _validationError = null;
    });

    double? minPrice;
    double? maxPrice;
    if (_minPriceController.text.trim().isNotEmpty) {
      final val = double.tryParse(_minPriceController.text.trim().replaceAll(',', '.'));
      if (val != null && val > 0) minPrice = val * 1000000;
    }
    if (_maxPriceController.text.trim().isNotEmpty) {
      final val = double.tryParse(_maxPriceController.text.trim().replaceAll(',', '.'));
      if (val != null && val > 0) maxPrice = val * 1000000;
    }

    if (minPrice != null && maxPrice != null && minPrice > maxPrice) {
      setState(() {
        _validationError = 'Giá tối thiểu không được lớn hơn giá tối đa.';
      });
      return;
    }

    double? minArea;
    double? maxArea;
    if (_minAreaController.text.trim().isNotEmpty) {
      final val = double.tryParse(_minAreaController.text.trim().replaceAll(',', '.'));
      if (val != null && val > 0) minArea = val;
    }
    if (_maxAreaController.text.trim().isNotEmpty) {
      final val = double.tryParse(_maxAreaController.text.trim().replaceAll(',', '.'));
      if (val != null && val > 0) maxArea = val;
    }

    if (minArea != null && maxArea != null && minArea > maxArea) {
      setState(() {
        _validationError = 'Diện tích tối thiểu không được lớn hơn diện tích tối đa.';
      });
      return;
    }

    final updatedFilter = widget.initialFilter.copyWith(
      minPrice: minPrice,
      maxPrice: maxPrice,
      minArea: minArea,
      maxArea: maxArea,
      amenities: _selectedAmenities,
      onlyAvailable: _onlyAvailable,
    );

    widget.onApply(updatedFilter);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLg)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spacingLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Drag handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Bộ lọc tìm kiếm', style: AppTypography.heading2),
                  TextButton(
                    onPressed: _handleReset,
                    child: Text(
                      'Đặt lại',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingSm),

              if (_validationError != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spacingSm),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: AppDimensions.borderRadiusSm,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, size: 18, color: AppColors.error),
                      const SizedBox(width: AppDimensions.spacingSm),
                      Expanded(
                        child: Text(
                          _validationError!,
                          style: AppTypography.bodySmall.copyWith(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingMd),
              ],

              // 1. Monthly Price Range
              const Text('Khoảng giá (triệu VNĐ/tháng)', style: AppTypography.heading3),
              const SizedBox(height: AppDimensions.spacingSm),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _minPriceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        hintText: 'Từ (ví dụ: 1.5)',
                        prefixText: 'Từ ',
                        suffixText: 'tr',
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingSm),
                    child: Text('-', style: TextStyle(color: AppColors.textSecondary)),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _maxPriceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        hintText: 'Đến (ví dụ: 3)',
                        prefixText: 'Đến ',
                        suffixText: 'tr',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingLg),

              // 2. Area Range
              const Text('Diện tích phòng (m²)', style: AppTypography.heading3),
              const SizedBox(height: AppDimensions.spacingSm),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _minAreaController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        hintText: 'Từ (m²)',
                        prefixText: 'Từ ',
                        suffixText: 'm²',
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingSm),
                    child: Text('-', style: TextStyle(color: AppColors.textSecondary)),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _maxAreaController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        hintText: 'Đến (m²)',
                        prefixText: 'Đến ',
                        suffixText: 'm²',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingLg),

              // 3. Availability Switch
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: _onlyAvailable,
                activeThumbColor: AppColors.primary,
                title: const Text('Chỉ phòng còn trống', style: AppTypography.heading3),
                subtitle: const Text(
                  'Ẩn các phòng đã thông báo hết chỗ',
                  style: AppTypography.caption,
                ),
                onChanged: (val) {
                  setState(() {
                    _onlyAvailable = val;
                  });
                },
              ),
              const SizedBox(height: AppDimensions.spacingMd),

              // 4. Amenities Grid
              const Text('Tiện ích phòng', style: AppTypography.heading3),
              const SizedBox(height: AppDimensions.spacingSm),
              Wrap(
                spacing: AppDimensions.spacingSm,
                runSpacing: AppDimensions.spacingSm,
                children: RoomAmenity.values.map((amenity) {
                  final isSelected = _selectedAmenities.contains(amenity);
                  return FilterChip(
                    avatar: Icon(
                      AmenityHelper.getIcon(amenity),
                      size: AppDimensions.iconSm,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                    label: Text(AmenityHelper.getLabel(amenity)),
                    selected: isSelected,
                    showCheckmark: false,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                    labelStyle: AppTypography.caption.copyWith(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedAmenities.add(amenity);
                        } else {
                          _selectedAmenities.remove(amenity);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: AppDimensions.spacing2Xl),

              // 5. Apply Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleApply,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingMd),
                  ),
                  child: const Text('Áp dụng bộ lọc'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

