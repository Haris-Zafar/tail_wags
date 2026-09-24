import 'package:flutter/material.dart';

/// Temporary scaffold used to stub out every route in Phase 1 so the whole
/// app is navigable before any real screen UI exists. Swap each usage out
/// for the real screen as you reach it in Phases 2–5 — the router doesn't
/// need to change when you do.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    this.subtitle,
    this.onNext,
    this.nextLabel = 'Continue',
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onNext;
  final String nextLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(subtitle ?? 'Stub screen — replace with real UI.'),
              if (onNext != null) ...[
                const SizedBox(height: 24),
                ElevatedButton(onPressed: onNext, child: Text(nextLabel)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
