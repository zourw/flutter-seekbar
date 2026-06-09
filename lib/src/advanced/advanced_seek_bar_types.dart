typedef AdvancedSeekBarValueChanged = void Function(AdvancedSeekBarValue value);

enum AdvancedSeekBarIndicatorType {
  none,
  bubble,
  roundedRectangle,
  rectangle,
}

enum AdvancedSeekBarTickMarkType {
  none,
  oval,
  square,
  divider,
}

class AdvancedSeekBarFormat {
  static const String progress = r'${PROGRESS}';
  static const String tickText = r'${TICK_TEXT}';

  const AdvancedSeekBarFormat._();
}

class AdvancedSeekBarValue {
  const AdvancedSeekBarValue({
    required this.progress,
    required this.progressDouble,
    required this.fraction,
    required this.fromUser,
    required this.thumbIndex,
    required this.tickText,
  });

  final int progress;
  final double progressDouble;
  final double fraction;
  final bool fromUser;
  final int thumbIndex;
  final String? tickText;
}
