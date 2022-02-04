import 'package:cijepise_flutter_2/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CovidInfoContainer extends StatelessWidget {
  final String text;
  final String label;
  final String iconAsset;

  const CovidInfoContainer({
    Key? key,
    required this.text,
    required this.label,
    required this.iconAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      height: 90.0,
      width: width * .42,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
          topRight: Radius.circular(40.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: Palette.darkerGrey,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: Palette.lightGrey,
                  fontWeight: FontWeight.w500,
                  fontSize: 13.0,
                ),
              ),
            ],
          ),
          SvgPicture.asset(
            iconAsset,
            color: Palette.darkerGrey,
            width: 40.0,
            height: 40.0,
          ),
        ],
      ),
    );
  }
}
