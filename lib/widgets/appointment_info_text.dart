import 'package:cijepise_flutter_2/config/palette.dart';
import 'package:flutter/material.dart';

class AppointmentInfoText extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const AppointmentInfoText({
    Key? key,
    required this.label,
    required this.value,
    required this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Palette.darkerGrey,
            fontSize: 18.0,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
