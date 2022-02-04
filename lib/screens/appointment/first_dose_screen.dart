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
String sPrvaDozaDatum = '';
String vaccineName = '-';

List vaccinationInfo = [];

class FirstDoseScreen extends StatefulWidget {
  const FirstDoseScreen({Key? key}) : super(key: key);

  @override
  _FirstDoseScreenState createState() => _FirstDoseScreenState();
}

class _FirstDoseScreenState extends State<FirstDoseScreen> {
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
    } else if (vaccinationStatus == 'naručen' ||
        vaccinationStatus == 'Naručen') {
      return RoundedButton(
        text: 'Promijeni podatke',
        onClick: () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.clear();
          await Database.getUser(http.Client(), userOib).then((result) {
            prefs.setString('id', result![0].id);
            prefs.setString('oib', result[0].oib);
            prefs.setString('ime', result[0].ime);
            prefs.setString('prezime', result[0].prezime);
            prefs.setString('adresa', result[0].adresa);
            prefs.setString('grad', result[0].grad);
            prefs.setString('zupanija', result[0].zupanija);
            prefs.setString('datumRodenja', result[0].datumRodenja);
          });
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
            if (snapshot.hasData) {
              if (snapshot.data[0].prvaDozaDatum != null) {
                String prvaDozaDatumGodina =
                    snapshot.data[0].prvaDozaDatum.substring(0, 4);
                String prvaDozaDatumMjesec =
                    snapshot.data[0].prvaDozaDatum.substring(4, 6);
                String prvaDozaDatumDan =
                    snapshot.data[0].prvaDozaDatum.substring(6, 8);

                sPrvaDozaDatum =
                    '$prvaDozaDatumDan.$prvaDozaDatumMjesec.$prvaDozaDatumGodina.';
              } else {
                sPrvaDozaDatum = '-';
              }

              snapshot.data[0].vrstaCjepiva == null
                  ? vaccineType = '-'
                  : vaccineType = vaccineName;

              snapshot.data[0].prvaDozaStatus == null
                  ? vaccinationStatus = '-'
                  : vaccinationStatus = snapshot.data[0].prvaDozaStatus;

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    children: [
                      const ScreenTitle(
                        title: 'COVID-19 cjepivo (prva doza)',
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
                                    ? 'Cijepili ste se sa \nprvom dozom COVID-19 cjepiva.'
                                    : 'Naručeni ste za\nprvu dozu COVID-19 cjepiva.',
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
                                    value: sPrvaDozaDatum,
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
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const ScreenTitle(title: 'COVID-19 cjepivo (prva doza)'),
                      const SizedBox(height: 24.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppointmentInputContainer(
                            label: 'Ime',
                            width: width * .4,
                            controller: imeController,
                          ),
                          AppointmentInputContainer(
                            label: 'Prezime',
                            width: width * .4,
                            controller: prezimeController,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      AppointmentInputContainer(
                        label: 'Ulica i kućni broj',
                        width: width,
                        controller: adresaController,
                      ),
                      const SizedBox(height: 24.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Text(
                              'Županija',
                              style: TextStyle(
                                color: Palette.lightGrey,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2.0),
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
                              }
                              return Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Palette.lightBlue,
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                width: width,
                                height: 50.0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
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
                                        .map<DropdownMenuItem<String>>(
                                          (item) => DropdownMenuItem<String>(
                                            child: Text(item.nazivZupanije),
                                            value: item.nazivZupanije,
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (dynamic newVal) => setState(
                                      () {
                                        selectedItemGrad = null;
                                        selectedItemZupanija = newVal;
                                      },
                                    ),
                                    value: selectedItemZupanija,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Text(
                              'Grad',
                              style: TextStyle(
                                color: Palette.lightGrey,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          FutureBuilder(
                            future: Database.gradoviJson(selectedItemZupanija),
                            builder: (context, dynamic snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Palette.darkBlue,
                                    strokeWidth: 3.0,
                                  ),
                                );
                              }
                              return Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Palette.lightBlue,
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                width: width,
                                height: 50.0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
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
                                        .map<DropdownMenuItem<String>>(
                                          (item) => DropdownMenuItem<String>(
                                            child: Text(item['mjesto']),
                                            value: item['mjesto'],
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (dynamic newVal) => setState(
                                      () {
                                        selectedItemGrad = newVal;
                                      },
                                    ),
                                    value: selectedItemGrad,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppointmentInputContainer(
                            label: 'OIB',
                            width: width * .4,
                            controller: oibController,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Text(
                                  'Datum rođenja',
                                  style: TextStyle(
                                    color: Palette.lightGrey,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              SizedBox(
                                width: width * .4,
                                height: 50.0,
                                child: InkWell(
                                  onTap: () {
                                    selectDate(context);
                                  },
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(left: 20.0),
                                    decoration: BoxDecoration(
                                      color: Palette.lightBlue,
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    child: Text(
                                      sDatumRodenja,
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
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(
                          '*provjerite jesu li uneseni podaci ispravni',
                          style: TextStyle(
                            color: Palette.darkGrey,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      RoundedButton(
                        text: 'Naruči se',
                        onClick: () {
                          selectedDate.year == DateTime.now().year
                              ? sDatumRodenja = userDatumRodenja!
                              : sDatumRodenja =
                                  databaseFormatter.format(selectedDate);
                          Database.updateUser(
                            userId,
                            imeController.text,
                            prezimeController.text,
                            adresaController.text,
                            selectedItemGrad,
                            selectedItemZupanija,
                            int.parse(oibController.text),
                            int.parse(sDatumRodenja),
                          );
                          Database.addUserVaccination(oibController.text);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FirstDoseScreen(),
                            ),
                          );
                        },
                      ),
                    ],
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
