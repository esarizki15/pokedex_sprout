import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/detail_screen.dart';
import '../../data/models/pokemon_model.dart';

// Provider ini yang akan dipanggil di main.dart
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      // Route Home
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          // Nested Route untuk Detail (Biar URL-nya jadi /detail)
          // Atau bisa sejajar, tergantung preferensi URL
          GoRoute(
            path: 'detail',
            name: 'detail',
            builder: (context, state) {
              // Mengambil object pokemon yang dikirim via parameter 'extra'
              final pokemon = state.extra as PokemonModel;
              return DetailScreen(pokemon: pokemon);
            },
          ),
        ],
      ),
    ],
    // Error handling page bisa ditambahkan di sini (errorBuilder)
  );
});
