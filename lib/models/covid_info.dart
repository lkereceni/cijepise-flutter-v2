class CovidInfo {
  final int? confirmed;
  final int? deaths;

  CovidInfo({
    this.confirmed,
    this.deaths,
  });

  factory CovidInfo.fromJson(Map<String, dynamic> json) {
    return CovidInfo(
      confirmed: json['Confirmed'],
      deaths: json['Deaths'],
    );
  }
}
