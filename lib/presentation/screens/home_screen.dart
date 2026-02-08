import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/pokemon_provider.dart';
import '../widgets/pokemon_card.dart';

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
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;

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
      // HAPUS extendBodyBehindAppBar karena kita mau pakai SafeArea
      body: Stack(
        children: [
          // 1. BACKGROUND WATERMARK (Tetap di belakang semua layer)
          Positioned(
            top: -70,
            right: -70,
            child: Icon(
              Icons.catching_pokemon,
              color: Colors.black.withValues(alpha: 0.05),
              size: 300,
            ),
          ),

          // 2. COLUMN: Membagi layar menjadi Header (Fixed) dan Content (Scroll)
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- BAGIAN A: HEADER (DIAM) ---
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

                // --- BAGIAN B: LIST CONTENT (SCROLLABLE AREA) ---
                // Expanded memaksa CustomScrollView hanya menempati sisa ruang di bawah Header
                Expanded(
                  child: pokemonState.when(
                    loading: () => _buildShimmerLoading(),
                    error: (err, stack) => Center(child: Text('Error: $err')),
                    data: (pokemons) {
                      if (pokemons.isEmpty) {
                        return const Center(
                          child: Text("No Pokemon Data Found"),
                        );
                      }

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final int crossAxisCount = constraints.maxWidth > 600
                              ? 4
                              : 2;

                          return CustomScrollView(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            slivers: [
                              // Grid Pokemon
                              SliverPadding(
                                // Padding top 0 karena sudah ada jarak dari Header
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
                                        // Navigasi ke Detail
                                      },
                                    );
                                  }, childCount: pokemons.length),
                                ),
                              ),

                              // Loader Bawah
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

  Widget _buildShimmerLoading() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 8,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
