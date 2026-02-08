import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/models/pokemon_model.dart';
import '../../data/repositories/pokemon_repository.dart';

// Dependency Injection: Dio & Repository
final dioProvider = Provider((ref) => Dio());

final repositoryProvider = Provider(
  (ref) => PokemonRepository(ref.watch(dioProvider)),
);

// State Management Logic
class PokemonListNotifier
    extends StateNotifier<AsyncValue<List<PokemonModel>>> {
  final PokemonRepository _repository;
  int _offset = 0;
  final int _limit = 20;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  PokemonListNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchNextPage(); // Load initial data
  }

  Future<void> fetchNextPage() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;

    try {
      // Panggil Repository
      final newPokemons = await _repository.getPokemons(
        offset: _offset,
        limit: _limit,
      );

      if (newPokemons.isEmpty) {
        _hasMore = false;
        _isLoadingMore = false;
        return;
      }
      // Update State: Append data baru ke data lama
      if (state.value != null) {
        state = AsyncValue.data([...state.value!, ...newPokemons]);
      } else {
        state = AsyncValue.data(newPokemons);
      }

      _offset += _limit;
    } catch (e, stack) {
      if (state.value == null) {
        state = AsyncValue.error(e, stack);
      }
    } finally {
      _isLoadingMore = false;
    }
  }
}

// Provider yang dipanggil UI
final pokemonListProvider =
    StateNotifierProvider<PokemonListNotifier, AsyncValue<List<PokemonModel>>>((
      ref,
    ) {
      return PokemonListNotifier(ref.watch(repositoryProvider));
    });
