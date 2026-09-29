import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_background.dart';
import '../../events/providers/events_provider.dart';
import '../../events/widgets/event_card.dart';
import '../../polls/providers/polls_provider.dart';
import '../../polls/widgets/poll_card.dart';

class GroupProfileScreen extends ConsumerWidget {
  const GroupProfileScreen({
    super.key,
    required this.groupId,
  });

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pollsAsync = ref.watch(allPollsProvider);
    final eventsAsync = ref.watch(allEventsProvider);

    final polls = pollsAsync.value ?? [];
    final events = eventsAsync.value ?? [];

    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);

    return Scaffold(
      body: AppBackground(
        child: Column(
          children: [
            // Header
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Red background header
                Container(
                  height: 160,
                  width: double.infinity,
                  color: AppColors.primary,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              Text(
                                'Group Profile',
                                style: AppTextStyles.title.copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Centered Group Avatar Overlay
                Positioned(
                  bottom: -40,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/person.png'),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 48),

            // Group Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'Business group',
                    style: AppTextStyles.headline.copyWith(
                      color: textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Lorem ipsum dolor sit amet consectetur. Cras elit volutpat morbi mauris tincidunt lacus.',
                    style: AppTextStyles.body.copyWith(
                      color: textSecondary,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  // Member count pill badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '14K Members',
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Scrollable Content Body (Polls first, then Events)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  // 1. Group Polls Heading
                  Text(
                    'Group Polls',
                    style: AppTextStyles.title.copyWith(
                      color: textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (polls.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        'No polls in this group yet.',
                        style: AppTextStyles.body.copyWith(color: textSecondary),
                      ),
                    )
                  else
                    ...polls.map((poll) => PollCard(poll: poll)),

                  const SizedBox(height: 16),

                  // 2. Group Events Heading
                  Text(
                    'Group Events',
                    style: AppTextStyles.title.copyWith(
                      color: textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (events.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        'No events in this group yet.',
                        style: AppTextStyles.body.copyWith(color: textSecondary),
                      ),
                    )
                  else
                    ...events.map((event) => EventCard(event: event)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
