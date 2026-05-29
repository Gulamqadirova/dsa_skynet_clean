class Flight {
  final String flightNo;
  final String origin;
  final String destination;
  final int departureMinutes;
  final double price;
  final double fuelEfficiency;

  const Flight({
    required this.flightNo,
    required this.origin,
    required this.destination,
    required this.departureMinutes,
    required this.price,
    required this.fuelEfficiency,
  });

  String get departureLabel {
    final h = (departureMinutes ~/ 60).toString().padLeft(2, '0');
    final m = (departureMinutes % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  String toString() => '$flightNo $origin→$destination @ $departureLabel';
}
