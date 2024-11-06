import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/song.dart';
import '../services/api_service.dart';
import '../components/song_card.dart';

class SongsScreen extends StatefulWidget {
  @override
  _SongsScreenState createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  final ApiService apiService = ApiService();
  List<Song> songs = [];
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _tempoController = TextEditingController();
  final _timeSignatureController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    songs = await apiService.fetchSongs();
    setState(() {});
  }

  Future<void> _addSong() async {
    final newSong = Song(
      id: DateTime.now().toString(),
      title: _titleController.text,
      artist: _artistController.text,
      tempo: int.parse(_tempoController.text),
      timeSignature: _timeSignatureController.text,
    );
    await apiService.addSong(newSong);
    _titleController.clear();
    _artistController.clear();
    _tempoController.clear();
    _timeSignatureController.clear();
    _loadSongs();
  }

  Future<void> _editSong(Song song) async {
    final editedSong = await showDialog<Song>(
      context: context,
      builder: (BuildContext context) => _buildEditSongDialog(song),
    );

    if (editedSong != null) {
      await apiService.updateSong(editedSong);
      _loadSongs();
    }
  }

  Future<void> _deleteSong(Song song) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Delete Song'),
        content: Text('Are you sure you want to delete "${song.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await apiService.deleteSong(song.id);
      _loadSongs();
    }
  }

  Widget _buildEditSongDialog(Song song) {
    final _editTitleController = TextEditingController(text: song.title);
    final _editArtistController = TextEditingController(text: song.artist);
    final _editTempoController =
        TextEditingController(text: song.tempo.toString());
    final _editTimeSignatureController =
        TextEditingController(text: song.timeSignature);

    return AlertDialog(
      title: Text('Edit Song'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _editTitleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _editArtistController,
              decoration: InputDecoration(labelText: 'Artist'),
            ),
            TextField(
              controller: _editTempoController,
              decoration: InputDecoration(labelText: 'Tempo (BPM)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _editTimeSignatureController,
              decoration: InputDecoration(labelText: 'Time Signature'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final editedSong = Song(
              id: song.id,
              title: _editTitleController.text,
              artist: _editArtistController.text,
              tempo: int.parse(_editTempoController.text),
              timeSignature: _editTimeSignatureController.text,
            );
            Navigator.of(context).pop(editedSong);
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Wrap the Column in a SingleChildScrollView
      child: Column(
        children: [
          // ListView.builder should be wrapped in a Container to avoid overflow
          Container(
            height:
                MediaQuery.of(context).size.height * 0.6, // Set a fixed height
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                return SongCard(
                  song: songs[index],
                  onEdit: () => _editSong(songs[index]),
                  onDelete: () => _deleteSong(songs[index]),
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
                  decoration: InputDecoration(labelText: 'Song Title'),
                ),
                TextField(
                  controller: _artistController,
                  decoration: InputDecoration(labelText: 'Artist'),
                ),
                TextField(
                  controller: _tempoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Tempo (BPM)'),
                ),
                TextField(
                  controller: _timeSignatureController,
                  decoration: InputDecoration(labelText: 'Time Signature'),
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
