import 'package:flutter/material.dart';

/// SeekBar(
///   value: 0.5,
///   secondValue: 0.8,
///   progressColor: Colors.blue,
///   secondProgressColor: Colors.orange,
///   onStartTrackingTouch: () {
///     print('onStartTrackingTouch');
///   },
///   onProgressChanged: (value) {
///     print('onProgressChanged:$value');
///   },
///   onStopTrackingTouch: () {
///     print('onStopTrackingTouch');
///   },
/// )
class SeekBar extends StatefulWidget {
  final double progressWidth;
  final double thumbRadius;
  final double value;
  final double secondValue;
  final Color barColor;
  final Color progressColor;
  final Color secondProgressColor;
  final Color thumbColor;
  final VoidCallback? onStartTrackingTouch;
  final ValueChanged<double>? onProgressChanged;
  final VoidCallback? onStopTrackingTouch;

  const SeekBar({
    Key? key,
    this.progressWidth = 2.0,
    this.thumbRadius = 7.0,
    this.value = 0.0,
    this.secondValue = 0.0,
    this.barColor = const Color(0x73FFFFFF),
    this.progressColor = Colors.white,
    this.secondProgressColor = const Color(0xBBFFFFFF),
    this.thumbColor = Colors.white,
    this.onStartTrackingTouch,
    this.onProgressChanged,
    this.onStopTrackingTouch,
  }) : super(key: key);

  @override
  _SeekBarState createState() {
    return _SeekBarState();
  }
}

class _SeekBarState extends State<SeekBar> {
  Offset _touchPoint = Offset.zero;

  double _value = 0.0;
  double _secondValue = 0.0;

  bool _touchDown = false;

  double _normalizeValue(double value) {
    return value.clamp(0.0, 1.0).toDouble();
  }

  void _setValue(double width) {
    if (width <= 0) {
      _value = 0.0;
      return;
    }
    _value = _normalizeValue(_touchPoint.dx / width);
  }

  void _checkTouchPoint(double width) {
    if (_touchPoint.dx <= 0) {
      _touchPoint = Offset(0, _touchPoint.dy);
    }
    if (_touchPoint.dx >= width) {
      _touchPoint = Offset(width, _touchPoint.dy);
    }
  }

  bool _updateTouchPoint(Offset globalPosition) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) {
      return false;
    }

    _touchPoint = box.globalToLocal(globalPosition);
    _checkTouchPoint(box.size.width);
    return true;
  }

  @override
  void initState() {
    super.initState();
    _value = _normalizeValue(widget.value);
    _secondValue = _normalizeValue(widget.secondValue);
  }

  @override
  void didUpdateWidget(covariant SeekBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _value = _normalizeValue(widget.value);
    _secondValue = _normalizeValue(widget.secondValue);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragDown: (details) {
        if (!_updateTouchPoint(details.globalPosition)) {
          return;
        }
        final RenderBox box = context.findRenderObject() as RenderBox;
        setState(() {
          _setValue(box.size.width);
          _touchDown = true;
        });
        widget.onStartTrackingTouch?.call();
      },
      onHorizontalDragUpdate: (details) {
        if (!_updateTouchPoint(details.globalPosition)) {
          return;
        }
        final RenderBox box = context.findRenderObject() as RenderBox;
        setState(() {
          _setValue(box.size.width);
        });
        widget.onProgressChanged?.call(_value);
      },
      onHorizontalDragEnd: (details) {
        setState(() {
          _touchDown = false;
        });
        widget.onStopTrackingTouch?.call();
      },
      child: Container(
        constraints: BoxConstraints.expand(height: widget.thumbRadius * 2),
        child: CustomPaint(
          painter: _SeekBarPainter(
            progressWidth: widget.progressWidth,
            thumbRadius: widget.thumbRadius,
            value: _value,
            secondValue: _secondValue,
            barColor: widget.barColor,
            progressColor: widget.progressColor,
            secondProgressColor: widget.secondProgressColor,
            thumbColor: widget.thumbColor,
            touchDown: _touchDown,
          ),
        ),
      ),
    );
  }
}

class _SeekBarPainter extends CustomPainter {
  final double progressWidth;
  final double thumbRadius;
  final double value;
  final double secondValue;
  final Color barColor;
  final Color progressColor;
  final Color secondProgressColor;
  final Color thumbColor;
  final bool touchDown;

  const _SeekBarPainter({
    required this.progressWidth,
    required this.thumbRadius,
    required this.value,
    required this.secondValue,
    required this.barColor,
    required this.progressColor,
    required this.secondProgressColor,
    required this.thumbColor,
    required this.touchDown,
  });

  @override
  bool shouldRepaint(covariant _SeekBarPainter old) {
    return value != old.value ||
        secondValue != old.secondValue ||
        touchDown != old.touchDown ||
        progressWidth != old.progressWidth ||
        thumbRadius != old.thumbRadius ||
        barColor != old.barColor ||
        progressColor != old.progressColor ||
        secondProgressColor != old.secondProgressColor ||
        thumbColor != old.thumbColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.square
      ..strokeWidth = progressWidth;

    final centerY = size.height / 2.0;
    final barLength = size.width - thumbRadius * 2.0;

    final Offset startPoint = Offset(thumbRadius, centerY);
    final Offset endPoint = Offset(size.width - thumbRadius, centerY);
    final Offset progressPoint =
        Offset(barLength * value + thumbRadius, centerY);
    final Offset secondProgressPoint =
        Offset(barLength * secondValue + thumbRadius, centerY);

    paint.color = barColor;
    canvas.drawLine(startPoint, endPoint, paint);

    paint.color = secondProgressColor;
    canvas.drawLine(startPoint, secondProgressPoint, paint);

    paint.color = progressColor;
    canvas.drawLine(startPoint, progressPoint, paint);

    final Paint thumbPaint = Paint()..isAntiAlias = true;

    thumbPaint.color = Colors.transparent;
    canvas.drawCircle(progressPoint, centerY, thumbPaint);

    if (touchDown) {
      thumbPaint.color = thumbColor.withAlpha(153);
      canvas.drawCircle(progressPoint, thumbRadius, thumbPaint);
    }

    thumbPaint.color = thumbColor;
    canvas.drawCircle(progressPoint, thumbRadius * 0.75, thumbPaint);
  }
}
