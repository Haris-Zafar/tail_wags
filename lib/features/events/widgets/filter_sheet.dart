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
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Close and Title
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Filter Events',
                      style: AppTextStyles.title.copyWith(
                        fontSize: 18,
                        color: textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24), // spacing balancing close button
              ],
            ),

            const SizedBox(height: 20),

            // City Dropdown
            Text('City', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: textPrimary)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedCity,
              hint: Text('Select City', style: AppTextStyles.body.copyWith(color: textSecondary)),
              items: _cities
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCity = val),
              decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
            ),

            const SizedBox(height: 16),

            // State Dropdown
            Text('State', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: textPrimary)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedState,
              hint: Text('Select State', style: AppTextStyles.body.copyWith(color: textSecondary)),
              items: _states
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedState = val),
              decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
            ),

            const SizedBox(height: 16),

            // Groups Dropdown
            Text('Groups', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: textPrimary)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedGroup,
              hint: Text('Group', style: AppTextStyles.body.copyWith(color: textSecondary)),
              items: _groups
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedGroup = val),
              decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
            ),

            const SizedBox(height: 20),

            // Category Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildCategoryChip('Religious', Icons.nightlight_round),
                _buildCategoryChip('Business', Icons.domain),
                _buildCategoryChip('Education', Icons.school),
                _buildCategoryChip('Community', Icons.groups),
              ],
            ),

            const SizedBox(height: 28),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clear,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textPrimary,
                      side: BorderSide(color: AppColors.borderOf(context)),
                    ),
                    child: const Text('Clear Filter'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _apply,
                    child: const Text('Apply Filter'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon) {
    final isSelected = _selectedCategories.contains(label);
    return ChoiceChip(
      showCheckmark: false,
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
