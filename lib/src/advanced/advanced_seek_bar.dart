import 'package:flutter/material.dart';

import 'advanced_seek_bar_painter.dart';
import 'advanced_seek_bar_types.dart';

export 'advanced_seek_bar_types.dart';

class AdvancedSeekBar extends StatefulWidget {
  const AdvancedSeekBar({
    Key? key,
    this.min = 0,
    this.max = 100,
    this.progress = 0,
    this.progressValueFloat = false,
    this.seekSmoothly = false,
    this.userSeekable = true,
    this.onlyThumbDraggable = false,
    this.thumbAdjustAuto = true,
    this.r2l = false,
    this.ticksCount = 0,
    this.tickTexts,
    this.showTickTexts = false,
    this.tickMarkType = AdvancedSeekBarTickMarkType.none,
    this.tickMarksEndsHide = false,
    this.tickMarksSweptHide = false,
    this.showThumbText = false,
    this.indicatorType = AdvancedSeekBarIndicatorType.roundedRectangle,
    this.indicatorAlwaysShown = false,
    this.indicatorTextFormat,
    this.indicatorColor = const Color(0xFFFF4081),
    this.indicatorTextColor = Colors.white,
    this.indicatorTextSize = 13,
    this.activeTrackColor = const Color(0xFFFF4081),
    this.inactiveTrackColor = const Color(0xFFD7D7D7),
    this.activeTrackHeight = 4,
    this.inactiveTrackHeight = 2,
    this.trackRoundedCorners = true,
    this.thumbColor = const Color(0xFFFF4081),
    this.thumbSize = 14,
    this.tickColor = const Color(0xFFFF4081),
    this.tickSize = 10,
    this.tickTextColor = const Color(0xFFFF4081),
    this.tickTextStyle,
    this.thumbTextColor = const Color(0xFFFF4081),
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.onChanged,
    this.onSeeking,
    this.onStartTrackingTouch,
    this.onStopTrackingTouch,
  }) : super(key: key);

  final double min;
  final double max;
  final double progress;
  final bool progressValueFloat;
  final bool seekSmoothly;
  final bool userSeekable;
  final bool onlyThumbDraggable;
  final bool thumbAdjustAuto;
  final bool r2l;
  final int ticksCount;
  final List<String>? tickTexts;
  final bool showTickTexts;
  final AdvancedSeekBarTickMarkType tickMarkType;
  final bool tickMarksEndsHide;
  final bool tickMarksSweptHide;
  final bool showThumbText;
  final AdvancedSeekBarIndicatorType indicatorType;
  final bool indicatorAlwaysShown;
  final String? indicatorTextFormat;
  final Color indicatorColor;
  final Color indicatorTextColor;
  final double indicatorTextSize;
  final Color activeTrackColor;
  final Color inactiveTrackColor;
  final double activeTrackHeight;
  final double inactiveTrackHeight;
  final bool trackRoundedCorners;
  final Color thumbColor;
  final double thumbSize;
  final Color tickColor;
  final double tickSize;
  final Color tickTextColor;
  final TextStyle? tickTextStyle;
  final Color thumbTextColor;
  final EdgeInsets padding;
  final ValueChanged<double>? onChanged;
  final AdvancedSeekBarValueChanged? onSeeking;
  final VoidCallback? onStartTrackingTouch;
  final VoidCallback? onStopTrackingTouch;

  @override
  State<AdvancedSeekBar> createState() => _AdvancedSeekBarState();
}

class _AdvancedSeekBarState extends State<AdvancedSeekBar> {
  static const double _indicatorVerticalPadding = 12.0;
  static const double _indicatorToThumbTextGap = 6.0;
  static const double _thumbTextToTrackGap = 6.0;
  static const double _tickTextGap = 14.0;
  static const double _thumbTextFontSize = 12.0;

  late double _progress;
  bool _isDragging = false;
  bool _dragAccepted = false;

  bool get _hasTicks => widget.ticksCount > 1;

  double get _progressRange {
    final range = widget.max - widget.min;
    return range == 0 ? 1 : range;
  }

  double get _thumbRadius => widget.thumbSize / 2;

  @override
  void initState() {
    super.initState();
    _progress = _normalizeConfiguredProgress(widget.progress);
  }

