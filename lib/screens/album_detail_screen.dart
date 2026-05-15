import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../providers/player_provider.dart';
import '../widgets/artwork_widget.dart';
import '../widgets/song_tile.dart';

class AlbumDetailScreen extends StatelessWidget {
  final AlbumModel album;

  const AlbumDetailScreen({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final musicProvider = context.watch<MusicProvider>();
    final playerProvider = context.read<PlayerProvider>();
    
    final albumSongs = musicProvider.songs.where((s) => s.albumId == album.id).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  ArtworkWidget(id: album.id, type: ArtworkType.ALBUM, size: double.infinity, borderRadius: 0),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(album.album, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  Text(album.artist ?? "Unknown Artist", style: const TextStyle(fontSize: 18, color: Colors.white60)),
                  const SizedBox(height: 8),
                  Text("${album.numOfSongs} songs", style: const TextStyle(color: Colors.white38)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => playerProvider.playSong(albumSongs, 0),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text("Play"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            playerProvider.setShuffle(true);
                            playerProvider.playSong(albumSongs, 0);
                          },
                          icon: const Icon(Icons.shuffle),
                          label: const Text("Shuffle"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final song = albumSongs[index];
                return SongTile(
                  song: song,
                  isPlaying: playerProvider.currentSong?.id == song.id,
                  onTap: () {
                    playerProvider.playSong(albumSongs, index);
                    musicProvider.addRecent(song.id);
                  },
                );
              },
              childCount: albumSongs.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
