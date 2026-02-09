import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex/presentation/providers/pokemon_provider.dart';
import 'package:pokedex/presentation/widgets/common/pokemon_card.dart';
import 'package:pokedex/presentation/widgets/common/shimmer_loading_grid.dart';
// Import widget shimmer yang baru dibuat

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Debounce scroll events to prevent excessive API calls
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;

        // Fetch next page when user scrolls to 90% of the list
        if (currentScroll >= maxScroll * 0.9) {
          ref.read(pokemonListProvider.notifier).fetchNextPage();
        }
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pokemonState = ref.watch(pokemonListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Background Watermark (Remains behind all layers)
          Positioned(
            top: -70,
            right: -70,
            child: Icon(
              Icons.catching_pokemon,
              color: Colors.black.withValues(alpha: 0.05),
              size: 300,
            ),
          ),

          // 2. Main Layout: Splits screen into Fixed Header and Scrollable Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- SECTION A: STATIC HEADER ---
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20.0,
                  ),
                  child: Text(
                    "Pokedex",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),

                // --- SECTION B: SCROLLABLE LIST ---
                // Expanded ensures CustomScrollView takes up only the remaining space
                Expanded(
                  child: pokemonState.when(
                    // Call the separated widget here
                    loading: () => const ShimmerLoadingGrid(),
                    error: (err, stack) => Center(child: Text('Error: $err')),
                    data: (pokemons) {
                      if (pokemons.isEmpty) {
                        return const Center(
                          child: Text("No Pokemon Data Found"),
                        );
                      }

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          // Adaptive Layout: 4 columns for tablets/desktop, 2 for mobile
                          final int crossAxisCount = constraints.maxWidth > 600
                              ? 4
                              : 2;

                          return CustomScrollView(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            slivers: [
                              // Pokemon Grid
                              SliverPadding(
                                // Top padding is 0 because Header already provides spacing
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 0,
                                  bottom: 16,
                                ),
                                sliver: SliverGrid(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        childAspectRatio: 1.4,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                      ),
                                  delegate: SliverChildBuilderDelegate((
                                    context,
                                    index,
                                  ) {
                                    return PokemonCard(
                                      pokemon: pokemons[index],
                                      onTap: () {
                                        context.push(
                                          '/detail',
                                          extra: pokemons[index],
                                        );
                                      },
                                    );
                                  }, childCount: pokemons.length),
                                ),
                              ),

                              // Bottom Loader (Infinite Scroll Indicator)
                              const SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24.0),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
