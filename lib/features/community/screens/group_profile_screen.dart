import 'package:flutter/material.dart';

import '../../../core/widgets/placeholder_screen.dart';

/// Stub for now — group data header + list of the group's events as
/// event cards are built in Phase 4, step 18.
class GroupProfileScreen extends StatelessWidget {
  const GroupProfileScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Group Profile',
      subtitle: 'groupId: $groupId',
    );
  }
}
