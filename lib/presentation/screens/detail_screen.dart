import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex/data/models/pokemon_model.dart';
import 'package:pokedex/presentation/widgets/detail/about_tab.dart';
import 'package:pokedex/presentation/widgets/detail/base_stats_tab.dart';
import 'package:pokedex/presentation/widgets/detail/evolution_tab.dart';
import 'package:pokedex/presentation/widgets/detail/moves_tab.dart';

class DetailScreen extends StatefulWidget {
  final PokemonModel pokemon;

  const DetailScreen({super.key, required this.pokemon});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // OrientationBuilder wraps Scaffold to allow conditional AppBar rendering
    return OrientationBuilder(
      builder: (context, orientation) {
        final isPortrait = orientation == Orientation.portrait;

        return Scaffold(
          backgroundColor: widget.pokemon.color,

          // Conditional AppBar Logic:
          // Portrait: Use default AppBar (Body coordinates start below it).
          // Landscape: Set AppBar to null to maximize screen space (Manual back button required).
          appBar: isPortrait
              ? AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                )
              : null,

          // Switch layout based on orientation
          body: isPortrait
              ? _buildPortraitLayout(context)
              : _buildLandscapeLayout(context),
        );
      },
    );
  }

  // --- PORTRAIT LAYOUT ---
  Widget _buildPortraitLayout(BuildContext context) {
    final pokemon = widget.pokemon;

    return Stack(
      children: [
        // 1. Header Info (Name, ID, Types)
        Positioned(
          left: 24,
          right: 24,
          top: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "#${pokemon.id.toString().padLeft(3, '0')}",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: pokemon.types
                    .map(
                      (type) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          type,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),

        // 2. Background Pokeball Decoration
        Positioned(
          top: 105,
          right: -20,
          child: Icon(
            Icons.catching_pokemon,
            color: Colors.white.withValues(alpha: 0.25),
            size: 250,
          ),
        ),

        // 3. White Bottom Sheet (Content Area)
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.565,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                _buildTabBar(),
                Expanded(child: _buildTabBarView()),
              ],
            ),
          ),
        ),

        // 4. Hero Image (Floating above the sheet)
        Positioned(
          top: 85,
          left: 0,
          right: 0,
          child: Hero(
            tag: pokemon.id,
            child: CachedNetworkImage(
              imageUrl: pokemon.imageUrl,
              height: 260,
              fit: BoxFit.contain,
              placeholder: (context, url) => const SizedBox(),
            ),
          ),
        ),
      ],
    );
  }

  // --- LANDSCAPE LAYOUT ---
  Widget _buildLandscapeLayout(BuildContext context) {
    final pokemon = widget.pokemon;

    return Row(
      children: [
        // Left Side: Info & Image
        Expanded(
          flex: 4,
          child: Container(
            color: pokemon.color,
            child: Stack(
              children: [
                Positioned(
                  bottom: -50,
                  left: -50,
                  child: Icon(
                    Icons.catching_pokemon,
                    color: Colors.white.withValues(alpha: 0.25),
                    size: 250,
                  ),
                ),
                // Manual Back Button (Since AppBar is null)
                Positioned(
                  top: 20,
                  left: 10,
                  child: SafeArea(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: pokemon.id,
                        child: CachedNetworkImage(
                          imageUrl: pokemon.imageUrl,
                          height: 150, // Smaller image for landscape
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        pokemon.name[0].toUpperCase() +
                            pokemon.name.substring(1),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Type Chips
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: pokemon.types
                            .map(
                              (type) => Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
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
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Right Side: Tabs Content
        Expanded(
          flex: 6,
          child: Container(
            color: Colors.white,
            child: SafeArea(
              left: false,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  _buildTabBar(),
                  Expanded(child: _buildTabBarView()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper Widgets
  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      labelStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      indicatorColor: const Color(0xFF6C79DB),
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: Colors.transparent,
      tabs: const [
        Tab(text: "About"),
        Tab(text: "Stats"),
        Tab(text: "Evolution"),
        Tab(text: "Moves"),
      ],
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        AboutTab(pokemon: widget.pokemon),
        BaseStatsTab(pokemon: widget.pokemon),
        EvolutionTab(pokemonId: widget.pokemon.id),
        MovesTab(pokemon: widget.pokemon),
      ],
    );
  }
}
