import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            expandedHeight: 100,
            floating: false,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              title: Text("Search", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 32),
                  const Text("Browse Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildCategoriesGrid(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey.shade400),
          const SizedBox(width: 12),
          Text("Artists, songs, podcasts", style: TextStyle(color: Colors.grey.shade400, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    final categories = [
      {"name": "Pop", "color1": Color(0xFF1A237E), "color2": Color(0xFF3949AB)},
      {"name": "Hip-Hop", "color1": Color(0xFF00C853), "color2": Color(0xFF69F0AE)},
      {"name": "R&B", "color1": Color(0xFF311B92), "color2": Color(0xFF673AB7)},
      {"name": "Electronic", "color1": Color(0xFF880E4F), "color2": Color(0xFFE91E63)},
      {"name": "Rock", "color1": Color(0xFF00838F), "color2": Color(0xFF4DD0E1)},
      {"name": "Jazz", "color1": Color(0xFFBF360C), "color2": Color(0xFFFF7043)},
      {"name": "K-Pop", "color1": Color(0xFF673AB7), "color2": Color(0xFF9575CD)},
      {"name": "Latin", "color1": Color(0xFFD500F9), "color2": Color(0xFFEA80FC)},
      {"name": "Classical", "color1": Color(0xFF00796B), "color2": Color(0xFF80CBC4)},
      {"name": "Country", "color1": Color(0xFF795548), "color2": Color(0xFFD7CCC8)},
      {"name": "Podcasts", "color1": Color(0xFFC2185B), "color2": Color(0xFFF48FB1)},
      {"name": "Radio", "color1": Color(0xFF37474F), "color2": Color(0xFFB0BEC5)},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.6,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [categories[index]["color1"] as Color, categories[index]["color2"] as Color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Text(
            categories[index]["name"] as String,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        );
      },
    );
  }
}
