/// Uchish tarmog'idagi ikki aeroportni bog'lovchi yo'nalishli og'irlikli aloqa.
///
/// Har bir qirra uchta mustaqil og'irlikka ega: pul [cost], masofa [distanceKm]
/// va vaqt [timeMinutes]. Algoritmlar `weightOf` funksiyasi orqali kerakli
/// og'irlikni tanlab, maqsad-agnostik bo'lib qoladi.
class Edge {
  /// Kelib chiqish aeroportining IATA kodi (masalan, `JFK`).
  final String from;

  /// Manzil aeroportining IATA kodi (masalan, `LHR`).
  final String to;

  /// USD da chipta/operatsion narx.
  final double cost;

  /// Kilometrlarda buyuk doira masofasi.
  final double distanceKm;

  /// Rejalashtirilgan uchish vaqti daqiqalarda.
  final int timeMinutes;

  const Edge({
    required this.from,
    required this.to,
    required this.cost,
    required this.distanceKm,
    required this.timeMinutes,
  });

  /// Teskari yo'nalishdagi bir xil aloqa (og'irliklar saqlanadi).
  Edge reversed() => Edge(
        from: to,
        to: from,
        cost: cost,
        distanceKm: distanceKm,
        timeMinutes: timeMinutes,
      );

  @override
  String toString() =>
      '$from→$to (\$${cost.toStringAsFixed(0)}, '
      '${distanceKm.toStringAsFixed(0)}km, ${timeMinutes}min)';
}

/// Qirrani og'irlash mumkin bo'lgan optimallashtirishmetrikalari.
enum RouteMetric {
  cost('Narx', '\$'),
  distance('Masofa', 'km'),
  time('Vaqt', 'min');

  const RouteMetric(this.label, this.unit);

  final String label;
  final String unit;

  /// Ushbu metrikaning og'irligini [edge] dan oladi.
  double weightOf(Edge edge) => switch (this) {
        RouteMetric.cost => edge.cost,
        RouteMetric.distance => edge.distanceKm,
        RouteMetric.time => edge.timeMinutes.toDouble(),
      };
}
