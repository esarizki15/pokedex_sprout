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
    Color color = value < 50 ? Colors.redAccent : Colors.green;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
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
          SizedBox(
            width: 50,
            child: Text(
              value.toString(),
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
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
