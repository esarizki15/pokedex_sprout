import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex/core/constants/app_colors.dart';
import 'package:pokedex/data/models/pokemon_model.dart';

class PokemonCard extends StatelessWidget {
  final PokemonModel pokemon;
  final VoidCallback? onTap;

  const PokemonCard({super.key, required this.pokemon, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Determine card color based on the primary type
    final color = AppColors.getTypeColor(pokemon.types.first);

    return GestureDetector(
      onTap: onTap,
      // Use LayoutBuilder to access the current constraints of the card
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate element sizes proportionally based on card height
          final double cardHeight = constraints.maxHeight;

          // Background Pokeball size: 82% of the card height
          final double pokeballSize = cardHeight * 0.82;

          // Pokemon Image size: 70% of the card height
          final double pokemonSize = cardHeight * 0.70;

          return Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  // 1. BACKGROUND: Pokeball (Responsive Size)
                  Positioned(
                    bottom: -15, // Slight offset to the bottom-right
                    right: -10,
                    child: Icon(
                      Icons.catching_pokemon,
                      color: Colors.white.withValues(alpha: 0.2),
                      size: pokeballSize, // Dynamic Size
                    ),
                  ),

                  // 2. INFO: Name & Type (Top Left)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Use Flexible to prevent text overflow on smaller screens
                        Flexible(
                          child: Text(
                            pokemon.name[0].toUpperCase() +
                                pokemon.name.substring(1),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: pokemon.types
                              .map(
                                (type) => Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    type,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),

                  // 3. FOREGROUND: Pokemon Image (Responsive Size)
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Hero(
                      tag: pokemon.id,
                      child: CachedNetworkImage(
                        imageUrl: pokemon.imageUrl,
                        height: pokemonSize, // Dynamic Size (70%)
                        width: pokemonSize, // Dynamic Size (70%)
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const SizedBox(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error, color: Colors.white),
                      ),
                    ),
                  ),

                  // 4. ID Number (Top Right)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Text(
                      "#${pokemon.id.toString().padLeft(3, '0')}",
                      style: GoogleFonts.poppins(
                        color: Colors.black.withValues(alpha: 0.15),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
