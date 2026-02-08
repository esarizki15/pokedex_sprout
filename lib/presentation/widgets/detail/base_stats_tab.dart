import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex/data/models/pokemon_model.dart';

class BaseStatsTab extends StatelessWidget {
  final PokemonModel pokemon;

  const BaseStatsTab({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Safely access stats from the map with a default value of 0
          _buildStatRow("HP", pokemon.stats['hp'] ?? 0),
          _buildStatRow("Attack", pokemon.stats['attack'] ?? 0),
          _buildStatRow("Defense", pokemon.stats['defense'] ?? 0),
          _buildStatRow("Sp. Atk", pokemon.stats['special-attack'] ?? 0),
          _buildStatRow("Sp. Def", pokemon.stats['special-defense'] ?? 0),
          _buildStatRow("Speed", pokemon.stats['speed'] ?? 0),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int value) {
    // Visual Logic: Highlight low stats (< 50) in red, others in green
    Color color = value < 50 ? Colors.redAccent : Colors.green;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // 1. Label
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // 2. Numeric Value
          SizedBox(
            width: 50,
            child: Text(
              value.toString(),
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
          // 3. Visual Bar
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                // Normalize value assuming 150 is a high base stat standard
                // (e.g., Mewtwo Sp.Atk is 154)
                value: value / 150,
                backgroundColor: Colors.grey[200],
                color: color,
                minHeight: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
