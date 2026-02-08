import 'package:dio/dio.dart';
import 'package:pokedex/data/models/pokemon_model.dart';

class PokemonRepository {
  final Dio _dio;

  // Constructor allowing Dependency Injection for unit testing
  PokemonRepository({Dio? dio}) : _dio = dio ?? Dio();

  // Fetches a paginated list of Pokemon
  Future<List<PokemonModel>> getPokemonList(int offset, int limit) async {
    try {
      // 1. Fetch the list of Pokemon URLs (Pagination)
      final response = await _dio.get(
        'https://pokeapi.co/api/v2/pokemon',
        queryParameters: {'offset': offset, 'limit': limit},
      );

      final List results = response.data['results'];

      // 2. Fetch details for each Pokemon in parallel
      // Using Future.wait significantly improves performance compared to sequential loops
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
