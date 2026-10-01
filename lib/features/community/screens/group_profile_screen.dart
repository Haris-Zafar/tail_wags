import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
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

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.surfaceDark : Colors.white;
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          // Top Red Header with Paw Pattern & Overlapping Avatar
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // 1. Red Header Container with Background Image Pattern
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  image: DecorationImage(
                    image: const AssetImage('assets/images/bg_pattern.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.white.withValues(alpha: 0.95),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

              // 2. White Section Overlay starting below header with Top Rounded Corners
              Container(
                margin: const EdgeInsets.only(top: 130),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: const SizedBox(height: 50), // spacer for avatar
              ),

              // 3. Overlapping Circular Avatar Image
              Positioned(
                top: 80,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: bg,
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    radius: 46,
                    backgroundImage: AssetImage('assets/images/person.png'),
                  ),
                ),
              ),
            ],
          ),

          // Scrollable White Body Content
          Expanded(
            child: Container(
              color: bg,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                children: [
                  // Group Info: Title, Description, Member Pill Badge
                  Column(
                    children: [
                      Text(
                        'Business group',
                        style: AppTextStyles.headline.copyWith(
                          color: textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Lorem ipsum dolor sit amet consectetur. Cras elit volutpat morbi mauris tincidunt lacus.',
                          style: AppTextStyles.body.copyWith(
                            color: textSecondary,
                            fontSize: 13,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Member count pill badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF3D2525) : const Color(0xFFFCDCDD),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '14K Members',
                          style: AppTextStyles.button.copyWith(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Group Events Section Header
                  Text(
                    'Group Events',
                    style: AppTextStyles.title.copyWith(
                      color: textPrimary,
                      fontSize: 18,
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

                  const SizedBox(height: 16),

                  // Group Polls Section (if present)
                  if (polls.isNotEmpty) ...[
                    Text(
                      'Group Polls',
                      style: AppTextStyles.title.copyWith(
                        color: textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...polls.map((poll) => PollCard(poll: poll)),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
