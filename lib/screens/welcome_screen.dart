import 'package:cijepise_flutter_2/config/palette.dart';
import 'package:cijepise_flutter_2/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'screens.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.lightBlue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SvgPicture.asset(
              'assets/images/welcome_screen_background.svg',
              height: 500.0,
            ),
          ),
          RoundedButton(
            text: 'Prijavi se',
            onClick: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterScreen(),
              ),
            ),
            child: const Text(
              'Registriraj se',
              style: TextStyle(
                color: Palette.darkBlue,
                fontSize: 20.0,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
