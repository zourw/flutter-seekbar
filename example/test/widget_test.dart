import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seekbar/seekbar.dart';
import 'package:seekbar_example/main.dart';

void main() {
  testWidgets('example app renders validation controls', (tester) async {
    await tester.pumpWidget(const SeekBarExampleApp());

    expect(find.byType(SeekBar), findsOneWidget);
    expect(find.byType(AdvancedSeekBar), findsAtLeastNWidgets(1));
    expect(find.text('SeekBar Example'), findsOneWidget);
    expect(find.text('Legacy SeekBar'), findsOneWidget);
    expect(find.text('AdvancedSeekBar Continuous'), findsOneWidget);
    expect(find.text('Primary Value'), findsOneWidget);
    expect(find.text('Secondary Value'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('AdvancedSeekBar Callback Inspector'),
      250,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();

    expect(find.text('AdvancedSeekBar Callback Inspector'), findsOneWidget);
    expect(find.text('state: idle'), findsOneWidget);
    expect(find.text('fromUser: false'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('AdvancedSeekBar Discrete'),
      250,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();

    expect(find.text('AdvancedSeekBar Discrete'), findsOneWidget);
    expect(find.text('Only Thumb Draggable'), findsOneWidget);
    expect(find.text('RTL'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('AdvancedSeekBar Hidden Params'),
      250,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();

    expect(find.text('AdvancedSeekBar Hidden Params'), findsOneWidget);
    expect(find.text('Seek Smoothly'), findsOneWidget);
    expect(find.text('Thumb Adjust Auto'), findsOneWidget);
    expect(find.text('User Seekable'), findsAtLeastNWidgets(1));
    expect(find.text('Hide End Ticks'), findsOneWidget);
    expect(find.text('Hide Swept Ticks'), findsOneWidget);
    expect(find.text('Bubble Indicator'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Reset'),
      200,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reset'), findsOneWidget);
  });
}
