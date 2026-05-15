import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../providers/player_provider.dart';
import '../widgets/artwork_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final musicProvider = context.watch<MusicProvider>();
    final theme = Theme.of(context);

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
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Text(
                    "Raj",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 24, top: 12),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFE3F2FD),
                  child: const Text(
                    "R", 
                    style: TextStyle(color: Color(0xFF2196F3), fontWeight: FontWeight.bold, fontSize: 16)
                  ),
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
                  const SizedBox(height: 8),
                  _buildFeaturedCard(context),
                  const SizedBox(height: 40),
                  _buildSectionHeader("Recently Played"),
                  _buildRecentlyPlayed(musicProvider),
                  const SizedBox(height: 40),
                  _buildSectionHeader("Top Picks for You"),
                  _buildTopPicks(musicProvider, context),
                  const SizedBox(height: 40),
                  _buildSectionHeader("Artists You Love"),
                  _buildArtists(musicProvider),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.music_note_rounded, color: Colors.white24, size: 42),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "FEATURED MIX",
                  style: TextStyle(color: Color(0xFF2196F3), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Late Night Drive",
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "31 songs • 2h 14m",
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildButton("Play", const Color(0xFF2196F3), Colors.white),
                    const SizedBox(width: 12),
                    _buildButton("Shuffle", Colors.white.withOpacity(0.1), Colors.white),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButton(String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(text, style: TextStyle(color: textCol, fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
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
                const SizedBox(height: 10),
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
      children: songs.map((song) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: ArtworkWidget(id: song.id, type: ArtworkType.AUDIO, size: 52, borderRadius: 14),
        title: Text(song.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(
          song.artist ?? "Unknown", 
          style: TextStyle(color: Colors.grey.shade500, fontSize: 14, fontWeight: FontWeight.w500)
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("2:58", style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
            const SizedBox(width: 12),
            Icon(Icons.more_horiz_rounded, color: Colors.grey.shade300),
          ],
        ),
        onTap: () => context.read<PlayerProvider>().playSong(musicProvider.songs, musicProvider.songs.indexOf(song)),
      )).toList(),
    );
  }

  Widget _buildArtists(MusicProvider musicProvider) {
    if (musicProvider.artists.isEmpty) return const SizedBox(height: 120);
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: musicProvider.artists.length,
        itemBuilder: (context, index) {
          final artist = musicProvider.artists[index];
          return Container(
            width: 84,
            margin: const EdgeInsets.only(right: 24),
            child: Column(
              children: [
                ArtworkWidget(id: artist.id, type: ArtworkType.ARTIST, size: 84, borderRadius: 42),
                const SizedBox(height: 10),
                Text(
                  artist.artist, 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis, 
                  textAlign: TextAlign.center, 
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
