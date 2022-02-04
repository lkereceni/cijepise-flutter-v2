import 'package:cijepise_flutter_2/config/palette.dart';
import 'package:flutter/material.dart';
import 'appointment_container_icon.dart';

class AppointmentContainer extends StatelessWidget {
  final String iconAsset;
  final String label;
  final Object? onTapScreen;

  const AppointmentContainer({
    Key? key,
    required this.iconAsset,
    required this.label,
    this.onTapScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => onTapScreen as Widget,
        ),
      ),
      child: Container(
        height: 220.0,
        width: width,
        decoration: BoxDecoration(
          color: Palette.lightBlue,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: AppointmentContainerIcon(
          iconAsset: iconAsset,
          label: label,
        ),
      ),
    );
  }
}
