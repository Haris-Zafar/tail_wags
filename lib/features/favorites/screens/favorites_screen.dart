import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_background.dart';
import '../../events/providers/events_provider.dart';
import '../../events/widgets/event_card.dart';
import '../../events/widgets/filter_sheet.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedEvents = ref.watch(likedEventsProvider);
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
                      'Favoruite',
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
                      tooltip: 'Filter Favorites',
                    ),
                  ],
                ),
              ),

              // Favorites List
              Expanded(
                child: likedEvents.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.favorite_border,
                              size: 64,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No Favorites Yet',
                              style: AppTextStyles.title.copyWith(color: textPrimary),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap the heart icon on any event card to save it here.',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textSecondaryOf(context),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: likedEvents.length,
                        itemBuilder: (context, index) {
                          return EventCard(event: likedEvents[index]);
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
