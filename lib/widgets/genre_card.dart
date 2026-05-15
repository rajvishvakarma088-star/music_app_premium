import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class GenreCard extends StatelessWidget {
  final GenreModel genre;
  final VoidCallback onTap;

  const GenreCard({Key? key, required this.genre, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate a consistent color based on genre name
    final color = Color((genre.genre.hashCode & 0xFFFFFF) | 0xFF000000);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              genre.genre,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              "${genre.numOfSongs} songs",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
