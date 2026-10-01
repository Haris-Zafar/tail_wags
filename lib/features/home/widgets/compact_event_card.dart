import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


import '../../../core/providers/auth_provider.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../events/models/event_model.dart';
import '../../events/providers/events_provider.dart';

class CompactEventCard extends ConsumerWidget {
  const CompactEventCard({
    super.key,
    required this.event,
  });

  final EventModel event;

  void _addToCalendar(BuildContext context) {
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

  Future<void> _toggleLike(BuildContext context, WidgetRef ref) async {
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

    final isLiked = currentUser.likedEventIds.contains(event.id);
    final eventService = ref.read(eventServiceProvider);
    await eventService.toggleLikeEvent(
      uid: currentUser.uid,
      eventId: event.id,
      isLiked: isLiked,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDocProvider).value;
    final isLiked = currentUser?.likedEventIds.contains(event.id) ?? false;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark ? AppColors.surfaceDark : AppColors.surface;
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final borderColor = AppColors.borderOf(context);



    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.pushNamed(
              RoutePaths.eventDetail,
              pathParameters: {'eventId': event.id},
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Avatar Image, Title & Date/Time, Heart Icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Small Avatar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: event.imageAsset.startsWith('http')
                          ? Image.network(
                              event.imageAsset,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 48,
                                height: 48,
                                color: AppColors.primaryLight,
                                child: const Icon(
                                  Icons.event,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                            )
                          : Image.asset(
                              event.imageAsset,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 48,
                                height: 48,
                                color: AppColors.primaryLight,
                                child: const Icon(
                                  Icons.event,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(width: 12),

                    // Title + Date & Time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: AppTextStyles.title.copyWith(
                              color: textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            event.time,
                            style: AppTextStyles.body.copyWith(
                              color: textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Heart Icon
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? AppColors.liked : textSecondary,
                        size: 22,
                      ),
                      onPressed: () => _toggleLike(context, ref),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Location Row
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        event.location,
                        style: AppTextStyles.body.copyWith(
                          color: textSecondary,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Add to my calendar Button
                SizedBox(
                  height: 38,
                  child: ElevatedButton(
                    onPressed: () => _addToCalendar(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Add to my calendar',
                      style: AppTextStyles.button.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
