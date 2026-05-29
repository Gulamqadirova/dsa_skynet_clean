import '../algorithms/dijkstra.dart';
import '../algorithms/minimum_spanning_tree.dart';
import '../algorithms/rerouting.dart';
import '../models/airport.dart';
import '../structures/graph.dart';
class NetworkService {
  final Graph _graph = Graph();
  final Map<String, Airport> _airports = {};
  void addAirport(Airport airport) {
    _airports[airport.code] = airport;
    _graph.addVertex(airport.code);
  }

  void addFlight({
    required String from,
    required String to,
    required double cost,
    required double distanceKm,
    required int timeMinutes,
  }) {
    _requireAirport(from);
    _requireAirport(to);
    _graph.addEdge(
      Edge(
        from: from,
        to: to,
        cost: cost,
        distanceKm: distanceKm,
        timeMinutes: timeMinutes,
      ),
    );
  }

  List<Airport> get airports => _airports.values.toList(growable: false)
    ..sort((a, b) => a.code.compareTo(b.code));
  List<Edge> get flights => _graph.edges;

  int get airportCount => _graph.order;
  int get flightCount => _graph.size;
  bool get isEmpty => _graph.isEmpty;
  Airport? airport(String code) => _airports[code];


  ShortestPath cheapestRoute(
    String from,
    String to, {
    RouteMetric metric = RouteMetric.cost,
  }) {
    _requireAirport(from);
    _requireAirport(to);
    return dijkstra(_graph, from, to, metric: metric);
  }

  SpanningTree backupNetworkKruskal({RouteMetric metric = RouteMetric.cost}) =>
      kruskalMst(_graph, metric: metric);
  SpanningTree backupNetworkPrim({RouteMetric metric = RouteMetric.cost}) =>
      primMst(_graph, metric: metric);

  List<AlternativeRoute> alternativeRoutes({
    required String from,
    required String to,
    Set<String> closed = const {},
    RouteMetric metric = RouteMetric.cost,
    int maxHops = 6,
    int maxRoutes = 25,
  }) =>
      findAlternativeRoutes(
        _graph,
        from,
        to,
        blocked: closed,
        metric: metric,
        maxHops: maxHops,
        maxRoutes: maxRoutes,
      );

  void _requireAirport(String code) {
    if (!_graph.containsVertex(code)) {
      throw ArgumentError('Noma\'lum aeroport "$code"');
    }
  }
}
