import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/app_providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: StudybeatApp()));
}

class StudybeatApp extends ConsumerWidget {
  const StudybeatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final router = ref.watch(routerProvider);

    // Kick off local bootstrap once.
    ref.watch(appBootstrapProvider);

    return MaterialApp.router(
      title: 'Studybeat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(profile.colorTheme),
      routerConfig: router,
    );
  }
}
