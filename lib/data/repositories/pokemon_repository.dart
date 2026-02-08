import 'package:dio/dio.dart';
import '../models/pokemon_model.dart';

class PokemonRepository {
  final Dio _dio;

  PokemonRepository(this._dio);

  Future<List<PokemonModel>> getPokemons({
    required int offset,
    required int limit,
  }) async {
    try {
      // 1. Fetch List Basic
      final response = await _dio.get(
        'https://pokeapi.co/api/v2/pokemon',
        queryParameters: {'offset': offset, 'limit': limit},
      );

      final List results = response.data['results'];

      // 2. Parallel Fetch Detail (Optimization)
      // Menggunakan Future.wait agar request berjalan bersamaan, tidak antri satu-satu
      final List<PokemonModel> pokemons = await Future.wait(
        results.map((e) async {
          final detailResponse = await _dio.get(e['url']);
          return PokemonModel.fromDetailJson(detailResponse.data);
        }),
      );

      return pokemons;
    } catch (e) {
      throw Exception('Failed to fetch pokemons: $e');
    }
  }
}
