import 'package:flutter/material.dart';
import '../models/playlist.dart';
import '../services/api_service.dart';
import '../components/playlist_card.dart';

class PlaylistsScreen extends StatefulWidget {
  @override
  _PlaylistsScreenState createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  final ApiService apiService = ApiService();
  List<Playlist> playlists = [];
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    try {
      final loadedPlaylists = await apiService.fetchPlaylists();
      setState(() {
        playlists = loadedPlaylists;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading playlists: $e')),
      );
    }
  }

  Future<void> _showAddPlaylistDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Playlist'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Playlist Name'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _addPlaylist();
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addPlaylist() async {
    try {
      final newPlaylist = Playlist(
        id: DateTime.now().toString(),
        name: _nameController.text,
        description: _descriptionController.text,
      );
      await apiService.addPlaylist(newPlaylist);
      _nameController.clear();
      _descriptionController.clear();
      _loadPlaylists();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding playlist: $e')),
      );
    }
  }

  Future<void> _deletePlaylist(String id) async {
    try {
      await apiService.deletePlaylist(id);
      _loadPlaylists();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting playlist: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playlists'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed:
                _showAddPlaylistDialog, // Show the dialog to add a new playlist
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlists[index];
                return PlaylistCard(
                  playlist: playlist,
                  onTap: () {
                    // Navigate to playlist detail screen
                    // You can implement this later
                  },
                  onDelete: () => _deletePlaylist(playlist.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
