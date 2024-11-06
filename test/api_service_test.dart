import 'package:flutter_test/flutter_test.dart';
import '../lib/services/api_service.dart';
import '../lib/models/song.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'dart:convert';

// Mock class for http.Client
class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('ApiService', () {
    late ApiService apiService;
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
      apiService =
          ApiService(); // You may want to pass the mockHttpClient to the ApiService
    });

    test('fetchSongs returns a list of Songs when the http call is successful',
        () async {
      // Arrange
      when(mockHttpClient.get(Uri.parse('http://localhost:3000/songs')))
          .thenAnswer((_) async => http.Response(
              '[{"id": "1", "title": "Song 1", "artist": "Artist 1", "tempo": 120, "timeSignature": "4/4"}]',
              200));

      // Act
      final songs = await apiService.fetchSongs();

      // Assert
      expect(songs, isA<List<Song>>());
      expect(songs.length, 1);
      expect(songs[0].title, 'Song 1');
    });

    test('addSong throws an exception when the http call is unsuccessful',
        () async {
      // Arrange
      final song = Song(
          id: '1',
          title: 'Song 1',
          artist: 'Artist 1',
          tempo: 120,
          timeSignature: '4/4');
      when(mockHttpClient.post(Uri.parse('http://localhost:3000/songs'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode(song.toJson())))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // Act & Assert
      expect(() async => await apiService.addSong(song), throwsException);
    });
  });
}
