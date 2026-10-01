import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({
    super.key,
    this.onApply,
    this.onClear,
  });

  final VoidCallback? onApply;
  final VoidCallback? onClear;

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const FilterSheet(),
    );
  }

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  String? _selectedCity;
  String? _selectedState;
  String? _selectedGroup;
  final Set<String> _selectedCategories = {'Business'};

  static const _cities = ['Shiloh', 'San Francisco', 'New York', 'Austin'];
  static const _states = ['Hawaii', 'California', 'New York', 'Texas'];
  static const _groups = ['Business group', 'Community Pets', 'Tech Innovators'];

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  void _clear() {
    setState(() {
      _selectedCity = null;
      _selectedState = null;
      _selectedGroup = null;
      _selectedCategories.clear();
    });
    if (widget.onClear != null) widget.onClear!();
    Navigator.of(context).pop();
  }

  void _apply() {
    if (widget.onApply != null) widget.onApply!();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.surfaceDark : Colors.white;
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final borderColor = AppColors.borderOf(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Close and Title
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 22),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Filter Events',
                      style: AppTextStyles.title.copyWith(
                        fontSize: 20,
                        color: textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // City Dropdown
              Text(
                'City',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedCity,
                hint: Text(
                  'Select City',
                  style: AppTextStyles.body.copyWith(
                    color: textSecondary,
                    fontSize: 14,
                  ),
                ),
                icon: const Icon(Icons.keyboard_arrow_down, size: 22),
                items: _cities
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCity = val),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: borderColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // State Dropdown
              Text(
                'State',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedState,
                hint: Text(
                  'Select City',
                  style: AppTextStyles.body.copyWith(
                    color: textSecondary,
                    fontSize: 14,
                  ),
                ),
                icon: const Icon(Icons.keyboard_arrow_down, size: 22),
                items: _states
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedState = val),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: borderColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Groups Dropdown
              Text(
                'Groups',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedGroup,
                hint: Text(
                  'Group',
                  style: AppTextStyles.body.copyWith(
                    color: textSecondary,
                    fontSize: 14,
                  ),
                ),
                icon: const Icon(Icons.keyboard_arrow_down, size: 22),
                items: _groups
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedGroup = val),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: borderColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Category Chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildCategoryChip('Religious', Icons.nightlight_round),
                  _buildCategoryChip('Business', Icons.domain),
                  _buildCategoryChip('Religious', Icons.directions_run),
                  _buildCategoryChip('Education', Icons.school),
                  _buildCategoryChip('Community', Icons.groups),
                ],
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: _clear,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: textPrimary,
                          side: BorderSide(color: borderColor, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Clear Filter',
                          style: AppTextStyles.button.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _apply,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Apply Filter',
                          style: AppTextStyles.button.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon) {
    final isSelected = _selectedCategories.contains(label);
    return ChoiceChip(
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : AppColors.textPrimaryOf(context),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.textPrimaryOf(context),
            ),
          ),
        ],
      ),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: Colors.transparent,
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.borderOf(context),
      ),
      onSelected: (_) => _toggleCategory(label),
    );
  }
}
