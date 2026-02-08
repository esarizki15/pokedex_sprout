import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedex/data/models/pokemon_model.dart';
import 'package:pokedex/presentation/screens/detail_screen.dart';
import 'package:pokedex/presentation/screens/home_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'detail',
            name: 'detail',
            builder: (context, state) {
              // Retrieve the Pokemon object passed via the 'extra' parameter
              final pokemon = state.extra as PokemonModel;
              return DetailScreen(pokemon: pokemon);
            },
          ),
        ],
      ),
    ],
  );
});
