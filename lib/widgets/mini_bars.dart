import 'package:flutter/material.dart';

/// Мини-диаграмма из 7 столбиков (пн..вс) со скруглёнными верхушками —
/// как в разделе "Трекер" макета.
class MiniBars extends StatelessWidget {
  final List<double> values; // 0..1, 7 значений
  final Color color;
  final Color track;
  final double height;

  const MiniBars({super.key, required this.values, required this.color, required this.track, this.height = 46});

  static const _labels = ['П', 'В', 'С', 'Ч', 'П', 'С', 'В'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height + 18,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (int i = 0; i < values.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: height,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: values[i].clamp(0.06, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: values[i] >= 1 ? color : color.withOpacity(0.45),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                                bottomLeft: Radius.circular(2),
                                bottomRight: Radius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(_labels[i], textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: track)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
