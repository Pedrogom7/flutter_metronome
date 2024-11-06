import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class MetronomeWidget extends StatefulWidget {
  final int initialTempo;
  final String initialTimeSignature;
  final Function(int) onTempoChange;
  final Function(String) onTimeSignatureChange;

  const MetronomeWidget({
    Key? key,
    required this.initialTempo,
    required this.initialTimeSignature,
    required this.onTempoChange,
    required this.onTimeSignatureChange,
  }) : super(key: key);

  @override
  _MetronomeWidgetState createState() => _MetronomeWidgetState();
}

class _MetronomeWidgetState extends State<MetronomeWidget> {
  // Using multiple audio players for better performance
  late List<AudioPlayer> _regularPlayers;
  late List<AudioPlayer> _accentPlayers;
  Timer? _timer;
  bool _isPlaying = false;
  late int _currentTempo;
  late String _currentTimeSignature;
  int _currentBeat = 0;
  int _currentPlayerIndex = 0;
  final double _minTempo = 30;
  final double _maxTempo = 250;

  // Get beats per bar from time signature
  int get _beatsPerBar => int.parse(_currentTimeSignature.split('/')[0]);

  @override
  void initState() {
    super.initState();
    // Create multiple players for alternating use
    _regularPlayers = List.generate(4, (_) => AudioPlayer());
    _accentPlayers = List.generate(2, (_) => AudioPlayer());
    _currentTempo = widget.initialTempo;
    _currentTimeSignature = widget.initialTimeSignature;
    _loadSounds();
  }

  Future<void> _loadSounds() async {
    try {
      // Load sounds for all players
      for (var player in _regularPlayers) {
        await player.setSource(AssetSource('sounds/click.wav'));
      }
      for (var player in _accentPlayers) {
        await player.setSource(AssetSource('sounds/accent.wav'));
      }
    } catch (e) {
      print('Error loading sounds: $e');
    }
  }

  void _startMetronome() {
    if (_isPlaying) return;

    setState(() {
      _isPlaying = true;
      _currentBeat = 0;
      _currentPlayerIndex = 0;
    });

    // Calculate interval in milliseconds based on tempo
    double interval = 60000 / _currentTempo;

    _timer = Timer.periodic(Duration(milliseconds: interval.round()), (timer) {
      _playBeat();
      setState(() {
        _currentBeat = (_currentBeat + 1) % _beatsPerBar;
        _currentPlayerIndex = (_currentPlayerIndex + 1) % 4;
      });
    });
  }

  void _stopMetronome() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _currentBeat = 0;
    });
  }

  Future<void> _playBeat() async {
    try {
      if (_currentBeat == 0) {
        // Play accent sound on first beat
        final accentPlayer = _accentPlayers[_currentPlayerIndex % 2];
        await accentPlayer.seek(Duration.zero);
        await accentPlayer.resume();
      } else {
        // Play regular click on other beats
        final regularPlayer = _regularPlayers[_currentPlayerIndex];
        await regularPlayer.seek(Duration.zero);
        await regularPlayer.resume();
      }
    } catch (e) {
      print('Error playing beat: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    // Dispose all players
    for (var player in _regularPlayers) {
      player.dispose();
    }
    for (var player in _accentPlayers) {
      player.dispose();
    }
    super.dispose();
  }

  void _updateTempo(int newTempo) {
    setState(() {
      _currentTempo = newTempo.clamp(_minTempo.toInt(), _maxTempo.toInt());
    });
    widget.onTempoChange(_currentTempo);

    // Restart metronome if it's playing to apply new tempo
    if (_isPlaying) {
      _stopMetronome();
      _startMetronome();
    }
  }

  void _incrementTempo() {
    _updateTempo(_currentTempo + 1);
  }

  void _decrementTempo() {
    _updateTempo(_currentTempo - 1);
  }

  void _updateTimeSignature(String newTimeSignature) {
    setState(() {
      _currentTimeSignature = newTimeSignature;
      _currentBeat = 0;
    });
    widget.onTimeSignatureChange(newTimeSignature);

    // Restart metronome if it's playing to apply new time signature
    if (_isPlaying) {
      _stopMetronome();
      _startMetronome();
    }
  }

  Widget _buildTempoControl() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.remove_circle_outline, size: 32),
            onPressed: _decrementTempo,
          ),
          SizedBox(width: 20),
          Text(
            '$_currentTempo BPM',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 20),
          IconButton(
            icon: Icon(Icons.add_circle_outline, size: 32),
            onPressed: _incrementTempo,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSignatureControl() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Text(
            'Time Signature',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          DropdownButton<String>(
            value: _currentTimeSignature,
            items: ['2/4', '3/4', '4/4', '6/8'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(fontSize: 20),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) _updateTimeSignature(newValue);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBeatIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_beatsPerBar, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentBeat == index && _isPlaying
                    ? Colors.blue
                    : Colors.blue.withOpacity(0.3),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPlayButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: _isPlaying ? _stopMetronome : _startMetronome,
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(24),
          backgroundColor: _isPlaying ? Colors.red : Colors.green,
        ),
        child: Icon(
          _isPlaying ? Icons.stop : Icons.play_arrow,
          size: 32,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTempoControl(),
          _buildTimeSignatureControl(),
          _buildBeatIndicator(),
          _buildPlayButton(),
        ],
      ),
    );
  }
}
