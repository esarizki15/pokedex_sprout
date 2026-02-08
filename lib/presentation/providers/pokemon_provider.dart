import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pokedex/data/models/pokemon_model.dart';
import 'package:pokedex/data/repositories/pokemon_repository.dart';

// Provides the PokemonRepository instance
final pokemonRepositoryProvider = Provider<PokemonRepository>((ref) {
  return PokemonRepository();
});

// Manages the state of the Pokemon list (Pagination)
final pokemonListProvider =
    StateNotifierProvider<PokemonListNotifier, AsyncValue<List<PokemonModel>>>((
      ref,
    ) {
      return PokemonListNotifier(ref.watch(pokemonRepositoryProvider));
    });

class PokemonListNotifier
    extends StateNotifier<AsyncValue<List<PokemonModel>>> {
  final PokemonRepository _repository;

  // Internal pagination state
  int _offset = 0;
  final int _limit = 20;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  PokemonListNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchNextPage(); // Automatically fetch initial data
  }

  Future<void> fetchNextPage() async {
    // Guard clause: prevent fetching if already loading or if no more data exists
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;

    try {
      final newPokemons = await _repository.getPokemonList(_offset, _limit);

      if (newPokemons.isEmpty) {
        _hasMore = false;
        _isLoadingMore = false;
        return;
      }

      // Append new data to the existing list
      state.whenData((oldPokemons) {
        state = AsyncValue.data([...oldPokemons, ...newPokemons]);
      });

      // Handle initial load case
      if (state.value == null || state.value!.isEmpty) {
        state = AsyncValue.data(newPokemons);
      }

      // Increment offset for the next fetch
      _offset += _limit;
    } catch (e, stack) {
      // Only show error state if the list is completely empty (initial load failed)
      // Errors during "load more" are ignored to keep the existing list visible
      if (state.value == null || state.value!.isEmpty) {
        state = AsyncValue.error(e, stack);
      }
    } finally {
      _isLoadingMore = false;
    }
  }
}
