import 'package:flutter/material.dart';

enum Tool {
  rectagular(
    Icons.rectangle_outlined,
    'Retângulo',
  ),
  ligature(
    Icons.horizontal_rule,
    'Ligação',
  );

  const Tool(this.icon, this.label);
  final IconData icon;
  final String label;
}

sealed class ChartItem {}
