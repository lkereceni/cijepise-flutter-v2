import 'package:cijepise_flutter_2/config/palette.dart';
import 'package:flutter/material.dart';

class AppointmentInputContainer extends StatelessWidget {
  final String label;
  final double width;
  final TextEditingController controller;

  const AppointmentInputContainer({
    Key? key,
    required this.label,
    required this.width,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            label,
            style: const TextStyle(
              color: Palette.lightGrey,
              fontSize: 14.0,
            ),
          ),
        ),
        const SizedBox(height: 2.0),
        Container(
          decoration: BoxDecoration(
            color: Palette.lightBlue,
            borderRadius: BorderRadius.circular(50.0),
          ),
          width: width,
          height: 50.0,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextField(
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              controller: controller,
              style: const TextStyle(
                color: Palette.darkGrey,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 14.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
