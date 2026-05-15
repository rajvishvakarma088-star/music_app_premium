import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../providers/player_provider.dart';
import '../widgets/song_tile.dart';
import '../widgets/skeleton_loader.dart';

class SongsScreen extends StatelessWidget {
  const SongsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final musicProvider = context.watch<MusicProvider>();
    final playerProvider = context.read<PlayerProvider>();
    final songs = musicProvider.songs;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Songs"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (v) => musicProvider.setSearchQuery(v),
              decoration: InputDecoration(
                hintText: "Search songs, artists...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // Show sort options
            },
          ),
        ],
      ),
      body: musicProvider.isLoading
          ? const SkeletonLoader()
          : songs.isEmpty
              ? const Center(child: Text("No songs found"))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return SongTile(
                      song: song,
                      isPlaying: playerProvider.currentSong?.id == song.id,
                      onTap: () {
                        playerProvider.playSong(songs, index);
                        musicProvider.addRecent(song.id);
                      },
                      onMoreTap: () {
                        // Show more options (Add to playlist, Share, Info)
                      },
                    );
                  },
                ),
    );
  }
}
