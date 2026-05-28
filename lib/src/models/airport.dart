/// Uchish tarmog'idagi tugun.
class Airport {
  /// IATA kodi, masalan `JFK` — grafda ishlatiladigan noyob identifikator.
  final String code;
  final String city;
  final String country;

  const Airport({
    required this.code,
    required this.city,
    required this.country,
  });

  @override
  String toString() => '$code ($city, $country)';
}
