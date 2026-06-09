import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'advanced_seek_bar_types.dart';

class AdvancedSeekBarPainter extends CustomPainter {
  const AdvancedSeekBarPainter({
    required this.progress,
    required this.progressFraction,
    required this.r2l,
    required this.min,
    required this.max,
    required this.padding,
    required this.ticksCount,
    required this.tickMarkType,
    required this.tickMarksEndsHide,
    required this.tickMarksSweptHide,
    required this.activeTrackColor,
    required this.inactiveTrackColor,
    required this.activeTrackHeight,
    required this.inactiveTrackHeight,
    required this.trackRoundedCorners,
    required this.thumbColor,
    required this.thumbSize,
    required this.tickColor,
    required this.tickSize,
    required this.isDragging,
    required this.trackCenterY,
  });

  final double progress;
  final double progressFraction;
  final bool r2l;
  final double min;
  final double max;
  final EdgeInsets padding;
  final int ticksCount;
  final AdvancedSeekBarTickMarkType tickMarkType;
  final bool tickMarksEndsHide;
  final bool tickMarksSweptHide;
  final Color activeTrackColor;
  final Color inactiveTrackColor;
  final double activeTrackHeight;
  final double inactiveTrackHeight;
  final bool trackRoundedCorners;
  final Color thumbColor;
  final double thumbSize;
  final Color tickColor;
  final double tickSize;
  final bool isDragging;
  final double trackCenterY;

  double get _thumbRadius => thumbSize / 2;

  double _trackStartX(Size size) => padding.left + _thumbRadius;

  double _trackEndX(Size size) => size.width - padding.right - _thumbRadius;

  double _trackWidth(Size size) => math.max(0, _trackEndX(size) - _trackStartX(size));

  double _thumbCenterX(Size size) {
    final resolvedFraction = r2l ? 1 - progressFraction : progressFraction;
    return _trackStartX(size) + _trackWidth(size) * resolvedFraction;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final start = _trackStartX(size);
    final end = _trackEndX(size);
    final thumbCenterX = _thumbCenterX(size);
    final backgroundPaint = Paint()
      ..isAntiAlias = true
      ..color = inactiveTrackColor;
    final activePaint = Paint()
      ..isAntiAlias = true
      ..color = activeTrackColor;
    final backgroundRect = Rect.fromLTWH(
      start,
      trackCenterY - inactiveTrackHeight / 2,
      math.max(0, end - start),
      inactiveTrackHeight,
    );
    final activeRect = Rect.fromLTWH(
      math.min(start, thumbCenterX),
      trackCenterY - activeTrackHeight / 2,
      (thumbCenterX - start).abs(),
      activeTrackHeight,
    );
    if (trackRoundedCorners) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          backgroundRect,
          Radius.circular(inactiveTrackHeight / 2),
        ),
        backgroundPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          activeRect,
          Radius.circular(activeTrackHeight / 2),
        ),
        activePaint,
      );
    } else {
      canvas.drawRect(backgroundRect, backgroundPaint);
      canvas.drawRect(activeRect, activePaint);
    }

    _paintTickMarks(canvas, size, thumbCenterX);

    final thumbPaint = Paint()
      ..isAntiAlias = true
      ..color = thumbColor;
    if (isDragging) {
      canvas.drawCircle(
        Offset(thumbCenterX, trackCenterY),
        _thumbRadius * 1.35,
        Paint()
          ..isAntiAlias = true
          ..color = thumbColor.withAlpha(56),
      );
    }
    canvas.drawCircle(Offset(thumbCenterX, trackCenterY), _thumbRadius, thumbPaint);
  }

  void _paintTickMarks(Canvas canvas, Size size, double thumbCenterX) {
    if (ticksCount <= 1 || tickMarkType == AdvancedSeekBarTickMarkType.none) {
      return;
    }
    final paint = Paint()
      ..isAntiAlias = true
      ..color = tickColor
      ..strokeWidth = 1;
    final start = _trackStartX(size);
    final width = _trackWidth(size);
    for (var index = 0; index < ticksCount; index++) {
      if (tickMarksEndsHide && (index == 0 || index == ticksCount - 1)) {
        continue;
      }
      final fraction = ticksCount == 1 ? 0.0 : index / (ticksCount - 1);
      final x = start + width * (r2l ? 1 - fraction : fraction);
      if (tickMarksSweptHide) {
        final swept = r2l ? x >= thumbCenterX : x <= thumbCenterX;
        if (swept) {
          continue;
        }
      }
      switch (tickMarkType) {
        case AdvancedSeekBarTickMarkType.none:
          break;
        case AdvancedSeekBarTickMarkType.oval:
          canvas.drawCircle(Offset(x, trackCenterY), tickSize / 2, paint);
          break;
        case AdvancedSeekBarTickMarkType.square:
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset(x, trackCenterY),
              width: tickSize,
              height: tickSize,
            ),
            paint,
          );
          break;
        case AdvancedSeekBarTickMarkType.divider:
          canvas.drawLine(
            Offset(x, trackCenterY - tickSize / 2),
            Offset(x, trackCenterY + tickSize / 2),
            paint,
          );
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant AdvancedSeekBarPainter old) {
    return progress != old.progress ||
        progressFraction != old.progressFraction ||
        r2l != old.r2l ||
        min != old.min ||
        max != old.max ||
        padding != old.padding ||
        ticksCount != old.ticksCount ||
        tickMarkType != old.tickMarkType ||
        tickMarksEndsHide != old.tickMarksEndsHide ||
        tickMarksSweptHide != old.tickMarksSweptHide ||
        activeTrackColor != old.activeTrackColor ||
        inactiveTrackColor != old.inactiveTrackColor ||
        activeTrackHeight != old.activeTrackHeight ||
        inactiveTrackHeight != old.inactiveTrackHeight ||
        trackRoundedCorners != old.trackRoundedCorners ||
        thumbColor != old.thumbColor ||
        thumbSize != old.thumbSize ||
        tickColor != old.tickColor ||
        tickSize != old.tickSize ||
        isDragging != old.isDragging ||
        trackCenterY != old.trackCenterY;
  }
}
