import 'package:cijepise_flutter_2/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppointmentContainerIcon extends StatelessWidget {
  final String iconAsset;
  final String label;

  const AppointmentContainerIcon({
    Key? key,
    required this.iconAsset,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconAsset,
              height: 100.0,
              width: 100.0,
            ),
            const SizedBox(height: 20.0),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Palette.darkGrey,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
