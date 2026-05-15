import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _selectedChipIndex = 0;
  final List<String> _chips = ["Playlists", "Albums", "Artists", "Songs"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            flexibleSpace: const FlexibleSpaceBar(
              titlePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              title: Text(
                "Library", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34, color: Colors.black, letterSpacing: -1.0)
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12, top: 12),
                child: IconButton(
                  onPressed: () {}, 
                  icon: const Icon(Icons.add_rounded, color: Color(0xFF2196F3), size: 32)
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildChips(),
                const SizedBox(height: 32),
                _buildPlaylistList(),
                const SizedBox(height: 160),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChips() {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: _chips.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedChipIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedChipIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1C1C1E) : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  _chips[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaylistList() {
    final playlists = [
      {"name": "Chill Vibes", "count": 24, "colors": [const Color(0xFF5E35B1), const Color(0xFFEF5350)]},
      {"name": "Morning Run", "count": 18, "colors": [const Color(0xFF00695C), const Color(0xFF4DB6AC)]},
      {"name": "Late Night Drive", "count": 31, "colors": [const Color(0xFF1C1C1E), const Color(0xFF48484A)]},
      {"name": "Focus Mode", "count": 15, "colors": [const Color(0xFF1976D2), const Color(0xFF9575CD)]},
      {"name": "Throwbacks", "count": 42, "colors": [const Color(0xFF00838F), const Color(0xFFFBC02D)]},
    ];

    return Column(
      children: playlists.map((p) => ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        leading: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: p["colors"] as List<Color>,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
        title: Text(
          p["name"] as String, 
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: -0.5)
        ),
        subtitle: Text(
          "Playlist • ${p["count"]} songs", 
          style: TextStyle(color: Colors.grey.shade500, fontSize: 15, fontWeight: FontWeight.w500)
        ),
        trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400, size: 24),
      )).toList(),
    );
  }
}
