import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pokedex/data/models/pokemon_model.dart';
import 'package:pokedex/data/repositories/pokemon_repository.dart';

// 1. Provider Repository (Cukup panggil constructor kosong)
final pokemonRepositoryProvider = Provider<PokemonRepository>((ref) {
  return PokemonRepository();
});

// 2. State Notifier Provider
final pokemonListProvider =
    StateNotifierProvider<PokemonListNotifier, AsyncValue<List<PokemonModel>>>((
      ref,
    ) {
      return PokemonListNotifier(ref.watch(pokemonRepositoryProvider));
    });

// 3. Logic Notifier (Tanpa Search, Fokus Pagination)
class PokemonListNotifier
    extends StateNotifier<AsyncValue<List<PokemonModel>>> {
  final PokemonRepository _repository;

  // State Internal Pagination
  int _offset = 0;
  final int _limit = 20;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  PokemonListNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchNextPage(); // Load data awal otomatis saat dipanggil
  }

  Future<void> fetchNextPage() async {
    // Cek guard clause: Jangan load kalau sedang loading atau data habis
    if (_isLoadingMore || !_hasMore) return;

    // Set loading flag (tapi jangan ubah state UI jadi loading spin besar)
    _isLoadingMore = true;

    try {
      // PERBAIKAN DI SINI:
      // 1. Nama method jadi 'getPokemonList'
      // 2. Parameter jadi positional (tanpa nama offset: / limit:)
      final newPokemons = await _repository.getPokemonList(_offset, _limit);

      if (newPokemons.isEmpty) {
        _hasMore = false;
        _isLoadingMore = false;
        return;
      }

      // Logic Append Data (Menggabungkan data lama + data baru)
      state.whenData((oldPokemons) {
        state = AsyncValue.data([...oldPokemons, ...newPokemons]);
      });

      // Jika state awal masih loading/null, isi langsung
      if (state.value == null || state.value!.isEmpty) {
        state = AsyncValue.data(newPokemons);
      }

      // Naikkan offset untuk fetch berikutnya
      _offset += _limit;
    } catch (e, stack) {
      // Hanya tampilkan error jika data benar-benar kosong (awal)
      // Jika error saat load more (scroll bawah), biarkan data lama tetap tampil
      if (state.value == null || state.value!.isEmpty) {
        state = AsyncValue.error(e, stack);
      }
    } finally {
      _isLoadingMore = false;
    }
  }
}
