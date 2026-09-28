import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_background.dart';

class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.message,
    required this.time,
    required this.isUnread,
    this.imageAsset = 'assets/images/notification.png',
  });

  final String id;
  final String message;
  final String time;
  final bool isUnread;
  final String imageAsset;
}

final sampleNotifications = [
  const NotificationItem(
    id: '1',
    message: 'Lorem ipsum dolor sit amet consectetur.',
    time: '4:00pm',
    isUnread: true,
  ),
  const NotificationItem(
    id: '2',
    message: 'Lorem ipsum dolor sit amet consectetur.',
    time: '4:00pm',
    isUnread: true,
  ),
  const NotificationItem(
    id: '3',
    message: 'Lorem ipsum dolor sit amet consectetur.',
    time: '4:00pm',
    isUnread: true,
  ),
  const NotificationItem(
    id: '4',
    message: 'Lorem ipsum dolor sit amet consectetur.',
    time: '4:00pm',
    isUnread: false,
  ),
  const NotificationItem(
    id: '5',
    message: 'Lorem ipsum dolor sit amet consectetur.',
    time: '4:00pm',
    isUnread: false,
  ),
  const NotificationItem(
    id: '6',
    message: 'Lorem ipsum dolor sit amet consectetur.',
    time: '4:00pm',
    isUnread: false,
  ),
  const NotificationItem(
    id: '7',
    message: 'Lorem ipsum dolor sit amet consectetur.',
    time: '4:00pm',
    isUnread: false,
  ),
  const NotificationItem(
    id: '8',
    message: 'Lorem ipsum dolor sit amet consectetur.',
    time: '4:00pm',
    isUnread: false,
  ),
];

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final cardBg = isDark ? AppColors.surfaceDark : AppColors.surfaceMuted;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: AppBackground(
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            itemCount: sampleNotifications.length,
            itemBuilder: (context, index) {
              final item = sampleNotifications[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    // Square Thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        item.imageAsset,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 48,
                          height: 48,
                          color: AppColors.primaryLight,
                          child: const Icon(Icons.notifications, color: AppColors.primary),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Notification Text
                    Expanded(
                      child: Text(
                        item.message,
                        style: AppTextStyles.body.copyWith(
                          color: textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Time + Unread Red Dot
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (item.isUnread) ...[
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                        Text(
                          item.time,
                          style: AppTextStyles.caption.copyWith(
                            color: textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
