import 'package:flutter/material.dart';

import '../../../core/widgets/placeholder_screen.dart';

/// Stub for now — filtered view over liked events, reusing the Features
/// filter sheet, is built in Phase 4, step 16.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(title: 'Favorite');
  }
}
