import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../providers/player_provider.dart';
import '../widgets/song_tile.dart';

class GenreSongsScreen extends StatelessWidget {
  final GenreModel genre;

  const GenreSongsScreen({Key? key, required this.genre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final musicProvider = context.watch<MusicProvider>();
    final playerProvider = context.read<PlayerProvider>();
    
    // on_audio_query doesn't easily map songs to genres in a simple list, 
    // usually we need to query songs by genre.
    // For now, we'll use a placeholder or filter the existing songs if genre info matches.
    // Actually, on_audio_query has queryAudiosFrom for this.
    
    return Scaffold(
      appBar: AppBar(title: Text(genre.genre)),
      body: FutureBuilder<List<SongModel>>(
        future: OnAudioQuery().queryAudiosFrom(
          AudiosFromType.GENRE_ID,
          genre.id,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final songs = snapshot.data ?? [];
          if (songs.isEmpty) return const Center(child: Text("No songs in this genre"));
          
          return ListView.builder(
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
              );
            },
          );
        },
      ),
    );
  }
}
