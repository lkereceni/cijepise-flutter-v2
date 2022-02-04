import 'package:cijepise_flutter_2/config/palette.dart';
import 'package:cijepise_flutter_2/services/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:cijepise_flutter_2/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens.dart';

String? token;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController imeController = TextEditingController(),
      prezimeController = TextEditingController(),
      adresaController = TextEditingController(),
      gradController = TextEditingController(),
      zupanijaController = TextEditingController(),
      oibController = TextEditingController(),
      datumRodenjaController = TextEditingController(),
      lozinkaController = TextEditingController(),
      ponovljenaLozinkaController = TextEditingController();

  String? selectedItemZupanija;
  String? selectedItemGrad;
  String zupanijaQuery = '';

  bool dropdownGradoviDisabled = true;
  bool datePicked = false;

  DateTime selectedDate = DateTime.now();
  final DateFormat formatter = DateFormat('dd.MM.yyyy.');
  final DateFormat databaseFormatter = DateFormat('yyyyMMdd');

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1915, 8),
      lastDate: DateTime(2023),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        datePicked = true;
      });
    }
  }

  Future getPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? obtainedToken = prefs.getString('token');

    setState(
      () {
        token = obtainedToken;
      },
    );
  }

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Palette.lightBlue,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InputContainer(
                    hintText: 'Ime',
                    width: width * 0.4,
                    isObscureText: false,
                    controller: imeController,
                  ),
                  InputContainer(
                    hintText: 'Prezime',
                    width: width * 0.4,
                    isObscureText: false,
                    controller: prezimeController,
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              InputContainer(
                hintText: 'Ulica i kućni broj',
                width: width,
                isObscureText: false,
                controller: adresaController,
              ),
              const SizedBox(height: 24.0),
              FutureBuilder(
                future: Database.getZupanije(http.Client()),
                builder: (context, dynamic snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Palette.darkBlue,
                        strokeWidth: 3.0,
                      ),
                    );
                  } else {
                    return Container(
                      alignment: Alignment.center,
                      width: width,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: DropdownButton(
                          isExpanded: true,
                          hint: const Text(
                            'Županija',
                            style: TextStyle(
                              color: Palette.lightGrey,
                            ),
                          ),
                          icon: const Icon(
                            Icons.expand_more,
                            size: 24.0,
                          ),
                          underline: const SizedBox(),
                          style: const TextStyle(
                            color: Palette.darkGrey,
                            fontSize: 16.0,
                          ),
                          items: snapshot.data
                              .map<DropdownMenuItem<String>>((item) {
                            return DropdownMenuItem<String>(
                              child: Text(item.nazivZupanije),
                              value: item.nazivZupanije,
                            );
                          }).toList(),
                          onChanged: (dynamic newVal) {
                            setState(
                              () {
                                if (selectedItemGrad != null) {
                                  selectedItemGrad = null;
                                }

                                selectedItemZupanija = newVal;
                                zupanijaQuery = newVal;
                                dropdownGradoviDisabled = false;
                              },
                            );
                          },
                          value: selectedItemZupanija,
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 24.0),
              FutureBuilder(
                future: Database.gradoviJson(zupanijaQuery),
                builder: (context, dynamic snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Palette.darkBlue,
                        strokeWidth: 3.0,
                      ),
                    );
                  } else {
                    return Container(
                      alignment: Alignment.center,
                      width: width,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: DropdownButton(
                          isExpanded: true,
                          hint: const Text(
                            'Grad',
                            style: TextStyle(
                              color: Palette.lightGrey,
                            ),
                          ),
                          icon: const Icon(
                            Icons.expand_more,
                            size: 24.0,
                          ),
                          underline: const SizedBox(),
                          style: const TextStyle(
                            color: Palette.darkGrey,
                            fontSize: 16.0,
                          ),
                          items: snapshot.data
                              .map<DropdownMenuItem<String>>((item) {
                            return DropdownMenuItem<String>(
                              child: Text(item['mjesto']),
                              value: item['mjesto'],
                            );
                          }).toList(),
                          onChanged: (dynamic newVal) {
                            setState(() {
                              selectedItemGrad = newVal;
                            });
                          },
                          value: selectedItemGrad,
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InputContainer(
                    hintText: 'OIB',
                    width: width * .4,
                    isObscureText: false,
                    controller: oibController,
                  ),
                  SizedBox(
                    width: width * .4,
                    height: 50.0,
                    child: InkWell(
                      onTap: () {
                        selectDate(context);
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: !datePicked
                            ? const Text(
                                'Datum rođenja',
                                style: TextStyle(
                                  color: Palette.lightGrey,
                                  fontSize: 16.0,
                                ),
                                textAlign: TextAlign.left,
                              )
                            : Text(
                                formatter.format(selectedDate),
                                style: const TextStyle(
                                  color: Palette.darkGrey,
                                  fontSize: 16.0,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InputContainer(
                    hintText: 'Lozinka',
                    width: width * .4,
                    isObscureText: true,
                    controller: lozinkaController,
                  ),
                  InputContainer(
                    hintText: 'Ponovite lozinku',
                    width: width * .4,
                    isObscureText: true,
                    controller: ponovljenaLozinkaController,
                  ),
                ],
              ),
              const SizedBox(height: 48.0),
              RoundedButton(
                text: 'Registracija',
                onClick: () {
                  if (imeController.text == '') {
                    Fluttertoast.showToast(
                      msg: 'Morate upisati vaše ime',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  } else if (imeController.text
                      .contains(RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]'))) {
                    Fluttertoast.showToast(
                      msg:
                          'Ime ne smije sadržavati brojeve ili specijalne znakove',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  } else if (prezimeController.text == '') {
                    Fluttertoast.showToast(
                      msg: 'Morate upisati vaše prezime',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  } else if (prezimeController.text
                      .contains(RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]'))) {
                    Fluttertoast.showToast(
                      msg:
                          'Prezime ne smije sadržavati brojeve ili specijalne znakove',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  } else if (adresaController.text == '') {
                    Fluttertoast.showToast(
                      msg: 'Morate upisati vašu adresu',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  } else if (selectedItemZupanija == null) {
                    Fluttertoast.showToast(
                      msg: 'Morate odabrati vašu županiju',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  } else if (selectedItemGrad == null) {
                    Fluttertoast.showToast(
                      msg: 'Morate odabrati vaš grad',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  } else if (oibController.text == '') {
                    Fluttertoast.showToast(
                      msg: 'Morate upisati vaš OIB',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  } else if (oibController.text.contains(RegExp(r'[a-zA-Z]'))) {
                    Fluttertoast.showToast(
                      msg: 'OIB ne smije sadržavati slova',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  } else if (oibController.text.length != 11) {
                    Fluttertoast.showToast(
                      msg: 'OIB ne smije imati više ili manje od 11 brojeva',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  } else if (lozinkaController.text == '') {
                    Fluttertoast.showToast(
                      msg: 'Morate upisati lozinku',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  } else if (ponovljenaLozinkaController.text == '') {
                    Fluttertoast.showToast(
                      msg: 'Morate ponovno upisati lozinku',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  } else if (ponovljenaLozinkaController.text !=
                      lozinkaController.text) {
                    Fluttertoast.showToast(
                      msg: 'Lozinke nisu iste',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  } else if (oibController.text.isNotEmpty) {
                    Database.getOIB(http.Client()).then(
                      (result) {
                        if (result!.contains(oibController.text)) {
                          Fluttertoast.showToast(
                            msg: 'Korisnik sa ovim OIB-om je već registriran',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                        } else {
                          Database.addUser(
                            imeController.text,
                            prezimeController.text,
                            adresaController.text,
                            selectedItemGrad,
                            selectedItemZupanija,
                            int.parse(oibController.text),
                            int.parse(databaseFormatter.format(selectedDate)),
                            lozinkaController.text,
                            token,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
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
      ),
    );
  }
}
