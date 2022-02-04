class User {
  String? id;
  String? ime;
  String? prezime;
  String? adresa;
  String? grad;
  String? zupanija;
  String? oib;
  String? datumRodenja;
  String? lozinka;
  String? token;

  User({
    this.id,
    this.ime,
    this.prezime,
    this.adresa,
    this.grad,
    this.zupanija,
    this.oib,
    this.datumRodenja,
    this.lozinka,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['ID'],
      ime: json['ime'],
      prezime: json['prezime'],
      adresa: json['adresa'],
      grad: json['grad'],
      zupanija: json['zupanija'],
      oib: json['OIB'],
      datumRodenja: json['datum_rodenja'],
      lozinka: json['lozinka'],
      token: json['token'],
    );
  }
}
