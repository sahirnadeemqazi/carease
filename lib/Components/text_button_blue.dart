import 'package:flutter/material.dart';
import 'package:carease/Components/carease_colors.dart';

class TextButtonBlue extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;

  const TextButtonBlue({
    super.key,
    required this.onTap,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        margin: const EdgeInsets.symmetric(horizontal: 15),
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [CareaseColors.blueLight, CareaseColors.blueDark],
            begin: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: CareaseColors.blueLight.withOpacity(0.3), // glow color
              blurRadius: 50,  // spread of the glow
              spreadRadius: 5, // intensity of glow
              offset: const Offset(0, 0), // no shadow offset (glow all around)
            ),
          ],
        ),
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'MyFont',
              fontWeight: FontWeight.normal,
              fontSize: 22,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}
