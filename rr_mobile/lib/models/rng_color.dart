import 'package:flutter/material.dart';
import 'dart:math' as math;

class RngColor {
  static const List<Color> colors = [
    Color(0xFF1B2631),
    Color(0xFF283747),
    Color(0xFF2E4053),
    Color(0xFF515A5A),
    Color(0xFF6C7A89),
    Color(0xFF76448A),
    Color(0xFF7B7D7D),
    Color(0xFF884EA0),
    Color(0xFF9A7D0A),
    Color(0xFFA93226),
    Color(0xFFAF601A),
    Color(0xFFB9770E),
    Color(0xFFC0392B),
    Color(0xFFC0392B),
    Color(0xFFCB4335),
    Color(0xFFD35400),
    Color(0xFFD98880),
    Color(0xFFE74C3C),
    Color(0xFFE67E22),
  ];

  static Color getColor() {
    math.Random rng = math.Random();
    return colors[rng.nextInt(colors.length)];
  }
}
