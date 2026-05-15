import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../utils/format_utils.dart';
import 'artwork_widget.dart';

class SongTile extends StatelessWidget {
  final SongModel song;
  final VoidCallback onTap;
  final VoidCallback? onMoreTap;
  final bool isPlaying;

  const SongTile({
    Key? key,
    required this.song,
    required this.onTap,
    this.onMoreTap,
    this.isPlaying = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ArtworkWidget(
        id: song.id,
        type: ArtworkType.AUDIO,
        size: 48,
        borderRadius: 8,
      ),
      title: Text(
        song.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isPlaying ? Theme.of(context).primaryColor : null,
        ),
      ),
      subtitle: Text(
        "${song.artist ?? "Unknown"} • ${FormatUtils.formatDuration(Duration(milliseconds: song.duration ?? 0))}",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert, size: 20),
        onPressed: onMoreTap,
      ),
    );
  }
}
