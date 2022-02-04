import 'package:cijepise_flutter_2/config/palette.dart';
import 'package:cijepise_flutter_2/services/database.dart';
import 'package:cijepise_flutter_2/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _oibController = TextEditingController();
  final TextEditingController _lozinkaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Palette.lightBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputContainer(
              hintText: 'OIB',
              width: width * 0.5,
              isObscureText: false,
              controller: _oibController,
            ),
            const SizedBox(height: 24.0),
            InputContainer(
              hintText: 'Lozinka',
              width: width * 0.5,
              isObscureText: true,
              controller: _lozinkaController,
            ),
            const SizedBox(height: 48.0),
            RoundedButton(
              text: 'Prijava',
              onClick: () async {
                final SharedPreferences loginPrefs =
                    await SharedPreferences.getInstance();

                if (_oibController.text == '') {
                  Fluttertoast.showToast(
                    msg: 'Morate upisati vaš OIB',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                } else if (_oibController.text.length != 11) {
                  Fluttertoast.showToast(
                    msg: 'OIB ne smije imati više ili manje od 11 brojeva',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                } else if (_oibController.text.contains(RegExp(r'[a-zA-Z]'))) {
                  Fluttertoast.showToast(
                    msg: 'OIB ne smije sadržavati slova',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                } else {
                  Database.getUserLogin(http.Client(), _oibController.text)
                      .then(
                    (user) {
                      if (user == null) {
                        Fluttertoast.showToast(
                          msg: 'Molimo vas da se registrirate',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      } else if (_lozinkaController.text !=
                          user[0]['lozinka']) {
                        Fluttertoast.showToast(
                          msg: 'Upisali ste pogrešnu lozinku',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      } else {
                        Database.getUser(http.Client(), _oibController.text)
                            .then(
                          (result) {
                            loginPrefs.setString('id', result.id);
                            loginPrefs.setString('ime', result.ime);
                            loginPrefs.setString('prezime', result.prezime);
                            loginPrefs.setString('oib', result.oib);
                            loginPrefs.setString('adresa', result.adresa);
                            loginPrefs.setString('grad', result.grad);
                            loginPrefs.setString('lozinka', result.lozinka);
                            loginPrefs.setString('zupanija', result.zupanija);
                            loginPrefs.setString(
                                'datumRodenja', result.datumRodenja);
                          },
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
