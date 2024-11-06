import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/song.dart';

void main() {
  group('Song', () {
    test('Song should create with correct properties', () {
      final song = Song(
        id: '1',
        title: 'Song 1',
        artist: 'Artist 1',
        tempo: 120,
        timeSignature: '4/4',
      );

      expect(song.id, '1');
      expect(song.title, 'Song 1');
      expect(song.artist, 'Artist 1');
      expect(song.tempo, 120);
      expect(song.timeSignature, '4/4');
    });

    test('Song toJson and fromJson should work correctly', () {
      final song = Song(
        id: '1',
        title: 'Song 1',
        artist: 'Artist 1',
        tempo: 120,
        timeSignature: '4/4',
      );

      final json = song.toJson();
      final newSong = Song.fromJson(json);

      expect(newSong.id, song.id);
      expect(newSong.title, song.title);
      expect(newSong.artist, song.artist);
      expect(newSong.tempo, song.tempo);
      expect(newSong.timeSignature, song.timeSignature);
    });
  });
}
