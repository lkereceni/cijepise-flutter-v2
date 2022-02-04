import 'package:cijepise_flutter_2/config/palette.dart';
import 'package:cijepise_flutter_2/services/database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cijepise_flutter_2/widgets/widgets.dart';
import 'package:cijepise_flutter_2/screens/screens.dart';

String? userId;
String userOib = '';
String? userIme;
String? userPrezime;
String? userAdresa;
String? userGrad;
String? userZupanija;
String? userDatumRodenja;

String sDatumRodenja = '';

class DataChangeScreen extends StatefulWidget {
  const DataChangeScreen({Key? key}) : super(key: key);

  @override
  _DataChangeScreenState createState() => _DataChangeScreenState();
}

class _DataChangeScreenState extends State<DataChangeScreen> {
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
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                    RoundedButton(
                      text: 'Promijeni podatke',
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
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
