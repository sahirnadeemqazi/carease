import 'package:flutter/material.dart';

class CareaseColors {
  static const Color blueLight = Color(0xFF19b4f2);
  static const Color blueDark = Color(0xFF166ae5);

  static const Color orangeLight = Color(0xFFfd9f05);
  static const Color orangeDark = Color(0xFFeb7625);

  static const Color white = Color(0xFFf0efef);

  // Neutral/backgrounds
  static const Color backgroundLight = Color(0xFFF9FAFB);
  static const Color backgroundDark = Color(0xFF191919);

  static const RadialGradient radialGradient = RadialGradient(
    center: Alignment.topRight,
    radius: 1.0,
    colors: [
      Color(0xFF19b4f3),
      Color(0xFF166ae5),
      Color(0xFF182a45),
      Color(0xFF121212),
    ],
    stops: [
      0.2,
      0.5,
      0.75,
      1.0,
    ],
  );

}