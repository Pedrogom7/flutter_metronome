// models/playlist.dart
import './song.dart';

class Playlist {
  String name; // Now non-final
  final String id;
  final String description;
  final List<Song> songs;
  final DateTime createdAt;

  Playlist({
    required this.id,
    required this.name,
    this.description = '',
    this.songs = const [],
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'songs': songs.map((song) => song.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
      };

  static Playlist fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      songs: (json['songs'] as List?)
              ?.map((songJson) => Song.fromJson(songJson))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
