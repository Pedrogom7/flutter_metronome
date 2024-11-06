class MetronomeSettings {
  int tempo;
  String timeSignature; // Exemplo: '4/4', '3/4'

  MetronomeSettings({
    required this.tempo,
    required this.timeSignature,
  });

  Map<String, dynamic> toJson() => {
        'tempo': tempo,
        'timeSignature': timeSignature,
      };

  static MetronomeSettings fromJson(Map<String, dynamic> json) {
    return MetronomeSettings(
      tempo: json['tempo'],
      timeSignature: json['timeSignature'],
    );
  }
}
