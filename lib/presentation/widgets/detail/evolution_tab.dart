import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EvolutionTab extends StatefulWidget {
  final int pokemonId;
  const EvolutionTab({super.key, required this.pokemonId});

  @override
  State<EvolutionTab> createState() => _EvolutionTabState();
}

class _EvolutionTabState extends State<EvolutionTab>
    with AutomaticKeepAliveClientMixin {
  late Future<List<Map<String, dynamic>>> _evolutionFuture;

  @override
  void initState() {
    super.initState();
    _evolutionFuture = fetchEvolution();
  }

  // Ensure the state is kept alive when switching tabs
  @override
  bool get wantKeepAlive => true;

  Future<List<Map<String, dynamic>>> fetchEvolution() async {
    // Note: In a production app, use a shared Dio instance via Provider/Repository
    final dio = Dio();
    try {
      // 1. Fetch Pokemon Species to get the Evolution Chain URL
      final speciesResponse = await dio.get(
        'https://pokeapi.co/api/v2/pokemon-species/${widget.pokemonId}/',
      );
      final evolutionUrl = speciesResponse.data['evolution_chain']['url'];

      // 2. Fetch the actual Evolution Chain
      final chainResponse = await dio.get(evolutionUrl);
      final chainData = chainResponse.data['chain'];

      List<Map<String, dynamic>> evolutions = [];

      // 3. Parse the chain (Handling linear evolution up to 3 stages)
      // Note: This logic assumes a linear chain and doesn't handle branched evolutions (e.g., Eevee)

      // Base Form
      evolutions.add(_parseSpecies(chainData['species']));

      // First Evolution
      if (chainData['evolves_to'].isNotEmpty) {
        var firstEvo = chainData['evolves_to'][0];
        evolutions.add(_parseSpecies(firstEvo['species']));

        // Second Evolution
        if (firstEvo['evolves_to'].isNotEmpty) {
          var secondEvo = firstEvo['evolves_to'][0];
          evolutions.add(_parseSpecies(secondEvo['species']));
        }
      }
      return evolutions;
    } catch (e) {
      return [];
    }
  }

  // Helper to extract Name and Image URL from species data
  Map<String, dynamic> _parseSpecies(Map<String, dynamic> speciesData) {
    final name = speciesData['name'];
    final url = speciesData['url'];

    // Extract ID from URL (e.g., https://pokeapi.co/.../1/) to build image URL
    final id = int.parse(url.split('/')[6]);
    final imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

    return {'name': name, 'image': imageUrl};
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required by AutomaticKeepAliveClientMixin

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _evolutionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Evolution Data Not Available"));
        }

        final evolutions = snapshot.data!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                "Evolution Chain",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),

              // Render Evolution Items
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: evolutions.map((evo) {
                  return Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: CachedNetworkImage(imageUrl: evo['image']),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        evo['name'].toString().toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),

              // Visual indicator (Arrow) if chain exists
              if (evolutions.length > 1)
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Icon(Icons.arrow_right_alt, color: Colors.grey),
                ),
            ],
          ),
        );
      },
    );
  }
}
