import 'dart:convert';

class CustomPlaylistModel {
  final String id;
  final String name;
  final List<int> songIds;

  CustomPlaylistModel({
    required this.id,
    required this.name,
    required this.songIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'songIds': songIds,
    };
  }

  factory CustomPlaylistModel.fromMap(Map<String, dynamic> map) {
    return CustomPlaylistModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      songIds: List<int>.from(map['songIds'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomPlaylistModel.fromJson(String source) => CustomPlaylistModel.fromMap(json.decode(source));
}
