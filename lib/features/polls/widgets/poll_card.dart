import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/poll_model.dart';
import '../providers/polls_provider.dart';

class PollCard extends ConsumerStatefulWidget {
  const PollCard({
    super.key,
    required this.poll,
  });

  final PollModel poll;

  @override
  ConsumerState<PollCard> createState() => _PollCardState();
}

class _PollCardState extends ConsumerState<PollCard> {
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserDocProvider).value;
    if (user != null) {
      _selectedOption = widget.poll.votedUserIds[user.uid];
    }
  }

  Future<void> _vote(String option) async {
    final user = ref.read(currentUserDocProvider).value;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to vote.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _selectedOption = option);

    final pollService = ref.read(pollServiceProvider);
    await pollService.voteOnPoll(
      pollId: widget.poll.id,
      uid: user.uid,
      option: option,
    );
  }

  String _formatVotes(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(0)}k Votes';
    }
    return '$count Votes';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.surfaceDark : AppColors.surface;
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final borderColor = AppColors.borderOf(context);

    final isOptionASelected = _selectedOption == 'A';
    final isOptionBSelected = _selectedOption == 'B';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                widget.poll.imageAsset,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: AppColors.primaryLight,
                  child: const Icon(Icons.poll, size: 48, color: AppColors.primary),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Question
            Text(
              widget.poll.question,
              style: AppTextStyles.title.copyWith(
                color: textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 12),

            // Option A
            InkWell(
              onTap: () => _vote('A'),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('A. ', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: textPrimary)),
                    Icon(
                      isOptionASelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: isOptionASelected ? AppColors.primary : textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.poll.optionA, style: AppTextStyles.body.copyWith(color: textPrimary)),
                          Text(_formatVotes(widget.poll.votesA), style: AppTextStyles.caption.copyWith(color: textSecondary, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Option B
            InkWell(
              onTap: () => _vote('B'),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('B. ', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: textPrimary)),
                    Icon(
                      isOptionBSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: isOptionBSelected ? AppColors.primary : textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.poll.optionB, style: AppTextStyles.body.copyWith(color: textPrimary)),
                          Text(_formatVotes(widget.poll.votesB), style: AppTextStyles.caption.copyWith(color: textSecondary, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Timestamp
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '12hr ago',
                style: AppTextStyles.caption.copyWith(color: textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
