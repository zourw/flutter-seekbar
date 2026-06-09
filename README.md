# seekbar

[中文文档](./README.zh-CN.md)

A Flutter package that provides two seek bar widgets:

- `SeekBar`: a lightweight progress bar with primary and secondary progress
- `AdvancedSeekBar`: an enhanced seek bar with indicator, ticks, discrete mode, thumb text, and richer callbacks

![SeekBar demo](https://raw.githubusercontent.com/zourw/flutter_seekbar/master/doc/images/overview.gif)

## Features

- Dart 3 compatible
- Legacy `SeekBar` for simple media and buffered progress use cases
- `AdvancedSeekBar` for:
  - continuous or discrete progress
  - min/max value ranges
  - tick marks and tick texts
  - indicator text formatting
  - thumb text
  - RTL layout
  - richer callback payloads
  - interaction controls such as `onlyThumbDraggable`, `seekSmoothly`, and `userSeekable`

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  seekbar: ^0.1.1
```

Then run:

```bash
flutter pub get
```

## Import

```dart
import 'package:seekbar/seekbar.dart';
```

## Basic `SeekBar`

Use `SeekBar` when you only need primary progress and buffered progress.

```dart
class BasicSeekBarDemo extends StatefulWidget {
  const BasicSeekBarDemo({super.key});

  @override
  State<BasicSeekBarDemo> createState() => _BasicSeekBarDemoState();
}

class _BasicSeekBarDemoState extends State<BasicSeekBarDemo> {
  double _value = 0.35;
  double _buffered = 0.70;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black87,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SeekBar(
          value: _value,
          secondValue: _buffered,
          progressColor: Colors.lightBlueAccent,
          secondProgressColor: Colors.lightBlueAccent.withAlpha(89),
          barColor: Colors.white24,
          thumbColor: Colors.white,
          onStartTrackingTouch: () {
            debugPrint('drag start');
          },
          onProgressChanged: (value) {
            setState(() {
              _value = value;
              if (_buffered < value) {
                _buffered = value;
              }
            });
          },
          onStopTrackingTouch: () {
            debugPrint('drag end');
          },
        ),
      ),
    );
  }
}
```

## `AdvancedSeekBar`

Use `AdvancedSeekBar` when you need discrete steps, indicator UI, or richer interaction behavior.

```dart
class AdvancedSeekBarDemo extends StatefulWidget {
  const AdvancedSeekBarDemo({super.key});

  @override
  State<AdvancedSeekBarDemo> createState() => _AdvancedSeekBarDemoState();
}

class _AdvancedSeekBarDemoState extends State<AdvancedSeekBarDemo> {
  double _value = 50;
  String _event = 'idle';

  @override
  Widget build(BuildContext context) {
    return AdvancedSeekBar(
      min: 0,
      max: 100,
      progress: _value,
      ticksCount: 5,
      showTickTexts: true,
      tickTexts: const ['XS', 'S', 'Medium', 'Large', 'XL'],
      tickMarkType: AdvancedSeekBarTickMarkType.square,
      showThumbText: true,
      indicatorType: AdvancedSeekBarIndicatorType.roundedRectangle,
      indicatorAlwaysShown: true,
      indicatorTextFormat: 'size ${AdvancedSeekBarFormat.tickText}',
      onSeeking: (value) {
        setState(() {
          _value = value.progressDouble;
          _event =
              'progress=${value.progressDouble}, index=${value.thumbIndex}, tick=${value.tickText}';
        });
      },
      onStartTrackingTouch: () {
        setState(() {
          _event = 'start';
        });
      },
      onStopTrackingTouch: () {
        setState(() {
          _event = 'stop';
        });
      },
    );
  }
}
```

### Available `AdvancedSeekBar` capabilities

- `min`, `max`, `progress`
- `progressValueFloat`
- `ticksCount`, `showTickTexts`, `tickTexts`
- `tickMarkType`, `tickMarksEndsHide`, `tickMarksSweptHide`
- `showThumbText`
- `indicatorType`, `indicatorAlwaysShown`, `indicatorTextFormat`
- `seekSmoothly`, `thumbAdjustAuto`, `userSeekable`, `onlyThumbDraggable`
- `r2l`
- `onChanged`, `onSeeking`, `onStartTrackingTouch`, `onStopTrackingTouch`

## Callback payload

`AdvancedSeekBar` exposes `AdvancedSeekBarValue` during `onSeeking`:

```dart
AdvancedSeekBar(
  onSeeking: (value) {
    debugPrint('progress: ${value.progress}');
    debugPrint('progressDouble: ${value.progressDouble}');
    debugPrint('fromUser: ${value.fromUser}');
    debugPrint('thumbIndex: ${value.thumbIndex}');
    debugPrint('tickText: ${value.tickText}');
  },
)
```

## Example app

The repository includes a runnable example application that demonstrates:

- legacy `SeekBar`
- continuous `AdvancedSeekBar`
- callback inspection
- hidden interaction parameters such as `seekSmoothly`, `thumbAdjustAuto`, and `userSeekable`

Run it with:

```bash
cd example
flutter run
```

## Current scope

The Flutter port already covers the main seek bar interaction patterns, but it does not yet fully mirror every Android `IndicatorSeekBar` customization API. In particular, custom indicator views, drawable-based thumb/tick assets, and per-section track color builders are not implemented yet.

## License

MIT
