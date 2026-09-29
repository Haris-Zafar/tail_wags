import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_background.dart';
import '../providers/events_provider.dart';
import '../widgets/event_card.dart';
import '../widgets/filter_sheet.dart';

class FeaturesScreen extends ConsumerWidget {
  const FeaturesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(allEventsProvider);
    final events = eventsAsync.value ?? [];

    final textPrimary = AppColors.textPrimaryOf(context);

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Features',
                      style: AppTextStyles.headline.copyWith(
                        color: textPrimary,
                        fontSize: 24,
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceMuted,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.tune, size: 20),
                      ),
                      onPressed: () => FilterSheet.show(context),
                      tooltip: 'Filter Events',
                    ),
                  ],
                ),
              ),

              // Events List
              Expanded(
                child: events.isEmpty
                    ? Center(
                        child: Text(
                          'No events found',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textSecondaryOf(context),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          return EventCard(event: events[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
