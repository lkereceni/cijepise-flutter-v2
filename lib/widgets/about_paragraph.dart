import 'package:cijepise_flutter_2/config/palette.dart';
import 'package:flutter/material.dart';

class AboutParagraph extends StatelessWidget {
  final String text;

  const AboutParagraph({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Palette.darkerGrey,
        fontSize: 16.0,
      ),
    );
  }
}
