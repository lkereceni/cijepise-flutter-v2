class VaccinationInfo {
  final String? oib;
  final String? vrstaCjepiva;
  final String? prvaDozaDatum;
  final String? prvaDozaStatus;
  final String? drugaDozaDatum;
  final String? drugaDozaStatus;

  VaccinationInfo({
    this.oib,
    this.vrstaCjepiva,
    this.prvaDozaDatum,
    this.prvaDozaStatus,
    this.drugaDozaDatum,
    this.drugaDozaStatus,
  });

  factory VaccinationInfo.fromJson(Map<String, dynamic> json) {
    return VaccinationInfo(
      oib: json['OIB'],
      vrstaCjepiva: json['vrsta_cjepiva'],
      prvaDozaDatum: json['prva_doza_datum'],
      prvaDozaStatus: json['prva_doza_status'],
      drugaDozaDatum: json['druga_doza_datum'],
      drugaDozaStatus: json['druga_doza_status'],
    );
  }
}
