import 'package:flutter/material.dart';
import 'package:pokedex/core/constants/app_colors.dart';

class PokemonModel {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int height;
  final int weight;
  final Map<String, int> stats;
  final List<String> moves;
  final List<String> abilities;

  PokemonModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
    required this.stats,
    required this.moves,
    required this.abilities,
  });

  factory PokemonModel.fromDetailJson(Map<String, dynamic> json) {
    // Parse base stats into a map for easier access by stat name
    final Map<String, int> statsMap = {};
    for (var item in json['stats']) {
      statsMap[item['stat']['name']] = item['base_stat'];
    }

    // Limit to 15 moves to prevent UI clutter in the detail view
    final List<String> movesList = (json['moves'] as List)
        .take(15)
        .map((m) => m['move']['name'].toString())
        .toList();

    final List<String> abilitiesList = (json['abilities'] as List)
        .map((a) => a['ability']['name'].toString())
        .toList();

    return PokemonModel(
      id: json['id'],
      name: json['name'],
      // Prioritize official artwork, fallback to default sprite
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
      abilities: abilitiesList,
    );
  }

  // Helper to determine background color based on the primary type
  Color get color {
    if (types.isEmpty) return const Color(0xFF777777);
    return AppColors.getTypeColor(types.first);
  }
}
