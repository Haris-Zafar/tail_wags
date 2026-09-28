import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/loading_button.dart';
import '../models/event_model.dart';
import '../providers/events_provider.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key});

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dateController = TextEditingController(text: '24/2/2024');
  final _timeController = TextEditingController(text: '12:00 PM');
  final _locationController = TextEditingController();
  final _detailController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final String _selectedImageAsset = 'assets/images/event.png';
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  Future<void> _handleCreateEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = ref.read(currentUserDocProvider).value;
      final eventService = ref.read(eventServiceProvider);

      final combinedDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final newEvent = EventModel(
        id: '',
        title: _titleController.text.trim(),
        date: combinedDateTime,
        time: '${_dateController.text} ${_timeController.text}',
        location: _locationController.text.trim(),
        detail: _detailController.text.trim(),
        imageAsset: _selectedImageAsset,
        createdBy: user?.uid ?? '',
      );

      await eventService.createEvent(newEvent);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event created successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create event. Please try again.'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final borderColor = AppColors.borderOf(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
      ),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Field
                  AppTextField(
                    label: 'Title',
                    controller: _titleController,
                    hint: 'Made in Melanin! Black History Month Social',
                    validator: (v) => v == null || v.trim().isEmpty ? 'Title is required' : null,
                  ),

                  const SizedBox(height: 16),

                  // Date and Time Row
                  Row(
                    children: [
                      // Date Field
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: textPrimary)),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _dateController,
                              readOnly: true,
                              onTap: _pickDate,
                              style: AppTextStyles.body.copyWith(color: textPrimary),
                              decoration: InputDecoration(
                                suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Time Field
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Time', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: textPrimary)),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _timeController,
                              readOnly: true,
                              onTap: _pickTime,
                              style: AppTextStyles.body.copyWith(color: textPrimary),
                              decoration: InputDecoration(
                                suffixIcon: const Icon(Icons.access_time_outlined, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Location Field
                  AppTextField(
                    label: 'Location',
                    controller: _locationController,
                    hint: '1901 Thornridge Cir. Shiloh, Hawaii 81063',
                    validator: (v) => v == null || v.trim().isEmpty ? 'Location is required' : null,
                  ),

                  const SizedBox(height: 16),

                  // Event Detail Field
                  Text('Event Detail', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: textPrimary)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _detailController,
                    maxLines: 4,
                    style: AppTextStyles.body.copyWith(color: textPrimary),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Detail is required' : null,
                    decoration: InputDecoration(
                      hintText: 'Lorem ipsum dolor sit amet consectetur...',
                      hintStyle: AppTextStyles.body.copyWith(color: textSecondary),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Upload Image section
                  Text('Upload Image', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: textPrimary)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Selected bundled asset image (assets/images/event.png)')),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor, width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.upload_outlined, size: 32, color: AppColors.textSecondary),
                          const SizedBox(height: 8),
                          Text('Upload', style: AppTextStyles.body.copyWith(color: textSecondary)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Create Event Button
                  LoadingButton(
                    label: 'Create Event',
                    isLoading: _isLoading,
                    onPressed: _handleCreateEvent,
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
