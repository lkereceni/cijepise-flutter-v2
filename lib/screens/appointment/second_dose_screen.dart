import 'package:cijepise_flutter_2/config/palette.dart';
import 'package:cijepise_flutter_2/services/database.dart';
import 'package:cijepise_flutter_2/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cijepise_flutter_2/screens/appointment/data_change_screen.dart';

String? userId;
String userOib = '';
String? userIme;
String? userPrezime;
String? userAdresa;
String? userGrad;
String? userZupanija;
String? userDatumRodenja;

String vaccineType = '';
String vaccinationDate = '';
String vaccinationStatus = '';
String sDatumRodenja = '';
String sDrugaDozaDatum = '';
String vaccineName = '-';

List vaccinationInfo = [];

class SecondDoseScreen extends StatefulWidget {
  const SecondDoseScreen({Key? key}) : super(key: key);

  @override
  _SecondDoseScreenState createState() => _SecondDoseScreenState();
}

class _SecondDoseScreenState extends State<SecondDoseScreen> {
  TextEditingController imeController = TextEditingController(),
      prezimeController = TextEditingController(),
      adresaController = TextEditingController(),
      oibController = TextEditingController(),
      datumRodenjaController = TextEditingController();

  String? selectedItemGrad;
  String selectedItemZupanija = '';

  Future getPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var obtainedId = prefs.getString('id');
    var obtainedOib = prefs.getString('oib');
    var obtainedIme = prefs.getString('ime');
    var obtainedPrezime = prefs.getString('prezime');
    var obtainedAdresa = prefs.getString('adresa');
    var obtainedGrad = prefs.getString('grad');
    var obtainedZupanija = prefs.getString('zupanija');
    var obtainedDatumRodenja = prefs.getString('datumRodenja')!;

    String datumRodenjaGodina = obtainedDatumRodenja.substring(0, 4);
    String datumRodenjaMjesec = obtainedDatumRodenja.substring(4, 6);
    String datumRodenjaDan = obtainedDatumRodenja.substring(6, 8);

    sDatumRodenja = datumRodenjaDan +
        '.' +
        datumRodenjaMjesec +
        '.' +
        datumRodenjaGodina +
        '.';

    setState(
      () {
        userId = obtainedId;
        userOib = obtainedOib!;
        userIme = obtainedIme;
        userPrezime = obtainedPrezime;
        userAdresa = obtainedAdresa;
        userGrad = obtainedGrad;
        userZupanija = obtainedZupanija;
        userDatumRodenja = obtainedDatumRodenja;

        imeController.text = obtainedIme!;
        prezimeController.text = obtainedPrezime!;
        adresaController.text = obtainedAdresa!;
        oibController.text = obtainedOib;

        selectedItemGrad = obtainedGrad;
        selectedItemZupanija = obtainedZupanija!;

        Database.getVaccineName(http.Client(), userOib).then(
          (value) => vaccineName = value,
        );
      },
    );
  }

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
      setState(
        () {
          selectedDate = pickedDate;
          datePicked = true;
          sDatumRodenja = formatter.format(selectedDate);
        },
      );
    }
  }

  Widget getStatus() {
    if (vaccinationStatus == 'na čekanju' ||
        vaccinationStatus == 'Na čekanju') {
      return RoundedButton(
        text: 'Promijeni podatke',
        onClick: () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.clear();
          await Database.getUser(http.Client(), userOib).then((result) {
            prefs.setString('id', result.id);
            prefs.setString('oib', result.oib);
            prefs.setString('ime', result.ime);
            prefs.setString('prezime', result.prezime);
            prefs.setString('adresa', result.adresa);
            prefs.setString('grad', result.grad);
            prefs.setString('zupanija', result.zupanija);
            prefs.setString('datumRodenja', result.datumRodenja);
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DataChangeScreen(),
            ),
          );
        },
      );
    } else if (vaccinationStatus == 'naručen' ||
        vaccinationStatus == 'Naručen') {
      return RoundedButton(
        text: 'Promijeni podatke',
        onClick: () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.clear();
          await Database.getUser(http.Client(), userOib).then(
            (result) {
              prefs.setString('id', result.id);
              prefs.setString('oib', result.oib);
              prefs.setString('ime', result.ime);
              prefs.setString('prezime', result.prezime);
              prefs.setString('adresa', result.adresa);
              prefs.setString('grad', result.grad);
              prefs.setString('zupanija', result.zupanija);
              prefs.setString('datumRodenja', result.datumRodenja);
            },
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DataChangeScreen(),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }

  Color getStatusColor() {
    if (vaccinationStatus == 'na čekanju' ||
        vaccinationStatus == 'Na čekanju') {
      return Palette.darkBlue;
    } else if (vaccinationStatus == 'naručen' ||
        vaccinationStatus == 'Naručen') {
      return Palette.yellow;
    } else if (vaccinationStatus == 'cijepljen' ||
        vaccinationStatus == 'Cijepljen') {
      return Palette.green;
    } else {
      return Colors.black;
    }
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
        child: FutureBuilder(
          future: Database.getUserVaccinationInfo(http.Client(), userOib),
          builder: (context, dynamic snapshot) {
            if (snapshot.hasData && snapshot.data[0].drugaDozaDatum != null) {
              if (snapshot.data[0].drugaDozaDatum != null) {
                String drugaDozaDatumGodina =
                    snapshot.data[0].drugaDozaDatum.substring(0, 4);
                String drugaDozaDatumMjesec =
                    snapshot.data[0].drugaDozaDatum.substring(4, 6);
                String drugaDozaDatumDan =
                    snapshot.data[0].drugaDozaDatum.substring(6, 8);

                sDrugaDozaDatum =
                    '$drugaDozaDatumDan.$drugaDozaDatumMjesec.$drugaDozaDatumGodina.';
              } else {
                sDrugaDozaDatum = '-';
              }

              snapshot.data[0].vrstaCjepiva == null
                  ? vaccineType = '-'
                  : vaccineType = vaccineName;

              snapshot.data[0].drugaDozaStatus == null
                  ? vaccinationStatus = '-'
                  : vaccinationStatus = snapshot.data[0].drugaDozaStatus;

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    children: [
                      const ScreenTitle(
                        title: 'COVID-19 cjepivo (druga doza)',
                      ),
                      const SizedBox(height: 24.0),
                      Container(
                        height: 260.0,
                        width: width,
                        decoration: BoxDecoration(
                          color: Palette.lightBlue,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vaccinationStatus == 'cijepljen' ||
                                        vaccinationStatus == 'Cijepljen'
                                    ? 'Cijepili ste se sa \ndrugom dozom COVID-19 cjepiva.'
                                    : 'Naručeni ste za\ndrugu dozu COVID-19 cjepiva.',
                                style: const TextStyle(
                                  color: Palette.darkGrey,
                                  fontSize: 18.0,
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              AppointmentInfoText(
                                label: 'Status:',
                                value: vaccinationStatus,
                                valueColor: getStatusColor(),
                              ),
                              const SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppointmentInfoText(
                                    label: 'Cjepivo:',
                                    value: vaccineType,
                                    valueColor: Palette.darkBlue,
                                  ),
                                  AppointmentInfoText(
                                    label: 'Datum:',
                                    value: sDrugaDozaDatum,
                                    valueColor: Palette.darkBlue,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      getStatus(),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text(
                  'Još niste naručeni za\ndrugu dozu cjepiva.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
