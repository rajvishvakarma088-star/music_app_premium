import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

class PlayerProvider extends ChangeNotifier {
  AudioPlayer? _player;
  List<SongModel> _queue = [];
  int _currentIndex = -1;
  
  AudioPlayer get player {
    if (_player == null) {
      _player = AudioPlayer();
      _init();
    }
    return _player!;
  }
  
  List<SongModel> get queue => _queue;
  int get currentIndex => _currentIndex;
  SongModel? get currentSong => _currentIndex != -1 && _currentIndex < _queue.length ? _queue[_currentIndex] : null;

  PlayerProvider() {
    // Player will be initialized lazily when accessed
  }

  void _init() {
    if (_player == null) return;
    
    _player!.currentIndexStream.listen((index) {
      if (index != null) {
        _currentIndex = index;
        notifyListeners();
      }
    });

    _player!.playerStateStream.listen((state) {
      print("DEBUG: Player State: ${state.processingState}, Playing: ${state.playing}");
      notifyListeners();
    });

    _player!.playbackEventStream.listen((event) {
      print("DEBUG: Playback Event: $event");
    }, onError: (e) {
      print("DEBUG: Playback Error: $e");
    });
  }

  Future<void> playSong(List<SongModel> songs, int index) async {
    _queue = songs;
    _currentIndex = index;
    notifyListeners();

    try {
      print("DEBUG: playSong starting for ID: ${songs[index].id}");
      
      final playlist = ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: songs.map((song) {
          // Use Content URI (PixelPlayer pattern)
          final uri = Uri.parse("content://media/external/audio/media/${song.id}");
          
          return AudioSource.uri(
            uri,
            tag: MediaItem(
              id: song.id.toString(),
              album: song.album ?? "Unknown",
              title: song.title,
              artist: song.artist ?? "Unknown",
              artUri: Uri.parse("content://media/external/audio/media/${song.id}/albumart"),
            ),
          );
        }).toList(),
      );

      print("DEBUG: Setting audio source...");
      await player.setAudioSource(playlist, initialIndex: index);
      print("DEBUG: Source set. Playing...");
      await player.play();
      print("DEBUG: Play command successful.");
    } catch (e, stack) {
      print("DEBUG: Error playing song: $e");
      print(stack);
    }
  }

  Future<void> togglePlay() async {
    if (player.playing) {
      await player.pause();
    } else {
      await player.play();
    }
  }

  Future<void> skipNext() async {
    if (player.hasNext) {
      await player.seekToNext();
    }
  }

  Future<void> skipPrevious() async {
    if (player.hasPrevious) {
      await player.seekToPrevious();
    }
  }

  Future<void> seek(Duration position) async {
    await player.seek(position);
  }

  Future<void> setShuffle(bool enabled) async {
    await player.setShuffleModeEnabled(enabled);
    notifyListeners();
  }

  Future<void> setRepeat(LoopMode mode) async {
    await player.setLoopMode(mode);
    notifyListeners();
  }

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        player.positionStream,
        player.bufferedPositionStream,
        player.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}
