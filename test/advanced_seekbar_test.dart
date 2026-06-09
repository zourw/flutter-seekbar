import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seekbar/seekbar.dart';

void main() {
  testWidgets('AdvancedSeekBar renders discrete labels and thumb text', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            child: AdvancedSeekBar(
              min: 0,
              max: 100,
              progress: 50,
              ticksCount: 5,
              showTickTexts: true,
              showThumbText: true,
              tickTexts: ['XS', 'S', 'M', 'L', 'XL'],
            ),
          ),
        ),
      ),
    );

    expect(find.byType(AdvancedSeekBar), findsOneWidget);
    expect(find.text('XS'), findsOneWidget);
    expect(find.text('M'), findsOneWidget);
    expect(find.text('XL'), findsOneWidget);
    expect(find.text('50'), findsOneWidget);
  });

  testWidgets('AdvancedSeekBar reports discrete seek params while dragging', (
    tester,
  ) async {
    final events = <AdvancedSeekBarValue>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: AdvancedSeekBar(
                min: 0,
                max: 100,
                progress: 0,
                ticksCount: 5,
                showTickTexts: true,
                tickTexts: const ['0', '25', '50', '75', '100'],
                indicatorType: AdvancedSeekBarIndicatorType.roundedRectangle,
                indicatorAlwaysShown: true,
                indicatorTextFormat: 'value ${AdvancedSeekBarFormat.progress}',
                onSeeking: events.add,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.drag(find.byType(AdvancedSeekBar), const Offset(230, 0));
    await tester.pumpAndSettle();

    expect(events, isNotEmpty);
    expect(events.last.fromUser, isTrue);
    expect(events.last.thumbIndex, inInclusiveRange(0, 4));
    expect(events.last.progress, anyOf(75, 100));
    expect(events.last.tickText, anyOf('75', '100'));
    expect(find.textContaining('value '), findsWidgets);
  });

  testWidgets('AdvancedSeekBar snaps configured discrete progress on init', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            child: AdvancedSeekBar(
              min: 0,
              max: 100,
              progress: 45,
              ticksCount: 5,
              showThumbText: true,
              indicatorType: AdvancedSeekBarIndicatorType.roundedRectangle,
              indicatorAlwaysShown: true,
              indicatorTextFormat: 'value ${AdvancedSeekBarFormat.progress}',
            ),
          ),
        ),
      ),
    );

    expect(find.text('value 50'), findsOneWidget);
  });

  testWidgets('AdvancedSeekBar keeps indicator above thumb text', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            child: AdvancedSeekBar(
              min: 0,
              max: 100,
              progress: 50,
              showThumbText: true,
              indicatorType: AdvancedSeekBarIndicatorType.roundedRectangle,
              indicatorAlwaysShown: true,
              indicatorTextFormat: 'value ${AdvancedSeekBarFormat.progress}',
            ),
          ),
        ),
      ),
    );

    final indicatorRect = tester.getRect(find.text('value 50'));
    final thumbTextRect = tester.getRect(find.text('50'));

    expect(indicatorRect.bottom, lessThan(thumbTextRect.top - 4));
  });
}
