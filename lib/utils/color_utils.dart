import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class ColorUtils {
  static Future<PaletteGenerator> generatePalette(ImageProvider imageProvider) async {
    return await PaletteGenerator.fromImageProvider(
      imageProvider,
      maximumColorCount: 20,
    );
  }

  static Color getDominantColor(PaletteGenerator? palette, Color fallback) {
    return palette?.dominantColor?.color ?? fallback;
  }

  static List<Color> getGradientColors(PaletteGenerator? palette, Color fallback) {
    if (palette == null || palette.colors.isEmpty) {
      return [fallback.withOpacity(0.8), fallback];
    }
    final dominant = palette.dominantColor?.color ?? fallback;
    final vibrant = palette.vibrantColor?.color ?? palette.mutedColor?.color ?? dominant.withOpacity(0.6);
    return [dominant, vibrant];
  }
}
