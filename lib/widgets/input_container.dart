import 'package:cijepise_flutter_2/config/palette.dart';
import 'package:flutter/material.dart';

class InputContainer extends StatelessWidget {
  final String hintText;
  final double width;
  final bool isObscureText;
  final TextEditingController controller;

  const InputContainer({
    Key? key,
    required this.hintText,
    required this.width,
    required this.isObscureText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50.0),
      ),
      width: width,
      height: 50.0,
      child: TextField(
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        obscureText: isObscureText,
        controller: controller,
        style: const TextStyle(color: Palette.darkGrey),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: Palette.lightGrey),
        ),
      ),
    );
  }
}
