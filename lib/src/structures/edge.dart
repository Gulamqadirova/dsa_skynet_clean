class Edge {
  final String from;
  final String to;
  final double cost;
  final double distanceKm;
  final int timeMinutes;

  const Edge({
    required this.from,
    required this.to,
    required this.cost,
    required this.distanceKm,
    required this.timeMinutes,
  });


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


enum RouteMetric {
  cost('Narx', '\$'),
  distance('Masofa', 'km'),
  time('Vaqt', 'min');

  const RouteMetric(this.label, this.unit);

  final String label;
  final String unit;

  double weightOf(Edge edge) => switch (this) {
        RouteMetric.cost => edge.cost,
        RouteMetric.distance => edge.distanceKm,
        RouteMetric.time => edge.timeMinutes.toDouble(),
      };
}
