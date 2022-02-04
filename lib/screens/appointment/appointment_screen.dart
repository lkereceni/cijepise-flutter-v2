import 'package:cijepise_flutter_2/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:cijepise_flutter_2/widgets/widgets.dart';
import 'package:cijepise_flutter_2/screens/appointment/first_dose_screen.dart';
import 'package:cijepise_flutter_2/screens/appointment/second_dose_screen.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Palette.darkBlue,
            size: 28.0,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Narudžba',
                style: TextStyle(
                  color: Palette.darkerGrey,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const Text(
                'Izaberite vrstu narudžbe',
                style: TextStyle(
                  color: Palette.darkGrey,
                  fontSize: 20.0,
                ),
              ),
              Expanded(
                child: Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10.0,
                    runSpacing: 36.0,
                    children: const [
                      AppointmentContainer(
                        iconAsset: 'assets/icons/syringe_1.svg',
                        label: 'COVID-19 cjepivo (prva doza)',
                        onTapScreen: FirstDoseScreen(),
                      ),
                      AppointmentContainer(
                        iconAsset: 'assets/icons/syringe_2.svg',
                        label: 'COVID-19 cjepivo (druga doza)',
                        onTapScreen: SecondDoseScreen(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
