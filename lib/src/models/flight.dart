/// Analitika (saralash) va narxlash (AVL) fazalarida ishlatiladigan rejalashtirilgan reys.
class Flight {
  final String flightNo;
  final String origin;
  final String destination;

  /// Yarim gechadagi daqiqalarda jo'nash vaqti (0–1439).
  final int departureMinutes;

  /// USD da chipta narxi — AVL-daraxtning diapazon so'rovlar uchun kaliti.
  final double price;

  /// Mavjud o'rindiq-kilometr uchun sarflangan yonilg'i litri (kamroq — yashilroq).
  final double fuelEfficiency;

  const Flight({
    required this.flightNo,
    required this.origin,
    required this.destination,
    required this.departureMinutes,
    required this.price,
    required this.fuelEfficiency,
  });

  /// Jo'nash vaqtini `HH:MM` formatida ko'rsatadi.
  String get departureLabel {
    final h = (departureMinutes ~/ 60).toString().padLeft(2, '0');
    final m = (departureMinutes % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  String toString() => '$flightNo $origin→$destination @ $departureLabel';
}
