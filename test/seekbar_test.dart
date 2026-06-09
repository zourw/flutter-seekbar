import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seekbar/seekbar.dart';

void main() {
  testWidgets('SeekBar builds without optional callbacks', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 200,
            child: SeekBar(
              value: 1.5,
              secondValue: -1,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(SeekBar), findsOneWidget);
  });

  testWidgets('SeekBar drag triggers typed callbacks', (tester) async {
    var startCount = 0;
    var stopCount = 0;
    final progressValues = <double>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 200,
              child: SeekBar(
                onStartTrackingTouch: () {
                  startCount++;
                },
                onProgressChanged: (value) {
                  progressValues.add(value);
                },
                onStopTrackingTouch: () {
                  stopCount++;
                },
              ),
            ),
          ),
        ),
      ),
    );

    await tester.drag(find.byType(SeekBar), const Offset(80, 0));
    await tester.pumpAndSettle();

    expect(startCount, 1);
    expect(stopCount, 1);
    expect(progressValues, isNotEmpty);
    expect(progressValues.last, inInclusiveRange(0.0, 1.0));
  });
}
