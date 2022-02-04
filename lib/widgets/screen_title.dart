import 'package:cijepise_flutter_2/config/palette.dart';
import 'package:flutter/material.dart';

class ScreenTitle extends StatelessWidget {
  final String title;

  const ScreenTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Palette.darkGrey,
        fontSize: 24.0,
        //fontWeight: FontWeight.bold,
      ),
    );
  }
}
