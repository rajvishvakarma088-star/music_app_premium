import 'package:flutter/material.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Browse", 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.black, letterSpacing: -1.0)
                  ),
                  Text(
                    "Explore music by mood & genre", 
                    style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500)
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildSectionHeader("New Releases"),
                  _buildNewReleases(),
                  const SizedBox(height: 48),
                  _buildSectionHeader("Genres"),
                  _buildGenresGrid(),
                  const SizedBox(height: 48),
                  _buildSectionHeader("Charts"),
                  _buildChartsList(),
                  const SizedBox(height: 160),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
          const Text(
            "See All", 
            style: TextStyle(color: Color(0xFF2196F3), fontWeight: FontWeight.bold, fontSize: 15)
          ),
        ],
      ),
    );
  }

  Widget _buildNewReleases() {
    final data = [
      {"title": "After Hours", "artist": "The Weeknd • 2020", "colors": [const Color(0xFF00897B), const Color(0xFF4DB6AC)]},
      {"title": "Future Nostalgia", "artist": "Dua Lipa • 2020", "colors": [const Color(0xFF1A237E), const Color(0xFF3949AB)]},
      {"title": "SOUR", "artist": "Olivia Rodrigo • 2021", "colors": [const Color(0xFF1565C0), const Color(0xFF64B5F6)]},
    ];

    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return Container(
            width: 180,
            margin: const EdgeInsets.only(right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: item["colors"] as List<Color>,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item["title"] as String, 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                ),
                Text(
                  item["artist"] as String, 
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 14, fontWeight: FontWeight.w500)
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGenresGrid() {
    final genres = [
      {"name": "Pop", "color": const Color(0xFFF57C00)},
      {"name": "Hip-Hop", "color": const Color(0xFF7E57C2)},
      {"name": "R&B", "color": const Color(0xFF00BFA5)},
      {"name": "Rock", "color": const Color(0xFFC62828)},
      {"name": "Electronic", "color": const Color(0xFF0D47A1)},
      {"name": "Jazz", "color": const Color(0xFF1B5E20)},
      {"name": "Classical", "color": const Color(0xFF7986CB)},
      {"name": "Country", "color": const Color(0xFF455A64)},
      {"name": "Latin", "color": const Color(0xFF2E7D32)},
      {"name": "K-Pop", "color": const Color(0xFF8E24AA)},
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
      itemCount: genres.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: genres[index]["color"] as Color,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          alignment: Alignment.bottomLeft,
          child: Text(
            genres[index]["name"] as String,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        );
      },
    );
  }

  Widget _buildChartsList() {
    final charts = [
      {"name": "Global Top 100", "color": const Color(0xFF1A237E)},
      {"name": "US Hot 100", "color": const Color(0xFF00E676)},
      {"name": "Viral Hits", "color": const Color(0xFF311B92)},
      {"name": "Rising Artists", "color": const Color(0xFFE91E63)},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.08), width: 1.2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        children: List.generate(charts.length, (index) {
          final chart = charts[index];
          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: chart["color"] as Color,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                title: Text(chart["name"] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                subtitle: Text("Updated daily", style: TextStyle(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
              ),
              if (index != charts.length - 1)
                Divider(height: 1, indent: 90, color: Colors.black.withOpacity(0.05)),
            ],
          );
        }),
      ),
    );
  }
}
