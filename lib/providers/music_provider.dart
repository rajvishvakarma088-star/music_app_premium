import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/playlist_model.dart';

class MusicProvider extends ChangeNotifier {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  
  List<SongModel> _songs = [];
  List<AlbumModel> _albums = [];
  List<ArtistModel> _artists = [];
  List<GenreModel> _genres = [];
  List<CustomPlaylistModel> _customPlaylists = [];
  List<int> _favoriteIds = [];
  List<int> _recentIds = [];
  
  bool _isLoading = true;
  String _searchQuery = "";

  List<SongModel> get songs => _songs.where((s) => s.title.toLowerCase().contains(_searchQuery.toLowerCase()) || (s.artist?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)).toList();
  List<AlbumModel> get albums => _albums;
  List<ArtistModel> get artists => _artists;
  List<GenreModel> get genres => _genres;
  List<CustomPlaylistModel> get customPlaylists => _customPlaylists;
  List<int> get favoriteIds => _favoriteIds;
  List<int> get recentIds => _recentIds;
  bool get isLoading => _isLoading;

  MusicProvider() {
    init();
  }

  Future<void> init() async {
    await requestPermissions();
    await loadFavorites();
    await loadRecent();
    await loadCustomPlaylists();
    // Defer library scan to avoid blocking the UI/Service startup
    Future.delayed(const Duration(seconds: 1), () => fetchAll());
  }

  Future<bool> requestPermissions() async {
    if (!kIsWeb) {
      print("DEBUG: Requesting permissions via permission_handler...");
      
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.audio,
      ].request();

      bool storageGranted = statuses[Permission.storage]!.isGranted;
      bool audioGranted = statuses[Permission.audio]!.isGranted;
      
      print("DEBUG: Storage granted: $storageGranted, Audio granted: $audioGranted");

      // fallback to on_audio_query's internal check
      bool queryStatus = await _audioQuery.permissionsStatus();
      if (!queryStatus) {
        queryStatus = await _audioQuery.permissionsRequest();
      }
      
      return storageGranted || audioGranted || queryStatus;
    }
    return true;
  }

  Future<void> fetchAll() async {
    _isLoading = true;
    notifyListeners();
    print("DEBUG: fetchAll starting...");

    try {
      _songs = await _audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
      print("DEBUG: Fetched ${_songs.length} songs");
      _albums = await _audioQuery.queryAlbums();
      print("DEBUG: Fetched ${_albums.length} albums");
      _artists = await _audioQuery.queryArtists();
      print("DEBUG: Fetched ${_artists.length} artists");
      _genres = await _audioQuery.queryGenres();
      print("DEBUG: Fetched ${_genres.length} genres");
    } catch (e) {
      print("DEBUG: Error fetching audio: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Favorites
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favList = prefs.getStringList('favorites') ?? [];
    _favoriteIds = favList.map((e) => int.parse(e)).toList();
    notifyListeners();
  }

  Future<void> toggleFavorite(int id) async {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favoriteIds.map((e) => e.toString()).toList());
    notifyListeners();
  }

  // Recent
  Future<void> loadRecent() async {
    final prefs = await SharedPreferences.getInstance();
    final recentList = prefs.getStringList('recent') ?? [];
    _recentIds = recentList.map((e) => int.parse(e)).toList();
    notifyListeners();
  }

  Future<void> addRecent(int id) async {
    _recentIds.remove(id);
    _recentIds.insert(0, id);
    if (_recentIds.length > 20) _recentIds.removeLast();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recent', _recentIds.map((e) => e.toString()).toList());
    notifyListeners();
  }

  // Custom Playlists
  Future<void> loadCustomPlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    final plList = prefs.getStringList('playlists') ?? [];
    _customPlaylists = plList.map((e) => CustomPlaylistModel.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> createPlaylist(String name) async {
    final newPlaylist = CustomPlaylistModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      songIds: [],
    );
    _customPlaylists.add(newPlaylist);
    await _savePlaylists();
    notifyListeners();
  }

  Future<void> addToPlaylist(String playlistId, int songId) async {
    final index = _customPlaylists.indexWhere((p) => p.id == playlistId);
    if (index != -1) {
      if (!_customPlaylists[index].songIds.contains(songId)) {
        _customPlaylists[index].songIds.add(songId);
        await _savePlaylists();
        notifyListeners();
      }
    }
  }

  Future<void> _savePlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('playlists', _customPlaylists.map((e) => e.toJson()).cast<String>().toList());
  }
}
