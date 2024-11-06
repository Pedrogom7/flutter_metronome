import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/components/metronome_widget.dart';

void main() {
  testWidgets('MetronomeWidget displays initial tempo and increments tempo',
      (WidgetTester tester) async {
    // Arrange
    int tempo = 120;
    String timeSignature = '4/4';

    await tester.pumpWidget(MaterialApp(
      home: MetronomeWidget(
        initialTempo: tempo,
        initialTimeSignature: timeSignature,
        onTempoChange: (newTempo) {
          tempo = newTempo;
        },
        onTimeSignatureChange: (newTimeSignature) {},
      ),
    ));

    // Assert initial state
    expect(find.text('120 BPM'), findsOneWidget);

    // Act
    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();

    // Assert updated state
    expect(find.text('121 BPM'), findsOneWidget);
  });
}
