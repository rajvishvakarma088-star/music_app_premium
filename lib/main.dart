import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'providers/music_provider.dart';
import 'providers/player_provider.dart';
import 'providers/theme_provider.dart';

import 'screens/home_screen.dart';
import 'screens/genres_screen.dart'; // This is now the Browse UI
import 'screens/search_screen.dart';
import 'screens/artists_screen.dart'; // This is now the Library UI
import 'screens/settings_screen.dart';

import 'widgets/mini_player.dart';
import 'widgets/now_playing_panel.dart';

import 'package:audio_session/audio_session.dart';
import 'package:on_audio_query/on_audio_query.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize background service as the very first priority
  try {
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.raj.music.audio',
      androidNotificationChannelName: 'Music',
      androidNotificationOngoing: true,
    );
  } catch (e) {
    debugPrint("JustAudioBackground init error: $e");
  }

  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration.music());

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MusicProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
      ],
      child: const MyApp(),
    ),
  );
  print("DEBUG: main finished");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    
    return MaterialApp(
      title: 'TuneWave',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.themeData,
      home: const MainContainer(),
    );
  }
}



class MainContainer extends StatefulWidget {
  const MainContainer({Key? key}) : super(key: key);

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _currentIndex = 0;
  final PanelController _panelController = PanelController();
  double _panelPosition = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      
      playerProvider.player.currentIndexStream.listen((index) async {
        final currentSong = playerProvider.currentSong;
        if (currentSong != null) {
          final artwork = await OnAudioQuery().queryArtwork(
            currentSong.id,
            ArtworkType.AUDIO,
          );
          if (artwork != null) {
            themeProvider.updateThemeFromImage(MemoryImage(artwork));
          }
        }
      });
    });
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const BrowseScreen(),
    const SearchScreen(),
    const LibraryScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final hasCurrentSong = playerProvider.currentSong != null;
    
    // Update theme from system brightness if in automatic mode
    final brightness = MediaQuery.of(context).platformBrightness;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      themeProvider.updateFromSystem(brightness);
    });

    return Scaffold(
      body: Stack(
        children: [
          Scaffold(
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.02),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCirc)),
                    child: child,
                  ),
                );
              },
              child: _screens[_currentIndex],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: const Color(0xFF2196F3),
              unselectedItemColor: const Color(0xFF8E8E93),
              showUnselectedLabels: true,
              selectedFontSize: 11,
              unselectedFontSize: 11,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
              elevation: 0,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined), 
                  activeIcon: Icon(Icons.home_rounded), 
                  label: "Home"
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.rss_feed_rounded), 
                  label: "Browse"
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search_rounded), 
                  label: "Search"
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart_rounded), 
                  label: "Library"
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined), 
                  activeIcon: Icon(Icons.settings_rounded), 
                  label: "Settings"
                ),
              ],
            ),
          ),
          SlidingUpPanel(
            controller: _panelController,
            minHeight: 0,
            maxHeight: MediaQuery.of(context).size.height,
            parallaxEnabled: true,
            parallaxOffset: 0.5,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            panelBuilder: (sc) => NowPlayingPanel(panelPosition: _panelPosition),
            onPanelSlide: (position) {
              setState(() {
                _panelPosition = position;
              });
            },
            body: const SizedBox.shrink(),
          ),
          if (hasCurrentSong && _panelPosition < 0.1)
            Positioned(
              bottom: kBottomNavigationBarHeight + 32,
              left: 0,
              right: 0,
              child: MiniPlayer(onExpand: () => _panelController.open()),
            ),
        ],
      ),
    );
  }
}
