import 'dart:core';
import 'package:flutter/material.dart';

final class CareConnectColor extends Color {
  CareConnectColor(super.value);

  static const Color black = Color.fromARGB(255, 0, 0, 0);
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color error = Color.fromARGB(255, 240, 58, 46);

  static const Map<int, Color> primary = <int, Color>{
    50: Color(0xFFFFF5E5),
    100: Color(0xFFFFEACC),
    200: Color(0xFFFFE0B2),
    300: Color(0xFFFFD699),
    400: Color(0xFFFFCC80),
    500: Color(0xFFFFC166),
    600: Color(0xFFFFB74D),
    700: Color(0xFFFFAD33),
    800: Color(0xFFFFA21A),
    900: Color(0xFFFF9800),
  };
  static const Map<int, Color> secondary = <int, Color>{
    50: Color(0xFFFFF1F3),
    100: Color(0xFFFFE4E8),
    200: Color(0xFFFFCCD6),
    300: Color(0xFFFEA3B4),
    400: Color(0xFFFD6F8E),
    500: Color(0xFFF63D68),
    600: Color(0xFFE31B54),
    700: Color(0xFFC01048),
    800: Color(0xFFA11043),
    900: Color(0xFF89123E),
  };
  static const Map<int, Color> neutral = <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFE3E3E3),
    200: Color(0xFFC6C6C6),
    300: Color(0xFFAAAAAA),
    400: Color(0xFF8E8E8E),
    500: Color(0xFF717171),
    600: Color(0xFF555555),
    700: Color(0xFF393939),
    800: Color(0xFF1C1C1C),
    900: Color(0xFF000000),
  };
}
