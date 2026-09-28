import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_background.dart';
import '../models/event_model.dart';
import '../providers/events_provider.dart';

class EventDetailScreen extends ConsumerWidget {
  const EventDetailScreen({
    super.key,
    required this.eventId,
  });

  final String eventId;

  void _addToCalendar(BuildContext context, EventModel event) {
    final calendarEvent = Event(
      title: event.title,
      description: event.detail,
      location: event.location,
      startDate: event.date,
      endDate: event.date.add(const Duration(hours: 2)),
    );

    Add2Calendar.addEvent2Cal(calendarEvent);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening calendar...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _toggleLike(
    BuildContext context,
    WidgetRef ref,
    EventModel event,
    bool isLiked,
  ) async {
    final currentUser = ref.read(currentUserDocProvider).value;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to save favorites.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final eventService = ref.read(eventServiceProvider);
    await eventService.toggleLikeEvent(
      uid: currentUser.uid,
      eventId: event.id,
      isLiked: isLiked,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(singleEventProvider(eventId));
    final currentUser = ref.watch(currentUserDocProvider).value;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);

    final event = eventAsync.value ??
        sampleEvents.firstWhere((e) => e.id == eventId, orElse: () => sampleEvents.first);

    final isLiked = currentUser?.likedEventIds.contains(event.id) ?? false;

    return Scaffold(
      body: AppBackground(
        usePattern: false,
        child: Column(
          children: [
            // Top Image Header with Back and Heart overlay
            Stack(
              children: [
                Image.asset(
                  event.imageAsset,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 300,
                    color: AppColors.primaryLight,
                    child: const Icon(Icons.event, size: 64, color: AppColors.primary),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),

                        // Heart Button
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? AppColors.liked : Colors.white,
                            ),
                            onPressed: () => _toggleLike(context, ref, event, isLiked),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Content Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      event.title,
                      style: AppTextStyles.headline.copyWith(
                        color: textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Date & Time Row
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                          color: textPrimary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            event.time,
                            style: AppTextStyles.body.copyWith(
                              color: textPrimary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Location Row
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 20,
                          color: textPrimary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            event.location,
                            style: AppTextStyles.body.copyWith(
                              color: textPrimary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Event Detail Section
                    Text(
                      'Event Detail',
                      style: AppTextStyles.title.copyWith(
                        color: textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.borderOf(context),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        event.detail,
                        style: AppTextStyles.body.copyWith(
                          color: textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Add to Calendar Button
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _addToCalendar(context, event),
                    child: const Text('Add to my calendar'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
