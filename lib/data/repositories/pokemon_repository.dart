import 'package:dio/dio.dart';
import '../models/pokemon_model.dart';

class PokemonRepository {
  final Dio _dio;

  // Constructor dengan Dependency Injection untuk Testing
  PokemonRepository({Dio? dio}) : _dio = dio ?? Dio();

  // Method Pagination
  Future<List<PokemonModel>> getPokemonList(int offset, int limit) async {
    try {
      // 1. Ambil List URL
      final response = await _dio.get(
        'https://pokeapi.co/api/v2/pokemon',
        queryParameters: {'offset': offset, 'limit': limit},
      );

      final List results = response.data['results'];

      // 2. Ambil Detail setiap Pokemon secara paralel
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
