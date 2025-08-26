import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router.dart';
import 'app/theme.dart';

final roleProvider = StateProvider<AppRole?>((ref) => null);

void main() {
  runApp(const ProviderScope(child: StuddyBuddyApp()));
}

class StuddyBuddyApp extends ConsumerWidget {
  const StuddyBuddyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = AppRouter(
      getCurrentRole: () => ref.read(roleProvider),
    ).router;

    return MaterialApp.router(
      title: 'Studdy Buddy',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}


