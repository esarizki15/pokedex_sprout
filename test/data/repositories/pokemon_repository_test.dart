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

      // 1. Mock Response untuk LIST (https://pokeapi.co/api/v2/pokemon?...)
      final mockListResponse = {
        'results': [
          {'name': 'bulbasaur', 'url': 'https://pokeapi.co/api/v2/pokemon/1/'},
        ],
      };

      // 2. Mock Response untuk DETAIL (https://pokeapi.co/api/v2/pokemon/1/)
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

      // When call LIST endpoint -> return list
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

      // When call DETAIL endpoint -> return detail
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
      expect(result, isA<List<PokemonModel>>()); // Pastikan return List
      expect(result.length, 1); // Pastikan isinya 1
      expect(result.first.name, 'bulbasaur'); // Pastikan namanya benar
    });

    test('throws Exception when API fails', () async {
      // Mock Error
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.badResponse,
        ),
      );

      // Assert Error
      expect(repository.getPokemonList(0, 20), throwsException);
    });
  });
}
