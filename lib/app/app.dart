import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_config.dart';
import '../core/config/app_config_provider.dart';
import '../theme/app_theme.dart';
import 'router/app_router.dart';

/// Boots the app with the given [config] (the flavor seam). A `main_prod.dart`
/// would call `bootstrap(AppConfig.prod)` instead.
void bootstrap(AppConfig config) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      overrides: [appConfigProvider.overrideWithValue(config)],
      child: const OddoApp(),
    ),
  );
}

/// Root widget: wires the router + theme into [MaterialApp.router].
class OddoApp extends ConsumerWidget {
  const OddoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final config = ref.watch(appConfigProvider);

    return MaterialApp.router(
      title: config.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
