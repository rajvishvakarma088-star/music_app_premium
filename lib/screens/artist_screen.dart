import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../providers/player_provider.dart';
import '../widgets/artwork_widget.dart';
import '../widgets/song_tile.dart';
import '../widgets/album_card.dart';

class ArtistScreen extends StatelessWidget {
  final ArtistModel artist;

  const ArtistScreen({Key? key, required this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final musicProvider = context.watch<MusicProvider>();
    final playerProvider = context.read<PlayerProvider>();
    
    final artistSongs = musicProvider.songs.where((s) => s.artistId == artist.id).toList();
    final artistAlbums = musicProvider.albums.where((a) => a.artistId == artist.id).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: ArtworkWidget(id: artist.id, type: ArtworkType.ARTIST, size: double.infinity, borderRadius: 0),
              title: Text(artist.artist, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          
          if (artistAlbums.isNotEmpty) ...[
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text("Albums", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: artistAlbums.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 140,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: AlbumCard(
                        album: artistAlbums[index],
                        onTap: () {},
                      ),
                    );
                  },
                ),
              ),
            ),
          ],

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text("Popular Songs", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final song = artistSongs[index];
                return SongTile(
                  song: song,
                  isPlaying: playerProvider.currentSong?.id == song.id,
                  onTap: () {
                    playerProvider.playSong(artistSongs, index);
                    musicProvider.addRecent(song.id);
                  },
                );
              },
              childCount: artistSongs.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
