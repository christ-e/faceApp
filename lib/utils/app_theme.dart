import 'package:flutter/material.dart';

class AppPrimaryColor {
  static const int _primaryValue = 0xFF2F80ED;
  static const MaterialColor primarySwatch = MaterialColor(_primaryValue, {
    50: Color(0xFFE3F2FD), // Lightest shade
    100: Color(0xFFB3D3FA), // Very light shade
    200: Color(0xFF80B4F6), // Light shade
    300: Color(0xFF4D94F3), // Medium-light shade
    400: Color(0xFF2681F0), // Medium shade
    500: Color(_primaryValue), // Primary color
    600: Color(0xFF2A73D6), // Slightly darker
    700: Color(0xFF2463BF), // Darker shade
    800: Color(0xFF1E53A7), // Dark shade
    900: Color(0xFF153A80), // Darkest shade
  });
}
