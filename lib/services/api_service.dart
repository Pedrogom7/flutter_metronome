import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song.dart';
import '../models/playlist.dart';

class ApiService {
  final String baseUrl = 'http://localhost:3000';

  Future<List<Song>> fetchSongs() async {
    final response = await http.get(Uri.parse('$baseUrl/songs'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((song) => Song.fromJson(song)).toList();
    } else {
      throw Exception('Failed to load songs');
    }
  }

  Future<void> addSong(Song song) async {
    final response = await http.post(
      Uri.parse('$baseUrl/songs'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(song.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add song');
    }
  }

  Future<List<Playlist>> fetchPlaylists() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/playlists'));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Playlist.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load playlists');
      }
    } catch (e) {
      throw Exception('Error fetching playlists: $e');
    }
  }

  Future<Playlist> addPlaylist(Playlist playlist) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/playlists'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(playlist.toJson()),
      );
      if (response.statusCode == 201) {
        return Playlist.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create playlist');
      }
    } catch (e) {
      throw Exception('Error creating playlist: $e');
    }
  }

  Future<void> updatePlaylist(Playlist playlist) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/playlists/${playlist.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(playlist.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update playlist');
      }
    } catch (e) {
      throw Exception('Error updating playlist: $e');
    }
  }

  Future<void> deletePlaylist(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/playlists/$id'),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete playlist');
      }
    } catch (e) {
      throw Exception('Error deleting playlist: $e');
    }
  }

  Future<void> updateSong(Song song) async {
    final response = await http.put(
      Uri.parse('$baseUrl/songs/${song.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(song.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update song');
    }
  }

  Future<void> deleteSong(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/songs/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete song');
    }
  }
}
