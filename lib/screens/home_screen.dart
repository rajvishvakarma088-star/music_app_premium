import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../providers/player_provider.dart';
import '../widgets/artwork_widget.dart';
import '../widgets/animate_in.dart';
import '../widgets/bouncy.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final musicProvider = context.watch<MusicProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFFF9F9F9),
            surfaceTintColor: const Color(0xFFF9F9F9),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "GOOD EVENING",
                    style: TextStyle(
                      fontSize: 10, 
                      fontWeight: FontWeight.w800, 
                      color: Colors.grey.shade500, 
                      letterSpacing: 1.2
                    ),
                  ),
                  const Text(
                    "Raj",
                    style: TextStyle(
                      fontSize: 34, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.black, 
                      letterSpacing: -1.0
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: IconButton(
                  onPressed: () {}, 
                  icon: const Icon(Icons.account_circle_outlined, size: 32, color: Colors.black87)
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  const AnimateIn(child: Bouncy(child: FeaturedCard())),
                  const SizedBox(height: 28),
                  AnimateIn(
                    delay: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader("Recently Played"),
                        _buildRecentlyPlayed(musicProvider),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  AnimateIn(
                    delay: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader("Top Picks for You"),
                        _buildTopPicks(musicProvider, context),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  AnimateIn(
                    delay: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader("Artists You Love"),
                        _buildArtists(musicProvider),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120),
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
          const Text(
            "See All", 
            style: TextStyle(color: Color(0xFF2196F3), fontWeight: FontWeight.bold, fontSize: 14)
          ),
        ],
      ),
    );
  }

  Widget _buildRecentlyPlayed(MusicProvider musicProvider) {
    if (musicProvider.songs.isEmpty) return const SizedBox(height: 160);
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: 5,
        itemBuilder: (context, index) {
          final song = musicProvider.songs[index % musicProvider.songs.length];
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ArtworkWidget(id: song.id, type: ArtworkType.AUDIO, size: 140, borderRadius: 22),
                const SizedBox(height: 8),
                Text(
                  song.title, 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis, 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)
                ),
                Text(
                  song.artist ?? "Unknown", 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis, 
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopPicks(MusicProvider musicProvider, BuildContext context) {
    final songs = musicProvider.songs.take(4).toList();
    return Column(
      children: songs.map<Widget>((song) => Bouncy(
        onTap: () => context.read<PlayerProvider>().playSong(musicProvider.songs, musicProvider.songs.indexOf(song)),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black.withOpacity(0.08), width: 1.2),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: ArtworkWidget(id: song.id, type: ArtworkType.AUDIO, size: 52, borderRadius: 12),
            title: Text(song.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Text(
              song.artist ?? "Unknown", 
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("2:58", style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                const SizedBox(width: 12),
                Icon(Icons.more_horiz_rounded, color: Colors.grey.shade300),
              ],
            ),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildArtists(MusicProvider musicProvider) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            width: 90,
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                  ),
                  child: Center(
                    child: Icon(Icons.person_rounded, color: Colors.grey.shade400, size: 40),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Artist Name", 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FeaturedCard extends StatelessWidget {
  const FeaturedCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E1E1E),
            const Color(0xFF2C2C2E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Abstract Pattern
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF2196F3).withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFE91E63).withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: const Text(
                    "LISTEN NOW", 
                    style: TextStyle(
                      color: Colors.white70, 
                      fontSize: 10, 
                      fontWeight: FontWeight.w900, 
                      letterSpacing: 1.5
                    )
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Discover Weekly", 
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 32, 
                    fontWeight: FontWeight.bold, 
                    letterSpacing: -1.0
                  )
                ),
                const SizedBox(height: 4),
                Text(
                  "A personalized mix of new music\njust for you.", 
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6), 
                    fontSize: 15, 
                    height: 1.3,
                    fontWeight: FontWeight.w500
                  )
                ),
              ],
            ),
          ),
          
          // Small Floating Music Icon
          Positioned(
            top: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.music_note_rounded, color: Colors.white38, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
