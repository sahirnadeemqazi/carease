import 'package:flutter/material.dart';

class CareaseColors {
  static const Color blue = Color(0xFF2c5eb6);
  static const Color purple = Color(0xFF7649a1);


  static const Color blueLight = Color(0xFF4d9edb);
  static const Color blueDark = Color(0xFF3f81ca);

  static const Color orangeLight = Color(0xFFe9983f);
  static const Color orangeDark = Color(0xFFe06a38);

  static const Color white = Color(0xFFffffff);
  static const Color grey = Colors.white70;
  static const Color greyDark = Colors.white38;

  // Neutral/backgrounds
  static const Color backgroundLight = Color(0xFF191919);
  static const Color backgroundDark = Color(0xFF1a242d);

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

  static const LinearGradient linearGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      backgroundLight,
      backgroundDark,
    ],
    stops: [
      0.75,
      1.0,
    ],
  );

}