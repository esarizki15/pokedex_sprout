import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex/data/models/pokemon_model.dart';

class AboutTab extends StatelessWidget {
  final PokemonModel pokemon;

  const AboutTab({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    // --- Unit Conversion Logic ---

    // Height: API returns height in decimeters (dm).
    // Convert to meters (/10) and feet/inches.
    double heightInMeters = pokemon.height / 10;
    double totalInches = pokemon.height * 3.93701;
    int feet = (totalInches / 12).floor();
    int inches = (totalInches % 12).round();

    String heightString =
        "$feet'$inches\" (${heightInMeters.toStringAsFixed(2)} m)";

    // Weight: API returns weight in hectograms (hg).
    // Convert to kg (/10) and lbs.
    double weightInKg = pokemon.weight / 10;
    double weightInLbs = weightInKg * 2.20462;

    String weightString =
        "${weightInLbs.toStringAsFixed(1)} lbs (${weightInKg.toStringAsFixed(1)} kg)";

    // Format Abilities: Capitalize first letter and join with commas
    String abilities = pokemon.abilities
        .map((e) => e[0].toUpperCase() + e.substring(1))
        .join(", ");

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          _buildInfoRow(
            "Species",
            "Pokemon",
          ), // Placeholder (Requires separate API call)
          const SizedBox(height: 16),
          _buildInfoRow("Height", heightString),
          const SizedBox(height: 16),
          _buildInfoRow("Weight", weightString),
          const SizedBox(height: 16),
          _buildInfoRow("Abilities", abilities),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
