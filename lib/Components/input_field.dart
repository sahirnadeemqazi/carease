import 'package:carease/Components/carease_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool onlyNumbers;

  const InputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.onlyNumbers,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: onlyNumbers ? TextInputType.phone : TextInputType.text,
        inputFormatters: onlyNumbers
            ? [FilteringTextInputFormatter.digitsOnly]
            : [],
        decoration: InputDecoration(
          prefix: onlyNumbers ? Text(
            '+92',
            style: TextStyle(
              color: CareaseColors.white,
              fontSize: 14,
            ),
          ) : null,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: CareaseColors.orangeLight,
            fontWeight: FontWeight.w300,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: CareaseColors.purple),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: CareaseColors.purple, width: 2),
          ),
          filled: true,
          fillColor: Colors.transparent,
        ),
        style: const TextStyle(color: CareaseColors.white,fontSize: 14,),
      ),
    );
  }
}
