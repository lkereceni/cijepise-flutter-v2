import 'package:cijepise_flutter_2/config/palette.dart';
import 'package:flutter/material.dart';

late double width;

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback onClick;

  const RoundedButton({
    Key? key,
    required this.text,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: width * .64,
        height: 70,
        child: ElevatedButton(
          onPressed: onClick,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20.0,
              letterSpacing: 1.5,
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: Palette.darkBlue,
            elevation: 0.0,
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
        ),
      ),
    );
  }
}
