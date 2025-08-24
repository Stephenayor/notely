import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notely/presentation/home/note_card_item.dart';
import 'package:notely/utils/routes.dart';
import 'package:provider/provider.dart';
import 'home_viewmodel.dart';
import 'note_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _anim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    Future.microtask(() => context.read<HomeViewModel>().listenToNotes());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color purpleA = Color(0xFF6C63FF);
    const Color purpleB = Color(0xFF836FFF);
    const Color accentNavy = Color(0xFF122153);

    final homeViewModel = context.watch<HomeViewModel>();

    // Control animation based on fab state
    homeViewModel.fabOpen ? _controller.forward() : _controller.reverse();

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFBF8FF), Color(0xFFF6F4FB)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          onChanged: homeViewModel.updateSearch,
                          decoration: const InputDecoration(
                            hintText: 'Search Notes',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Filter chips
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: homeViewModel.filters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final selected =
                          index == homeViewModel.selectedFilterIndex;
                      return ChoiceChip(
                        label: Text(
                          homeViewModel.filters[index],
                          style: TextStyle(
                            color: selected ? Colors.white : accentNavy,
                          ),
                        ),
                        selected: selected,
                        onSelected: (_) => homeViewModel.selectedFilter(index),
                        backgroundColor: Colors.white,
                        selectedColor: purpleA,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 14),

                // Cards Grid
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (homeViewModel.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (homeViewModel.errorMessage != null) {
                        return Center(
                          child: Text(
                            homeViewModel.errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      if (homeViewModel.filteredNotes.isEmpty) {
                        return const Center(child: Text("No notes found"));
                      }

                      return GridView.builder(
                        itemCount: homeViewModel.filteredNotes.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.78,
                            ),
                        itemBuilder: (_, index) {
                          final note = homeViewModel.filteredNotes[index];
                          return NoteCardItem(note: note);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // FAB
      floatingActionButton: SizedBox(
        width: 70,
        height: 200,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Positioned(
              right: 0,
              bottom: 90,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.0, end: 1.0).animate(_anim),
                child: Column(
                  children: [
                    _takeNoteRelatedActions(
                      icon: Icons.camera_alt,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 12),
                    _takeNoteRelatedActions(
                      icon: Icons.note_add,
                      onPressed: () async {
                        await context.push(Routes.createNote);

                        // context.read<HomeViewModel>().listenToNotes();
                      },
                    ),
                    const SizedBox(height: 12),
                    _takeNoteRelatedActions(icon: Icons.edit, onPressed: () {}),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: homeViewModel.toggleFab,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [purpleA, purpleB]),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x44000000),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: AnimatedRotation(
                      turns: homeViewModel.fabOpen ? 0.125 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _takeNoteRelatedActions({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: const Color(0xFF3B4A8A)),
        ),
      ),
    );
  }
}
