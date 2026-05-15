import 'package:flutter/material.dart';
import '../widgets/animate_in.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Color(0xFFF9F9F9),
            surfaceTintColor: Color(0xFFF9F9F9),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              title: Text(
                "Search", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34, color: Colors.black, letterSpacing: -1.0)
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  const AnimateIn(child: SearchBarWidget()),
                  const SizedBox(height: 28),
                  const AnimateIn(
                    delay: 100,
                    child: Text(
                      "Browse Categories", 
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)
                    ),
                  ),
                  const SizedBox(height: 8),
                  const AnimateIn(
                    delay: 200,
                    child: CategoriesGrid(),
                  ),
                  const SizedBox(height: 160),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.08), width: 1.2),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: Colors.grey.shade400, size: 22),
          const SizedBox(width: 12),
          Text(
            "Artists, songs, podcasts", 
            style: TextStyle(color: Colors.grey.shade400, fontSize: 17, fontWeight: FontWeight.w400)
          ),
        ],
      ),
    );
  }
}

class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      {"name": "Pop", "colors": [const Color(0xFF1A237E), const Color(0xFF0D164D)]},
      {"name": "Hip-Hop", "colors": [const Color(0xFF00C853), const Color(0xFF2E7D32)]},
      {"name": "R&B", "colors": [const Color(0xFF311B92), const Color(0xFF1A0A4D)]},
      {"name": "Electronic", "colors": [const Color(0xFFC2185B), const Color(0xFF880E4F)]},
      {"name": "Rock", "colors": [const Color(0xFF0288D1), const Color(0xFF4FC3F7)]},
      {"name": "Jazz", "colors": [const Color(0xFF9E9E9E), const Color(0xFFEF9A9A)]},
      {"name": "K-Pop", "colors": [const Color(0xFF7E57C2), const Color(0xFF5E35B1)]},
      {"name": "Latin", "colors": [const Color(0xFFD500F9), const Color(0xFFAA00FF)]},
      {"name": "Classical", "colors": [const Color(0xFF009688), const Color(0xFF4DB6AC)]},
      {"name": "Country", "colors": [const Color(0xFF795548), const Color(0xFFD84315)]},
      {"name": "Podcasts", "colors": [const Color(0xFFE91E63), const Color(0xFF880E4F)]},
      {"name": "Radio", "colors": [const Color(0xFF0097A7), const Color(0xFFD4E157)]},
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
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: categories[index]["colors"] as List<Color>,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(20),
          alignment: Alignment.bottomLeft,
          child: Text(
            categories[index]["name"] as String,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        );
      },
    );
  }
}
