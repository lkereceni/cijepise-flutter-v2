import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cijepise_flutter_2/models/models.dart';

class Database {
  static const root = 'student.vsmti.hr';
  static const path = 'lkereceni/db.php';
  static const _getUserAction = 'GET_USER';
  static const _addUserAction = 'ADD_USER';
  static const _updateUserAction = 'UPDATE_USER';
  static const _getZupanijeAction = 'GET_ZUPANIJE';
  static const _getOibAction = 'GET_OIB';
  static const _getUserLoginAction = 'GET_USER_LOGIN';
  static const _getUserVaccinationInfoAction = 'GET_USER_VACCINATION_INFO';
  static const _addUserVaccinationAction = 'ADD_USER_VACCINATION';
  static const _getUserVaccineName = 'GET_USER_VACCINE_NAME';

  static Future getUser(http.Client client, String? oib) async {
    var map = <String, dynamic>{};

    map['action'] = _getUserAction;
    map['OIB'] = oib;

    final response = await client.post(Uri.http(root, path), body: map);

    if (response.statusCode == 200) {
      List<User> list = parseUser(response.body);

      return list[0];
    }
  }

  static List<User> parseUser(String responseBody) {
    final parsed = json.decode(responseBody);

    return parsed[0].map<User>((json) => User.fromJson(json)).toList();
  }

  static Future addUser(
    String? ime,
    String? prezime,
    String? adresa,
    String? grad,
    String? zupanija,
    int oib,
    int datumRodenja,
    String? lozinka,
    String? token,
  ) async {
    // ignore: avoid_print
    print(
        'Ime: $ime, Prezime: $prezime, Adresa: $adresa, Grad: $grad, Zupanija: $zupanija, OIB: $oib, DatumRodenja: $datumRodenja, Lozinka: $lozinka, Token: $token');
    try {
      var map = <String, dynamic>{};
      map['action'] = _addUserAction;
      map['ime'] = ime;
      map['prezime'] = prezime;
      map['adresa'] = adresa;
      map['grad'] = grad;
      map['zupanija'] = zupanija;
      map['OIB'] = oib.toString();
      map['datum_rodenja'] = datumRodenja.toString();
      map['lozinka'] = lozinka;
      map['token'] = token;

      final response = await http.post(Uri.http(root, path), body: map);

      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  static Future<List?> getUserLogin(http.Client client, String oib) async {
    try {
      var map = <String, dynamic>{};

      map['action'] = _getUserLoginAction;
      map['OIB'] = oib;

      final response = await client.post(Uri.http(root, path), body: map);

      if (response.statusCode == 200) {
        List<User?> list = parseUserLogin(response.body);
        List users = [];

        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> user = {
            'oib': list[i]?.oib,
            'lozinka': list[i]?.lozinka,
          };
          users.add(user);
        }

        return users;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  static List<User?> parseUserLogin(String responseBody) {
    final parsed = json.decode(responseBody);

    if (parsed.length == 0) {
      return List.empty();
    } else {
      return parsed[0].map<User?>((json) => User.fromJson(json)).toList();
    }
  }

  static Future<List<VaccinationInfo>?> getUserVaccinationInfo(
      http.Client client, String? oib) async {
    var map = <String, dynamic>{};
    map['action'] = _getUserVaccinationInfoAction;
    map['OIB'] = oib;
    final response = await client.post(Uri.http(root, path), body: map);

    if (response.statusCode == 200) {
      List<VaccinationInfo> list = parseUserVaccinationInfo(response.body);
      if (list.isNotEmpty) {
        return list;
      }
    } else {
      return null;
    }
  }

  static List<VaccinationInfo> parseUserVaccinationInfo(String responseBody) {
    final parsed = json.decode(responseBody);

    if (parsed.length == 0) {
      return List.empty();
    } else {
      return parsed[0]
          .map<VaccinationInfo>((json) => VaccinationInfo.fromJson(json))
          .toList();
    }
  }

  static Future getVaccineName(http.Client client, String oib) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _getUserVaccineName;
      map['OIB'] = oib;
      final response = await client.post(Uri.http(root, path), body: map);

      if (response.statusCode == 200) {
        List<dynamic> vaccineName = json.decode(response.body);

        return vaccineName[0][0]['naziv_cjepiva'];
      }
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  static Future<List<Zupanija>?> getZupanije(http.Client client) async {
    var map = <String, dynamic>{};
    map['action'] = _getZupanijeAction;

    final response = await client.post(Uri.http(root, path), body: map);

    if (response.statusCode == 200) {
      List<Zupanija> list = parseZupanije(response.body);
      return list;
    }
  }

  static List<Zupanija> parseZupanije(String responseBody) {
    final parsed = json.decode(responseBody);

    return parsed[0].map<Zupanija>((json) => Zupanija.fromJson(json)).toList();
  }

  static Future<List<dynamic>> gradoviJson(String query) async {
    final String response =
        await rootBundle.loadString('lib/data/gradovi.json');
    final data = await json.decode(response);
    List gradovi = [];

    gradovi = data
        .where((element) => element['zupanija'].toString().contains(query))
        .toList();

    return gradovi;
  }

  static Future<List?> getOIB(http.Client client) async {
    var map = <String, dynamic>{};
    map['action'] = _getOibAction;

    final response = await client.post(Uri.http(root, path), body: map);

    if (response.statusCode == 200) {
      List oib = [];
      List<User> list = parseOIB(response.body) as List<User>;

      for (int i = 0; i < list.length; i++) {
        oib.add(list[i].oib);
      }

      return oib;
    }
  }

  static List parseOIB(String responseBody) {
    final parsed = json.decode(responseBody);

    return parsed[0].map<User>((json) => User.fromJson(json)).toList();
  }

  static Future<String?> updateUser(
    String? id,
    String ime,
    String prezime,
    String adresa,
    String? grad,
    String? zupanija,
    int oib,
    int datumRodenja,
  ) async {
    var map = <String, dynamic>{};
    map['action'] = _updateUserAction;
    map['ID'] = id;
    map['ime'] = ime;
    map['prezime'] = prezime;
    map['adresa'] = adresa;
    map['grad'] = grad;
    map['zupanija'] = zupanija;
    map['OIB'] = oib.toString();
    map['datum_rodenja'] = datumRodenja.toString();

    final response = await http.post(Uri.http(root, path), body: map);

    if (response.statusCode == 200) {
      return response.body;
    }
  }

  static Future<String?> addUserVaccination(String oib) async {
    var map = <String, dynamic>{};
    map['action'] = _addUserVaccinationAction;
    map['OIB'] = oib;

    final response = await http.post(Uri.http(root, path), body: map);

    if (response.statusCode == 200) {
      return response.body;
    }
  }
}
