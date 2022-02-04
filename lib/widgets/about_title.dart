import 'package:cijepise_flutter_2/config/palette.dart';
import 'package:flutter/material.dart';

class AboutTitle extends StatelessWidget {
  final String title;

  const AboutTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Palette.darkBlue,
        fontSize: 22.0,
      ),
    );
  }
}
