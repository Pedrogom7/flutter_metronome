import 'package:flutter/material.dart';
import '../models/playlist.dart';

class AddPlaylistDialog extends StatefulWidget {
  final Function(Playlist) onAddPlaylist;

  const AddPlaylistDialog({Key? key, required this.onAddPlaylist})
      : super(key: key);

  @override
  _AddPlaylistDialogState createState() => _AddPlaylistDialogState();
}

class _AddPlaylistDialogState extends State<AddPlaylistDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final newPlaylist = Playlist(
              id: DateTime.now().toString(),
              name: _nameController.text,
              description: _descriptionController.text,
              songs: [],
            );
            widget.onAddPlaylist(newPlaylist);
            Navigator.of(context).pop();
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
