import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class SimpleBarChart extends StatelessWidget {
  const SimpleBarChart({
    super.key,
    required this.values,
    required this.labels,
    this.highlightIndex,
  });

  final List<double> values;
  final List<String> labels;
  final int? highlightIndex;

  @override
  Widget build(BuildContext context) {
    final colors = context.sbColors;
    final maxValue = values.fold<double>(0, (a, b) => a > b ? a : b);
    final scale = maxValue < 1 ? 2.0 : maxValue * 1.3;

    return SizedBox(
      height: 180,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (i) {
          final h = (values[i] / scale) * 140;
          final highlighted = highlightIndex == i;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    height: h.clamp(4, 140),
                    decoration: BoxDecoration(
                      color: highlighted ? colors.accent : colors.primarySoft,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    labels[i],
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
