import 'package:flutter/material.dart';
import '../components/metronome_widget.dart';
import '../screens/songs_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tempo = 120; // Default tempo
  String timeSignature = '4/4';

  void _handleTempoChange(int newTempo) {
    setState(() {
      tempo = newTempo; // Update the tempo
    });
  }

  void _navigateToSongsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SongsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Metronome'),
        actions: [
          IconButton(
            icon: Icon(Icons.music_note),
            onPressed: () => _navigateToSongsScreen(context),
          ),
        ],
      ),
      body: Center(
        child: MetronomeWidget(
          initialTempo: tempo,
          initialTimeSignature: timeSignature,
          onTempoChange: _handleTempoChange,
          onTimeSignatureChange: (newTimeSignature) {
            setState(() {
              timeSignature = newTimeSignature;
            });
          },
        ),
      ),
    );
  }
}
