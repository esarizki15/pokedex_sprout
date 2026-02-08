import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart'; // Import router yang baru

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Panggil routerProvider yang sudah kita buat
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Pokedex Senior Test',
      debugShowCheckedModeBanner: false,

      // Theme Setup
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        scaffoldBackgroundColor: Colors.white,
      ),

      // Router Config
      routerConfig: router,
    );
  }
}
