class Zupanija {
  final String? id;
  final String? nazivZupanije;

  Zupanija({
    this.id,
    this.nazivZupanije,
  });

  factory Zupanija.fromJson(Map<String, dynamic> json) {
    return Zupanija(
      id: json['ID'],
      nazivZupanije: json['naziv_zupanije'],
    );
  }
}
