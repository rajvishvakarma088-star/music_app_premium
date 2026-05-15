import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import '../utils/color_utils.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;
  bool _isAutomatic = true;
  Color _accentColor = const Color(0xFF0A84FF);
  List<Color> _currentGradient = [const Color(0xFF0D0D0D), const Color(0xFF1A1A1A)];

  bool get isDarkMode => _isDarkMode;
  bool get isAutomatic => _isAutomatic;
  Color get accentColor => _accentColor;
  List<Color> get currentGradient => _currentGradient;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _isAutomatic = false;
    notifyListeners();
  }

  void setAutomatic(bool value) {
    _isAutomatic = value;
    notifyListeners();
  }

  void updateFromSystem(Brightness brightness) {
    if (_isAutomatic) {
      _isDarkMode = brightness == Brightness.dark;
      notifyListeners();
    }
  }

  Future<void> updateThemeFromImage(ImageProvider imageProvider) async {
    try {
      final palette = await ColorUtils.generatePalette(imageProvider);
      _accentColor = palette.vibrantColor?.color ?? palette.dominantColor?.color ?? const Color(0xFF0A84FF);
      _currentGradient = ColorUtils.getGradientColors(palette, _isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF2F2F7));
      notifyListeners();
    } catch (e) {
      debugPrint("Error updating theme from image: $e");
    }
  }

  ThemeData get themeData {
    final base = _isDarkMode ? _darkTheme : _lightTheme;
    return base.copyWith(
      primaryColor: _accentColor,
      colorScheme: base.colorScheme.copyWith(
        primary: _accentColor,
      ),
    );
  }

  final _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF0A84FF),
    scaffoldBackgroundColor: const Color(0xFF0D0D0D),
    cardColor: const Color(0xFF1A1A1A),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF0A84FF),
      secondary: Color(0xFF5AC8FA),
      surface: Color(0xFF1A1A1A),
    ),
  );

  final _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF007AFF),
    scaffoldBackgroundColor: const Color(0xFFF2F2F7),
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF007AFF),
      secondary: Color(0xFF5AC8FA),
      surface: Colors.white,
    ),
  );
}
