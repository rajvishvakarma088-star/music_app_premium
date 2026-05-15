import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ArtworkWidget extends StatelessWidget {
  final int id;
  final ArtworkType type;
  final double size;
  final double borderRadius;

  const ArtworkWidget({
    Key? key,
    required this.id,
    required this.type,
    this.size = 50,
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: id,
      type: type,
      artworkHeight: size,
      artworkWidth: size,
      artworkBorder: BorderRadius.circular(borderRadius),
      format: ArtworkFormat.JPEG,
      size: size > 200 ? 500 : 200, // Adaptive quality
      artworkFit: BoxFit.cover,
      keepOldArtwork: true, // Optimization: prevents flicker
      nullArtworkWidget: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: LinearGradient(
            colors: [
              Colors.blueGrey.shade800,
              Colors.blueGrey.shade900,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Icon(
          type == ArtworkType.ALBUM ? Icons.album : (type == ArtworkType.ARTIST ? Icons.person : Icons.music_note),
          color: Colors.white24,
          size: size * 0.5,
        ),
      ),
    );
  }
}
