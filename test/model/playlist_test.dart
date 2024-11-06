import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/playlist.dart';
import '../../lib/models/song.dart';

void main() {
  group('Playlist', () {
    test('Playlist should create with correct properties', () {
      final playlist = Playlist(
        id: '1',
        name: 'My Playlist',
        description: 'A collection of my favorite songs',
      );

      expect(playlist.id, '1');
      expect(playlist.name, 'My Playlist');
      expect(playlist.description, 'A collection of my favorite songs');
      expect(playlist.songs, isEmpty);
    });

    test('Playlist toJson and fromJson should work correctly', () {
      final song = Song(
          id: '1',
          title: 'Song 1',
          artist: 'Artist 1',
          tempo: 120,
          timeSignature: '4/4');
      final playlist = Playlist(
        id: '1',
        name: 'My Playlist',
        description: 'A collection of my favorite songs',
        songs: [song],
      );

      final json = playlist.toJson();
      final newPlaylist = Playlist.fromJson(json);

      expect(newPlaylist.id, playlist.id);
      expect(newPlaylist.name, playlist.name);
      expect(newPlaylist.description, playlist.description);
      expect(newPlaylist.songs.length, 1);
      expect(newPlaylist.songs[0].title, song.title);
    });
  });
}
