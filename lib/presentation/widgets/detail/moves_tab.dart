import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex/data/models/pokemon_model.dart';

class MovesTab extends StatelessWidget {
  final PokemonModel pokemon;

  const MovesTab({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    if (pokemon.moves.isEmpty) {
      return const Center(child: Text("No Moves Data"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: pokemon.moves.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            pokemon.moves[index].replaceAll('-', ' ').toUpperCase(),
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
        );
      },
    );
  }
}
