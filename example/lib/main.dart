import 'package:flutter/material.dart';
import 'package:seekbar/seekbar.dart';

void main() {
  runApp(const SeekBarExampleApp());
}

class SeekBarExampleApp extends StatelessWidget {
  const SeekBarExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SeekBar Example',
      theme: ThemeData.dark(),
      home: const SeekBarExamplePage(),
    );
  }
}

class SeekBarExamplePage extends StatefulWidget {
  const SeekBarExamplePage({Key? key}) : super(key: key);

  @override
  State<SeekBarExamplePage> createState() => _SeekBarExamplePageState();
}

class _SeekBarExamplePageState extends State<SeekBarExamplePage> {
  double _legacyValue = 0.35;
  double _legacySecondValue = 0.7;
  bool _legacyTracking = false;
  String _legacyEvent = 'idle';
  double _advancedContinuousValue = 34.6;
  double _advancedCallbackValue = 50;
  double _advancedCallbackChangedValue = 50;
  String _advancedCallbackState = 'idle';
  bool _advancedCallbackFromUser = false;
  int _advancedCallbackThumbIndex = 2;
  String _advancedCallbackTickText = 'Medium';
  double _advancedDiscreteValue = 50;
  bool _advancedR2l = false;
  bool _advancedOnlyThumbDraggable = false;
  bool _advancedSeekSmoothly = false;
  bool _advancedThumbAdjustAuto = true;
  bool _advancedUserSeekable = true;
  bool _advancedHideEndTicks = false;
  bool _advancedHideSweptTicks = false;
  bool _advancedBubbleIndicator = true;
  String _advancedEvent = 'idle';

  void _reset() {
    setState(() {
      _legacyValue = 0.35;
      _legacySecondValue = 0.7;
      _legacyTracking = false;
      _legacyEvent = 'reset';
      _advancedContinuousValue = 34.6;
      _advancedCallbackValue = 50;
      _advancedCallbackChangedValue = 50;
      _advancedCallbackState = 'idle';
      _advancedCallbackFromUser = false;
      _advancedCallbackThumbIndex = 2;
      _advancedCallbackTickText = 'Medium';
      _advancedDiscreteValue = 50;
      _advancedR2l = false;
      _advancedOnlyThumbDraggable = false;
      _advancedSeekSmoothly = false;
      _advancedThumbAdjustAuto = true;
      _advancedUserSeekable = true;
      _advancedHideEndTicks = false;
      _advancedHideSweptTicks = false;
      _advancedBubbleIndicator = true;
      _advancedEvent = 'reset';
    });
  }

  String _formatValue(double value) {
    return value.toStringAsFixed(2);
  }

