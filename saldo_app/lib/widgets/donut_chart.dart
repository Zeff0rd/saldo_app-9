import 'dart:math';
import 'package:flutter/material.dart';

class DonutSegment {
  final String label;
  final double value;
  final Color color;
  const DonutSegment({required this.label, required this.value, required this.color});
}

/// Кольцевая диаграмма расходов по категориям (сегменты по value),
/// с центральной суммой — как на экране "Аналитика · Обзор".
class DonutChart extends StatelessWidget {
  final List<DonutSegment> segments;
  final Color track;
  final double size;
  final double stroke;
  final Widget? center;

  const DonutChart({
    super.key,
    required this.segments,
    required this.track,
    this.size = 180,
    this.stroke = 20,
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
            painter: _DonutPainter(segments: segments, track: track, stroke: stroke),
          ),
          if (center != null) center!,
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<DonutSegment> segments;
  final Color track;
  final double stroke;
  _DonutPainter({required this.segments, required this.track, required this.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset(stroke / 2, stroke / 2) & Size(size.width - stroke, size.height - stroke);
    final total = segments.fold(0.0, (a, s) => a + s.value);

    final trackPaint = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas.drawArc(rect, 0, 2 * pi, false, trackPaint);

    if (total <= 0) return;
    const gap = 0.035; // небольшой зазор между сегментами (в радианах)
    double start = -pi / 2;
    for (final s in segments) {
      final sweep = (s.value / total) * 2 * pi;
      final paint = Paint()
        ..color = s.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, start + gap / 2, max(sweep - gap, 0.001), false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) => true;
}
