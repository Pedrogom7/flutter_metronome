// screens/playlist_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/playlist.dart';
import '../services/api_service.dart';
import '../components/song_card.dart';
import '../models/song.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final Playlist playlist;

  PlaylistDetailScreen({required this.playlist});

  @override
  _PlaylistDetailScreenState createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  final ApiService apiService = ApiService();
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _tempoController = TextEditingController();
  final _timeSignatureController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _addSong() async {
    final newSong = Song(
      id: DateTime.now().toString(),
      title: _titleController.text,
      artist: _artistController.text,
      tempo: int.parse(_tempoController.text),
      timeSignature: _timeSignatureController.text,
    );

    // Add song to the playlist
    widget.playlist.songs.add(newSong);
    await apiService
        .updatePlaylist(widget.playlist); // Update playlist on the server
    _titleController.clear();
    _artistController.clear();
    _tempoController.clear();
    _timeSignatureController.clear();
    setState(() {}); // Refresh the UI
  }

  Future<void> _deletePlaylist() async {
    await apiService.deletePlaylist(widget.playlist.id);
    Navigator.pop(context); // Go back to the previous screen
  }

  Future<void> _editPlaylist() async {
    final newName = await showDialog<String>(
      context: context,
      builder: (context) {
        final _editNameController =
            TextEditingController(text: widget.playlist.name);
        return AlertDialog(
          title: Text('Edit Playlist Name'),
          content: TextField(
            controller: _editNameController,
            decoration: InputDecoration(labelText: 'New Playlist Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, _editNameController.text),
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (newName != null && newName.isNotEmpty) {
      setState(() {
        widget.playlist.name = newName; // Update the playlist name
      });
      await apiService
          .updatePlaylist(widget.playlist); // Update playlist on the server
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlist.name),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editPlaylist,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deletePlaylist,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.playlist.songs.length,
              itemBuilder: (context, index) {
                final song = widget.playlist.songs[index];
                return SongCard(
                  song: song,
                  onEdit: () {
                    // Implement edit song functionality
                  },
                  onDelete: () {
                    // Implement delete song functionality
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                      labelText: 'Song Title'), // Correctly use named parameter
                ),
                TextField(
                  controller: _artistController,
                  decoration: InputDecoration(
                      labelText: 'Artist'), // Correctly use named parameter
                ),
                TextField(
                  controller: _tempoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText:
                          'Tempo (BPM)'), // Correctly use named parameter
                ),
                TextField(
                  controller: _timeSignatureController,
                  decoration: InputDecoration(
                      labelText:
                          'Time Signature'), // Correctly use named parameter
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addSong,
                  child: Text('Add Song'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