  Widget _buildCallbackInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text('$label: $value'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SeekBar Example'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _SectionCard(
                title: 'Legacy SeekBar',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 28,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SeekBar(
                            value: _legacyValue,
                            secondValue: _legacySecondValue,
                            progressColor: Colors.lightBlueAccent,
                            secondProgressColor: Colors.lightBlueAccent
                                .withAlpha(89),
                            barColor: Colors.white24,
                            thumbColor: Colors.white,
                            onStartTrackingTouch: () {
                              setState(() {
                                _legacyTracking = true;
                                _legacyEvent = 'drag start';
                              });
                            },
                            onProgressChanged: (value) {
                              setState(() {
                                _legacyValue = value;
                                if (_legacySecondValue < value) {
                                  _legacySecondValue = value;
                                }
                                _legacyEvent =
                                    'drag update ${_formatValue(value)}';
                              });
                            },
                            onStopTrackingTouch: () {
                              setState(() {
                                _legacyTracking = false;
                                _legacyEvent = 'drag end';
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                          Text('tracking: ${_legacyTracking ? 'yes' : 'no'}'),
                          const SizedBox(height: 8),
                          Text('last event: $_legacyEvent'),
                          const SizedBox(height: 8),
                          Text('primary value: ${_formatValue(_legacyValue)}'),
                          const SizedBox(height: 8),
                          Text(
                            'secondary value: ${_formatValue(_legacySecondValue)}',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Primary Value'),
                    Slider(
                      value: _legacyValue,
                      onChanged: (value) {
                        setState(() {
                          _legacyValue = value;
                          if (_legacySecondValue < value) {
                            _legacySecondValue = value;
                          }
                          _legacyEvent =
                              'primary slider ${_formatValue(value)}';
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    const Text('Secondary Value'),
                    Slider(
                      value: _legacySecondValue,
                      onChanged: (value) {
                        setState(() {
                          _legacySecondValue =
                              value < _legacyValue ? _legacyValue : value;
                          _legacyEvent =
                              'secondary slider ${_formatValue(_legacySecondValue)}';
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _SectionCard(
                title: 'AdvancedSeekBar Continuous',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AdvancedSeekBar(
                      min: -20,
                      max: 120,
                      progress: _advancedContinuousValue,
                      progressValueFloat: true,
                      showThumbText: true,
                      indicatorAlwaysShown: true,
                      indicatorType: AdvancedSeekBarIndicatorType.rectangle,
                      indicatorTextFormat:
                          'value ${AdvancedSeekBarFormat.progress}',
                      activeTrackColor: Colors.orangeAccent,
                      thumbColor: Colors.orangeAccent,
                      onSeeking: (value) {
                        setState(() {
                          _advancedContinuousValue = value.progressDouble;
                          _advancedEvent =
                              'continuous ${_formatValue(value.progressDouble)}';
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'continuous value: ${_formatValue(_advancedContinuousValue)}',
                    ),
                    const SizedBox(height: 12),
                    Slider(
                      min: -20,
                      max: 120,
                      value: _advancedContinuousValue,
                      onChanged: (value) {
                        setState(() {
                          _advancedContinuousValue = value;
                          _advancedEvent =
                              'continuous slider ${_formatValue(value)}';
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _SectionCard(
                title: 'AdvancedSeekBar Callback Inspector',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AdvancedSeekBar(
                      min: 0,
                      max: 100,
                      progress: _advancedCallbackValue,
                      progressValueFloat: true,
                      ticksCount: 5,
                      showTickTexts: true,
                      tickTexts: const ['XS', 'S', 'Medium', 'Large', 'XL'],
                      tickMarkType: AdvancedSeekBarTickMarkType.square,
                      showThumbText: true,
                      indicatorType: AdvancedSeekBarIndicatorType.roundedRectangle,
                      indicatorTextFormat:
                          'callback ${AdvancedSeekBarFormat.progress}',
                      activeTrackColor: Colors.tealAccent,
                      thumbColor: Colors.tealAccent,
                      tickColor: Colors.tealAccent,
                      tickTextColor: Colors.white70,
                      onChanged: (value) {
                        setState(() {
                          _advancedCallbackChangedValue = value;
                        });
                      },
                      onStartTrackingTouch: () {
                        setState(() {
                          _advancedCallbackState = 'onStart';
                        });
                      },
                      onSeeking: (value) {
                        setState(() {
                          _advancedCallbackValue = value.progressDouble;
                          _advancedCallbackState = value.fromUser
                              ? 'onSeeking'
                              : 'programmatic';
                          _advancedCallbackFromUser = value.fromUser;
                          _advancedCallbackThumbIndex = value.thumbIndex;
                          _advancedCallbackTickText = value.tickText ?? '-';
                        });
                      },
                      onStopTrackingTouch: () {
                        setState(() {
                          _advancedCallbackState = 'onStop';
                          _advancedCallbackFromUser = false;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildCallbackInfo('state', _advancedCallbackState),
                    _buildCallbackInfo(
                      'progress',
                      _advancedCallbackValue.round().toString(),
                    ),
                    _buildCallbackInfo(
                      'progressDouble',
                      _formatValue(_advancedCallbackValue),
                    ),
                    _buildCallbackInfo(
                      'lastChanged',
                      _formatValue(_advancedCallbackChangedValue),
                    ),
                    _buildCallbackInfo(
                      'fromUser',
                      _advancedCallbackFromUser.toString(),
                    ),
                    _buildCallbackInfo(
                      'thumbIndex',
                      _advancedCallbackThumbIndex.toString(),
                    ),
                    _buildCallbackInfo('tickText', _advancedCallbackTickText),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _SectionCard(
                title: 'AdvancedSeekBar Discrete',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AdvancedSeekBar(
                      min: 0,
                      max: 100,
                      progress: _advancedDiscreteValue,
                      ticksCount: 5,
                      showTickTexts: true,
                      tickTexts: const ['XS', 'S', 'M', 'L', 'XL'],
                      tickMarkType: AdvancedSeekBarTickMarkType.oval,
                      indicatorType:
                          AdvancedSeekBarIndicatorType.roundedRectangle,
                      activeTrackColor: Colors.lightBlueAccent,
                      thumbColor: Colors.white,
                      tickTextColor: Colors.white70,
                      tickColor: Colors.lightBlueAccent,
                      r2l: _advancedR2l,
                      onlyThumbDraggable: _advancedOnlyThumbDraggable,
                      indicatorTextFormat:
                          'size ${AdvancedSeekBarFormat.tickText}',
                      onSeeking: (value) {
                        setState(() {
                          _advancedDiscreteValue = value.progressDouble;
                          _advancedEvent =
                              'discrete idx=${value.thumbIndex} text=${value.tickText}';
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Text('advanced event: $_advancedEvent'),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('RTL'),
                      value: _advancedR2l,
                      onChanged: (value) {
                        setState(() {
                          _advancedR2l = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Only Thumb Draggable'),
                      value: _advancedOnlyThumbDraggable,
                      onChanged: (value) {
                        setState(() {
                          _advancedOnlyThumbDraggable = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _SectionCard(
                title: 'AdvancedSeekBar Hidden Params',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AdvancedSeekBar(
                      min: 0,
                      max: 100,
                      progress: _advancedDiscreteValue,
                      ticksCount: 6,
                      showTickTexts: true,
                      tickTexts: const [
                        '0',
                        '20',
                        '40',
                        '60',
                        '80',
                        '100',
                      ],
                      tickMarkType: AdvancedSeekBarTickMarkType.divider,
                      showThumbText: true,
                      userSeekable: _advancedUserSeekable,
                      seekSmoothly: _advancedSeekSmoothly,
                      thumbAdjustAuto: _advancedThumbAdjustAuto,
                      tickMarksEndsHide: _advancedHideEndTicks,
                      tickMarksSweptHide: _advancedHideSweptTicks,
                      indicatorType: _advancedBubbleIndicator
                          ? AdvancedSeekBarIndicatorType.bubble
                          : AdvancedSeekBarIndicatorType.none,
                      activeTrackColor: Colors.purpleAccent,
                      thumbColor: Colors.purpleAccent,
                      tickColor: Colors.purpleAccent,
                      tickTextColor: Colors.white70,
                      indicatorTextFormat:
                          'value ${AdvancedSeekBarFormat.progress}',
                      onSeeking: (value) {
                        setState(() {
                          _advancedDiscreteValue = value.progressDouble;
                          _advancedEvent =
                              'hidden params ${_formatValue(value.progressDouble)}';
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Text('hidden params event: $_advancedEvent'),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Seek Smoothly'),
                      value: _advancedSeekSmoothly,
                      onChanged: (value) {
                        setState(() {
                          _advancedSeekSmoothly = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Thumb Adjust Auto'),
                      value: _advancedThumbAdjustAuto,
                      onChanged: (value) {
                        setState(() {
                          _advancedThumbAdjustAuto = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('User Seekable'),
                      value: _advancedUserSeekable,
                      onChanged: (value) {
                        setState(() {
                          _advancedUserSeekable = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Hide End Ticks'),
                      value: _advancedHideEndTicks,
                      onChanged: (value) {
                        setState(() {
                          _advancedHideEndTicks = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Hide Swept Ticks'),
                      value: _advancedHideSweptTicks,
                      onChanged: (value) {
                        setState(() {
                          _advancedHideSweptTicks = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Bubble Indicator'),
                      value: _advancedBubbleIndicator,
                      onChanged: (value) {
                        setState(() {
                          _advancedBubbleIndicator = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _reset,
                  child: const Text('Reset'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
