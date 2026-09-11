import 'dart:math';
import 'package:flutter/material.dart';

/// Круговая диаграмма прогресса (0..1) с подписью в процентах по центру —
/// как в макете (цели, трекер).
class ProgressRing extends StatelessWidget {
  final double progress; // 0..1
  final Color color;
  final Color track;
  final double size;
  final double stroke;
  final Widget? center;

  const ProgressRing({
    super.key,
    required this.progress,
    required this.color,
    required this.track,
    this.size = 56,
    this.stroke = 6,
    this.center,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(progress: progress.clamp(0, 1), color: color, track: track, stroke: stroke),
          ),
          center ?? Text('${(progress * 100).round()}%',
              style: TextStyle(fontSize: size * 0.22, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color track;
  final double stroke;
  _RingPainter({required this.progress, required this.color, required this.track, required this.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset(stroke / 2, stroke / 2) & Size(size.width - stroke, size.height - stroke);
    final trackPaint = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, 2 * pi, false, trackPaint);
    canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
