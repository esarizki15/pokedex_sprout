import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/data/models/pokemon_model.dart';
import 'package:pokedex/data/repositories/pokemon_repository.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late PokemonRepository repository;

  setUp(() {
    mockDio = MockDio();
    repository = PokemonRepository(dio: mockDio);
  });

  group('PokemonRepository', () {
    test('getPokemonList returns List<PokemonModel> on success', () async {
      // ARRANGE

      // 1. Mock Response for LIST endpoint (Paginated results)
      final mockListResponse = {
        'results': [
          {'name': 'bulbasaur', 'url': 'https://pokeapi.co/api/v2/pokemon/1/'},
        ],
      };

      // 2. Mock Response for DETAIL endpoint (Single Pokemon data)
      final mockDetailResponse = {
        'id': 1,
        'name': 'bulbasaur',
        'sprites': {
          'front_default': 'img.png',
          'other': {
            'official-artwork': {'front_default': 'img.png'},
          },
        },
        'types': [
          {
            'type': {'name': 'grass'},
          },
        ],
        'height': 7,
        'weight': 69,
        'stats': [
          {
            'base_stat': 45,
            'stat': {'name': 'hp'},
          },
        ],
        'moves': [],
        'abilities': [],
      };

      // Stubbing: Return list response when the pagination endpoint is called
      when(
        () => mockDio.get(
          'https://pokeapi.co/api/v2/pokemon',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: mockListResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Stubbing: Return detail response when the specific Pokemon URL is called
      when(
        () => mockDio.get('https://pokeapi.co/api/v2/pokemon/1/'),
      ).thenAnswer(
        (_) async => Response(
          data: mockDetailResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // ACT
      final result = await repository.getPokemonList(0, 1);

      // ASSERT
      expect(result, isA<List<PokemonModel>>()); // Verify return type
      expect(result.length, 1); // Verify list length
      expect(result.first.name, 'bulbasaur'); // Verify content correctness
    });

    test('throws Exception when API fails', () async {
      // Stubbing: Simulate an API error (e.g., 404 or 500)
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.badResponse,
        ),
      );

      // ASSERT: Verify that the repository throws an exception
      expect(repository.getPokemonList(0, 20), throwsException);
    });
  });
}
