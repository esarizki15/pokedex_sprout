class PokemonModel {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;

  PokemonModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
  });

  factory PokemonModel.fromDetailJson(Map<String, dynamic> json) {
    return PokemonModel(
      id: json['id'],
      name: json['name'],
      // Prioritaskan Official Artwork, fallback ke sprite biasa
      imageUrl:
          json['sprites']['other']['official-artwork']['front_default'] ??
          json['sprites']['front_default'] ??
          "",
      types: (json['types'] as List)
          .map((t) => t['type']['name'].toString())
          .toList(),
    );
  }
}
