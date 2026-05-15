import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../providers/music_provider.dart';
import '../providers/player_provider.dart';
import '../models/playlist_model.dart';
import '../widgets/song_tile.dart';
import '../widgets/artwork_widget.dart';

class PlaylistScreen extends StatelessWidget {
  final CustomPlaylistModel playlist;

  const PlaylistScreen({Key? key, required this.playlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final musicProvider = context.watch<MusicProvider>();
    final playerProvider = context.read<PlayerProvider>();
    
    final playlistSongs = musicProvider.songs.where((s) => playlist.songIds.contains(s.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(playlist.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: playlistSongs.isEmpty
          ? const Center(child: Text("No songs in this playlist"))
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: playlistSongs.length,
              itemBuilder: (context, index) {
                final song = playlistSongs[index];
                return SongTile(
                  song: song,
                  isPlaying: playerProvider.currentSong?.id == song.id,
                  onTap: () {
                    playerProvider.playSong(playlistSongs, index);
                    musicProvider.addRecent(song.id);
                  },
                );
              },
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton(
          onPressed: () {
            // Show song picker to add to playlist
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