  @override
  void didUpdateWidget(covariant AdvancedSeekBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress ||
        oldWidget.min != widget.min ||
        oldWidget.max != widget.max ||
        oldWidget.ticksCount != widget.ticksCount) {
      _progress = _normalizeConfiguredProgress(widget.progress);
    }
  }

  double _normalizeConfiguredProgress(double progress) {
    final clamped = _clampProgress(progress);
    if (_hasTicks && !widget.seekSmoothly) {
      return _progressForTickIndex(_tickIndexForProgress(clamped));
    }
    return clamped;
  }

  double _clampProgress(double progress) {
    final min = widget.min < widget.max ? widget.min : widget.max;
    final max = widget.min > widget.max ? widget.min : widget.max;
    return progress.clamp(min, max).toDouble();
  }

  double _fractionForProgress(double progress) {
    return ((_clampProgress(progress) - widget.min) / _progressRange)
        .clamp(0.0, 1.0)
        .toDouble();
  }

  double _progressForFraction(
    double fraction, {
    required bool fromUser,
    required bool forDragEnd,
  }) {
    final effectiveFraction = fraction.clamp(0.0, 1.0).toDouble();
    var progress = widget.min + (_progressRange * effectiveFraction);
    if (_hasTicks && (!widget.seekSmoothly || (forDragEnd && widget.thumbAdjustAuto))) {
      progress = _progressForTickIndex(_tickIndexForProgress(progress));
    }
    return _clampProgress(progress);
  }

  int _tickIndexForProgress(double progress) {
    if (!_hasTicks) {
      return 0;
    }
    final fraction = _fractionForProgress(progress);
    return (fraction * (widget.ticksCount - 1))
        .round()
        .clamp(0, widget.ticksCount - 1);
  }

  double _progressForTickIndex(int index) {
    if (!_hasTicks) {
      return _clampProgress(widget.min);
    }
    final safeIndex = index.clamp(0, widget.ticksCount - 1);
    return widget.min + (_progressRange / (widget.ticksCount - 1)) * safeIndex;
  }

  List<double> _tickFractions() {
    if (!_hasTicks) {
      return const <double>[];
    }
    return List<double>.generate(
      widget.ticksCount,
      (index) => widget.ticksCount == 1 ? 0 : index / (widget.ticksCount - 1),
    );
  }

  List<String> _effectiveTickTexts() {
    if (!_hasTicks) {
      return const <String>[];
    }
    final custom = widget.tickTexts;
    if (custom != null && custom.length == widget.ticksCount) {
      return custom;
    }
    return List<String>.generate(
      widget.ticksCount,
      (index) => _formatNumericValue(_progressForTickIndex(index)),
    );
  }

  AdvancedSeekBarValue _buildValue(double progress, {required bool fromUser}) {
    final thumbIndex = _tickIndexForProgress(progress);
    final tickTexts = _effectiveTickTexts();
    final tickText = _hasTicks && thumbIndex < tickTexts.length
        ? tickTexts[thumbIndex]
        : null;
    return AdvancedSeekBarValue(
      progress: progress.round(),
      progressDouble: progress,
      fraction: _fractionForProgress(progress),
      fromUser: fromUser,
      thumbIndex: thumbIndex,
      tickText: tickText,
    );
  }

  String _formatNumericValue(double value) {
    if (!widget.progressValueFloat) {
      return value.round().toString();
    }
    final fixed = value.toStringAsFixed(2);
    return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
  }

  String _indicatorText(AdvancedSeekBarValue value) {
    final format = widget.indicatorTextFormat;
    if (format == null || format.isEmpty) {
      return value.tickText ?? _formatNumericValue(value.progressDouble);
    }
    return format
        .replaceAll(
          AdvancedSeekBarFormat.progress,
          _formatNumericValue(value.progressDouble),
        )
        .replaceAll(AdvancedSeekBarFormat.tickText, value.tickText ?? '');
  }

  double _trackStartX(double width) => widget.padding.left + _thumbRadius;

  double _trackEndX(double width) => width - widget.padding.right - _thumbRadius;

  double _trackWidth(double width) =>
      _trackEndX(width) > _trackStartX(width)
          ? _trackEndX(width) - _trackStartX(width)
          : 0;

  double _thumbCenterX(double width, double progress) {
    final fraction = _fractionForProgress(progress);
    final resolvedFraction = widget.r2l ? 1 - fraction : fraction;
    return _trackStartX(width) + _trackWidth(width) * resolvedFraction;
  }

  bool _shouldShowIndicator() {
    return widget.indicatorType != AdvancedSeekBarIndicatorType.none &&
        (widget.indicatorAlwaysShown || _isDragging);
  }

  bool _reserveIndicatorSpace() {
    return widget.indicatorType != AdvancedSeekBarIndicatorType.none;
  }

  double _estimatedTextHeight(double fontSize) => fontSize * 1.2;

  double _indicatorHeight() {
    if (!_reserveIndicatorSpace()) {
      return 0;
    }
    return _estimatedTextHeight(widget.indicatorTextSize) +
        _indicatorVerticalPadding;
  }

  double _thumbTextHeight() {
    if (!widget.showThumbText) {
      return 0;
    }
    return _estimatedTextHeight(_thumbTextFontSize);
  }

  double _indicatorTop() => widget.padding.top;

  double _displayedTrackTop() {
    var top = widget.padding.top;
    if (_reserveIndicatorSpace()) {
      top += _indicatorHeight() + _indicatorToThumbTextGap;
    }
    if (widget.showThumbText) {
      top += _thumbTextHeight() + _thumbTextToTrackGap;
    }
    return top;
  }

  double _thumbTextTop() {
    var top = widget.padding.top;
    if (_reserveIndicatorSpace()) {
      top += _indicatorHeight() + _indicatorToThumbTextGap;
    }
    return top;
  }

  double _trackCenterY() => _displayedTrackTop() + _thumbRadius;

  double _tickTextTop() => _displayedTrackTop() + widget.thumbSize + _tickTextGap;

  double _widgetHeight() {
    final bottom = widget.showTickTexts ? 34.0 : 0.0;
    return _displayedTrackTop() + widget.thumbSize + bottom + widget.padding.bottom;
  }

  Offset _localPosition(Offset globalPosition) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    return box.globalToLocal(globalPosition);
  }

  bool _canStartDrag(Offset localPosition, double width) {
    if (!widget.userSeekable) {
      return false;
    }
    if (!widget.onlyThumbDraggable) {
      return true;
    }
    final thumbX = _thumbCenterX(width, _progress);
    final touchRadius = _maxDouble(24.0, _thumbRadius * 1.8);
    return (localPosition.dx - thumbX).abs() <= touchRadius;
  }

  void _emit(double progress, {required bool fromUser}) {
    final value = _buildValue(progress, fromUser: fromUser);
    widget.onChanged?.call(progress);
    widget.onSeeking?.call(value);
  }

  void _updateFromLocalDx(
    double localDx,
    double width, {
    required bool fromUser,
    required bool forDragEnd,
  }) {
    final trackWidth = _trackWidth(width);
    if (trackWidth <= 0) {
      return;
    }
    final start = _trackStartX(width);
    final clampedDx = localDx.clamp(start, start + trackWidth).toDouble();
    final visualFraction = (clampedDx - start) / trackWidth;
    final logicalFraction = widget.r2l ? 1 - visualFraction : visualFraction;
    final progress = _progressForFraction(
      logicalFraction,
      fromUser: fromUser,
      forDragEnd: forDragEnd,
    );
    if (progress != _progress) {
      setState(() {
        _progress = progress;
      });
      _emit(progress, fromUser: fromUser);
    } else if (fromUser) {
      _emit(progress, fromUser: true);
    }
  }

  Widget _buildIndicator(double width) {
    if (!_shouldShowIndicator()) {
      return const SizedBox.shrink();
    }
    final value = _buildValue(_progress, fromUser: false);
    final text = _indicatorText(value);
    final textStyle = TextStyle(
      color: widget.indicatorTextColor,
      fontSize: widget.indicatorTextSize,
      fontWeight: FontWeight.w600,
    );
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: Directionality.of(context),
    )..layout();
    final bubblePadding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6);
    final bubbleWidth = textPainter.width + bubblePadding.horizontal;
    final left = (_thumbCenterX(width, _progress) - bubbleWidth / 2)
        .clamp(0.0, _maxDouble(0.0, width - bubbleWidth))
        .toDouble();
    final radius = widget.indicatorType == AdvancedSeekBarIndicatorType.rectangle
        ? BorderRadius.zero
        : BorderRadius.circular(
            widget.indicatorType == AdvancedSeekBarIndicatorType.bubble ? 18 : 8,
          );

    return Positioned(
      left: left,
      top: _indicatorTop(),
      child: Container(
        decoration: BoxDecoration(
          color: widget.indicatorColor,
          borderRadius: radius,
        ),
        padding: bubblePadding,
        child: Text(text, style: textStyle),
      ),
    );
  }

  Widget _buildThumbText(double width) {
    if (!widget.showThumbText) {
      return const SizedBox.shrink();
    }
    final text = _formatNumericValue(_progress);
    const style = TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
    final mergedStyle = style.copyWith(color: widget.thumbTextColor);
    final painter = TextPainter(
      text: TextSpan(text: text, style: mergedStyle),
      textDirection: Directionality.of(context),
    )..layout();
    final left = (_thumbCenterX(width, _progress) - painter.width / 2)
        .clamp(0.0, _maxDouble(0.0, width - painter.width))
        .toDouble();
    return Positioned(
      left: left,
      top: _thumbTextTop(),
      child: Text(text, style: mergedStyle),
    );
  }

  List<Widget> _buildTickTexts(double width) {
    if (!widget.showTickTexts || !_hasTicks) {
      return const <Widget>[];
    }
    final texts = _effectiveTickTexts();
    final style = (widget.tickTextStyle ?? const TextStyle(fontSize: 12)).copyWith(
      color: widget.tickTextColor,
    );
    final direction = Directionality.of(context);
    final widgets = <Widget>[];
    final fractions = _tickFractions();
    for (var index = 0; index < texts.length; index++) {
      final text = texts[index];
      final painter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: direction,
      )..layout();
      final x = _trackStartX(width) +
          _trackWidth(width) *
              (widget.r2l ? 1 - fractions[index] : fractions[index]);
      final left = (x - painter.width / 2)
          .clamp(0.0, _maxDouble(0.0, width - painter.width))
          .toDouble();
      widgets.add(
        Positioned(
          left: left,
          top: _tickTextTop(),
          child: Text(text, style: style),
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite ? constraints.maxWidth : 240.0;
        return SizedBox(
          height: _widgetHeight(),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) {
              if (!widget.userSeekable || widget.onlyThumbDraggable) {
                return;
              }
              final local = _localPosition(details.globalPosition);
              _updateFromLocalDx(
                local.dx,
                width,
                fromUser: true,
                forDragEnd: true,
              );
            },
            onHorizontalDragStart: (details) {
              final local = _localPosition(details.globalPosition);
              _dragAccepted = _canStartDrag(local, width);
              if (!_dragAccepted) {
                return;
              }
              setState(() {
                _isDragging = true;
              });
              widget.onStartTrackingTouch?.call();
              _updateFromLocalDx(
                local.dx,
                width,
                fromUser: true,
                forDragEnd: false,
              );
            },
            onHorizontalDragUpdate: (details) {
              if (!_dragAccepted) {
                return;
              }
              final local = _localPosition(details.globalPosition);
              _updateFromLocalDx(
                local.dx,
                width,
                fromUser: true,
                forDragEnd: false,
              );
            },
            onHorizontalDragEnd: (details) {
              if (!_dragAccepted) {
                return;
              }
              if (_hasTicks && widget.thumbAdjustAuto) {
                setState(() {
                  _progress = _progressForTickIndex(_tickIndexForProgress(_progress));
                });
                _emit(_progress, fromUser: true);
              }
              setState(() {
                _isDragging = false;
                _dragAccepted = false;
              });
              widget.onStopTrackingTouch?.call();
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CustomPaint(
                  size: Size(width, _widgetHeight()),
                  painter: AdvancedSeekBarPainter(
                    progress: _progress,
                    progressFraction: _fractionForProgress(_progress),
                    r2l: widget.r2l,
                    min: widget.min,
                    max: widget.max,
                    padding: widget.padding,
                    ticksCount: widget.ticksCount,
                    tickMarkType: widget.tickMarkType,
                    tickMarksEndsHide: widget.tickMarksEndsHide,
                    tickMarksSweptHide: widget.tickMarksSweptHide,
                    activeTrackColor: widget.activeTrackColor,
                    inactiveTrackColor: widget.inactiveTrackColor,
                    activeTrackHeight: widget.activeTrackHeight,
                    inactiveTrackHeight: widget.inactiveTrackHeight,
                    trackRoundedCorners: widget.trackRoundedCorners,
                    thumbColor: widget.thumbColor,
                    thumbSize: widget.thumbSize,
                    tickColor: widget.tickColor,
                    tickSize: widget.tickSize,
                    isDragging: _isDragging,
                    trackCenterY: _trackCenterY(),
                  ),
                ),
                _buildIndicator(width),
                _buildThumbText(width),
                ..._buildTickTexts(width),
              ],
            ),
          ),
        );
      },
    );
  }

  double _maxDouble(double a, double b) => a > b ? a : b;
}
