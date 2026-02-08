import 'package:flutter/material.dart';

class PokemonModel {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int height;
  final int weight;
  final Map<String, int> stats;
  final List<String> moves;
  final List<String> abilities; // FIELD BARU

  PokemonModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
    required this.stats,
    required this.moves,
    required this.abilities, // FIELD BARU
  });

  factory PokemonModel.fromDetailJson(Map<String, dynamic> json) {
    // Parsing Stats
    final Map<String, int> statsMap = {};
    for (var item in json['stats']) {
      statsMap[item['stat']['name']] = item['base_stat'];
    }

    // Parsing Moves (Limit 15)
    final List<String> movesList = (json['moves'] as List)
        .take(15)
        .map((m) => m['move']['name'].toString())
        .toList();

    // Parsing Abilities (FIELD BARU)
    final List<String> abilitiesList = (json['abilities'] as List)
        .map((a) => a['ability']['name'].toString())
        .toList();

    return PokemonModel(
      id: json['id'],
      name: json['name'],
      imageUrl:
          json['sprites']['other']['official-artwork']['front_default'] ??
          json['sprites']['front_default'] ??
          "",
      types: (json['types'] as List)
          .map((t) => t['type']['name'].toString())
          .toList(),
      height: json['height'],
      weight: json['weight'],
      stats: statsMap,
      moves: movesList,
      abilities: abilitiesList, // FIELD BARU
    );
  }

  Color get color {
    switch (types.first.toLowerCase()) {
      case 'grass':
        return const Color(0xFF48D0B0);
      case 'fire':
        return const Color(0xFFFB6C6C);
      case 'water':
        return const Color(0xFF76BDFE);
      case 'electric':
        return const Color(0xFFFFCE4B);
      case 'poison':
        return const Color(0xFFA33EA1);
      case 'bug':
        return const Color(0xFFA6B91A);
      case 'flying':
        return const Color(0xFFA890F0);
      case 'normal':
        return const Color(0xFFA8A77A);
      case 'ground':
        return const Color(0xFFE2BF65);
      case 'fairy':
        return const Color(0xFFD685AD);
      case 'psychic':
        return const Color(0xFFF95587);
      case 'fighting':
        return const Color(0xFFC22E28);
      case 'rock':
        return const Color(0xFFB6A136);
      case 'ghost':
        return const Color(0xFF735797);
      case 'ice':
        return const Color(0xFF96D9D6);
      case 'dragon':
        return const Color(0xFF6F35FC);
      default:
        return const Color(0xFF777777);
    }
  }
}
