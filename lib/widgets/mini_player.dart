import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../providers/player_provider.dart';
import '../providers/music_provider.dart';
import 'artwork_widget.dart';

class MiniPlayer extends StatelessWidget {
  final VoidCallback onExpand;

  const MiniPlayer({Key? key, required this.onExpand}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();
    final musicProvider = context.read<MusicProvider>();
    final currentSong = playerProvider.currentSong;

    if (currentSong == null) return const SizedBox.shrink();

    final isFavorite = musicProvider.favoriteIds.contains(currentSong.id);

    return GestureDetector(
      onTap: onExpand,
      child: Container(
        height: 76,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            ArtworkWidget(id: currentSong.id, type: ArtworkType.AUDIO, size: 52, borderRadius: 12),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentSong.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 15,
                      letterSpacing: -0.5
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    currentSong.artist ?? "Unknown",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5), 
                      fontSize: 13,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? const Color(0xFF2196F3) : Colors.white70,
                size: 22,
              ),
              onPressed: () => musicProvider.toggleFavorite(currentSong.id),
            ),
            IconButton(
              icon: Icon(
                playerProvider.player.playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 34,
              ),
              onPressed: () => playerProvider.togglePlay(),
            ),
          ],
        ),
      ),
    );
  }
}
