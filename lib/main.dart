import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';

void main() {
  // ProviderScope is required at the root to initialize Riverpod
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the router provider to retrieve the GoRouter configuration
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Pokedex',
      // Remove the debug banner for a cleaner UI
      debugShowCheckedModeBanner: false,

      // Application Theme Configuration
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        scaffoldBackgroundColor: Colors.white,
      ),

      // Connect GoRouter configuration to MaterialApp
      routerConfig: router,
    );
  }
}
