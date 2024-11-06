class Song {
  final String id;
  final String title;
  final String artist;
  final int tempo; // BPM da música
  final String timeSignature; // Compasso da música

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.tempo,
    required this.timeSignature,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'artist': artist,
        'tempo': tempo,
        'timeSignature': timeSignature,
      };

  static Song fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      tempo: json['tempo'],
      timeSignature: json['timeSignature'],
    );
  }
}
