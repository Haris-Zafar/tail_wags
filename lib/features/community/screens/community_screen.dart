import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_background.dart';
import '../../events/providers/events_provider.dart';
import '../../events/widgets/event_card.dart';
import '../../polls/models/poll_model.dart';
import '../../polls/widgets/poll_card.dart';

final samplePolls = [
  PollModel(
    id: 'sample-poll-1',
    question: 'Made in Melanin! Black History Month Social',
    optionA: 'Made in Melanin! Black History Month Social',
    optionB: 'Made in Melanin! Black History Month Social',
    votesA: 12000,
    votesB: 12000,
    imageAsset: 'assets/images/event.png',
  ),
];

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDoc = ref.watch(currentUserDocProvider).value;
    final isAdmin = userDoc?.isAdmin ?? false;

    final events = ref.watch(allEventsProvider).value ?? sampleEvents;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          color: AppColors.primary,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Group Avatar
                  InkWell(
                    onTap: () {
                      context.pushNamed(
                        RoutePaths.groupProfile,
                        pathParameters: {'groupId': 'business-group'},
                      );
                    },
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/person.png'),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Group Title
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        context.pushNamed(
                          RoutePaths.groupProfile,
                          pathParameters: {'groupId': 'business-group'},
                        );
                      },
                      child: Text(
                        'Business group',
                        style: AppTextStyles.title.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Menu icon
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: AppBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            children: [
              // Today label
              Center(
                child: Text(
                  'Today',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondaryOf(context),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Poll Cards
              ...samplePolls.map((poll) => PollCard(poll: poll)),

              // Event Cards
              ...events.map((event) => EventCard(event: event)),
            ],
          ),
        ),
      ),

      // Floating Action Buttons (ONLY visible for Admin users)
      floatingActionButton: isAdmin
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Vote / Create Poll Button
                FloatingActionButton.extended(
                  heroTag: 'createPollFab',
                  onPressed: () => context.pushNamed(RoutePaths.createPoll),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  icon: const Icon(Icons.how_to_vote_outlined),
                  label: const Text('Vote'),
                ),

                const SizedBox(height: 12),

                // Event / Create Event Button
                FloatingActionButton.extended(
                  heroTag: 'createEventFab',
                  onPressed: () => context.pushNamed(RoutePaths.createEvent),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  icon: const Icon(Icons.add),
                  label: const Text('Event'),
                ),
              ],
            )
          : null,
    );
  }
}
