import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class TailWagsApp extends ConsumerWidget {
  const TailWagsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'TailWags',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // TODO (Phase 5, step 21): drive this from theme_provider once the
      // dark-mode toggle in Settings is wired up.
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
