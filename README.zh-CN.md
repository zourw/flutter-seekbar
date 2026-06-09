# seekbar

[English README](./README.md)

一个 Flutter seek bar 组件包，提供两套组件：

- `SeekBar`：轻量级基础进度条，支持主进度和缓冲进度
- `AdvancedSeekBar`：增强版进度条，支持 indicator、刻度、离散模式、thumb text 和更丰富的回调

![SeekBar demo](https://raw.githubusercontent.com/zourw/flutter_seekbar/master/doc/images/overview.gif)

## 功能特性

- 兼容 Dart 3
- 保留原始 `SeekBar`，适合简单媒体进度和缓冲进度场景
- `AdvancedSeekBar` 支持：
  - 连续 / 离散进度
  - `min / max / progress` 范围值
  - tick marks 和 tick texts
  - indicator 文案格式化
  - thumb text
  - RTL 布局
  - 更丰富的回调字段
  - `onlyThumbDraggable`、`seekSmoothly`、`userSeekable` 等交互控制参数

## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  seekbar: ^0.1.1
```

然后执行：

```bash
flutter pub get
```

## 导入

```dart
import 'package:seekbar/seekbar.dart';
```

## 基础 `SeekBar`

当你只需要主进度和缓冲进度时，使用 `SeekBar` 即可。

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

当你需要离散刻度、indicator UI 或更复杂的交互行为时，使用 `AdvancedSeekBar`。

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

### `AdvancedSeekBar` 当前支持的能力

- `min`, `max`, `progress`
- `progressValueFloat`
- `ticksCount`, `showTickTexts`, `tickTexts`
- `tickMarkType`, `tickMarksEndsHide`, `tickMarksSweptHide`
- `showThumbText`
- `indicatorType`, `indicatorAlwaysShown`, `indicatorTextFormat`
- `seekSmoothly`, `thumbAdjustAuto`, `userSeekable`, `onlyThumbDraggable`
- `r2l`
- `onChanged`, `onSeeking`, `onStartTrackingTouch`, `onStopTrackingTouch`

## 回调字段

`AdvancedSeekBar` 会在 `onSeeking` 中返回 `AdvancedSeekBarValue`：

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

## 示例应用

仓库自带一个可直接运行的 example，包含：

- legacy `SeekBar`
- continuous `AdvancedSeekBar`
- callback inspector
- `seekSmoothly`、`thumbAdjustAuto`、`userSeekable` 等隐藏交互参数演示

运行方式：

```bash
cd example
flutter run
```

## 当前范围

当前 Flutter 版本已经覆盖了主要的 seek bar 交互能力，但还没有完全对齐 Android `IndicatorSeekBar` 的全部自定义 API。尤其是以下能力尚未实现：

- custom indicator views
- 基于 drawable 的 thumb / tick 资源配置
- 分段轨道颜色 builder

## License

MIT
