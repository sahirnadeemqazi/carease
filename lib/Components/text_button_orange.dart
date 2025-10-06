import 'package:flutter/material.dart';
import 'package:carease/Components/carease_colors.dart';

class TextButtonOrange extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;

  const TextButtonOrange({
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
            colors: [CareaseColors.orangeLight, CareaseColors.orangeDark],
            begin: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: CareaseColors.orangeLight.withOpacity(0.2), // glow color
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
              fontWeight: FontWeight.w300,
              fontSize: 20,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}
