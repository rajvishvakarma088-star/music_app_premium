import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import '../providers/player_provider.dart';
import '../providers/music_provider.dart';
import '../utils/format_utils.dart';
import 'artwork_widget.dart';

class NowPlayingPanel extends StatelessWidget {
  final double panelPosition;

  const NowPlayingPanel({Key? key, required this.panelPosition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();
    final musicProvider = context.read<MusicProvider>();
    final currentSong = playerProvider.currentSong;

    if (currentSong == null) return const SizedBox.shrink();

    final isFavorite = musicProvider.favoriteIds.contains(currentSong.id);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 36),
                const Text(
                  "NOW PLAYING",
                  style: TextStyle(
                    color: Colors.white60, 
                    fontSize: 10, 
                    fontWeight: FontWeight.w800, 
                    letterSpacing: 2.0
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz_rounded, color: Colors.white, size: 28),
                  onPressed: () {},
                ),
              ],
            ),
            const Spacer(flex: 2),
            // Album Art
            Center(
              child: ArtworkWidget(
                id: currentSong.id,
                type: ArtworkType.AUDIO,
                size: MediaQuery.of(context).size.width - 64,
                borderRadius: 28,
              ),
            ),
            const Spacer(flex: 3),
            // Song Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentSong.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white, 
                          fontSize: 28, 
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentSong.artist ?? "Unknown Artist",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5), 
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(
                    Icons.favorite_rounded,
                    color: isFavorite ? Colors.blue.shade600 : Colors.white.withOpacity(0.1),
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Progress Bar
            StreamBuilder<PositionData>(
              stream: playerProvider.positionDataStream,
              builder: (context, snapshot) {
                final data = snapshot.data;
                final position = data?.position ?? Duration.zero;
                final duration = data?.duration ?? Duration.zero;
                
                return Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.white.withOpacity(0.2),
                        thumbColor: Colors.white,
                        trackShape: const RectangularSliderTrackShape(),
                      ),
                      child: Slider(
                        value: position.inMilliseconds.toDouble().clamp(0, duration.inMilliseconds.toDouble()),
                        max: duration.inMilliseconds.toDouble(),
                        onChanged: (v) => playerProvider.seek(Duration(milliseconds: v.toInt())),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(FormatUtils.formatDuration(position), style: const TextStyle(color: Colors.white38, fontSize: 13, fontWeight: FontWeight.w500)),
                          Text("-${FormatUtils.formatDuration(duration - position)}", style: const TextStyle(color: Colors.white38, fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 40),
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.shuffle_rounded, color: Colors.white.withOpacity(0.4), size: 26),
                IconButton(
                  icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 54),
                  onPressed: () => playerProvider.skipPrevious(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                GestureDetector(
                  onTap: () => playerProvider.togglePlay(),
                  child: Container(
                    width: 84,
                    height: 84,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: Icon(
                      playerProvider.player.playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.black,
                      size: 48,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 54),
                  onPressed: () => playerProvider.skipNext(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                Icon(Icons.repeat_rounded, color: Colors.white.withOpacity(0.4), size: 26),
              ],
            ),
            const SizedBox(height: 48),
            // Volume
            Row(
              children: [
                Icon(Icons.volume_mute_rounded, color: Colors.white.withOpacity(0.4), size: 20),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3,
                      thumbShape: SliderComponentShape.noThumb,
                      activeTrackColor: Colors.white.withOpacity(0.6),
                      inactiveTrackColor: Colors.white.withOpacity(0.1),
                    ),
                    child: Slider(
                      value: playerProvider.player.volume,
                      onChanged: (v) => playerProvider.player.setVolume(v),
                    ),
                  ),
                ),
                Icon(Icons.volume_up_rounded, color: Colors.white.withOpacity(0.4), size: 20),
              ],
            ),
            const Spacer(flex: 2),
            // Bottom bar
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.airplay_rounded, color: Colors.white.withOpacity(0.7), size: 22),
                  Text(
                    currentSong.album ?? "Unknown Album",
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  Icon(Icons.playlist_add_rounded, color: Colors.white.withOpacity(0.7), size: 26),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
