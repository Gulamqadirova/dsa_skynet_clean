import '../algorithms/dijkstra.dart';
import '../algorithms/minimum_spanning_tree.dart';
import '../algorithms/rerouting.dart';
import '../models/airport.dart';
import '../structures/graph.dart';

/// Faza 1 — Global navigatsiya va infratuzilma.
///
/// [Graph] ni butunlay kapsulalaydi: UI aeroportlar, marshrutlar va
/// metrikalar bilan ishlaydi, hech qachon qo'shnilik ro'yxatlari yoki
/// saqlangan qirralar bilan emas. Ichki ko'rinishni almashtirish (masalan,
/// qo'shnilik matritsasiga) ushbu API ni o'zgartirmaydi.
class NetworkService {
  final Graph _graph = Graph();
  final Map<String, Airport> _airports = {};

  /// Aeroportni ro'yxatdan o'tkazadi (kodi bo'yicha idempotent).
  void addAirport(Airport airport) {
    _airports[airport.code] = airport;
    _graph.addVertex(airport.code);
  }

  /// To'g'ridan-to'g'ri reysni yo'nalishli og'irlikli qirra sifatida qo'shadi.
  /// Ikkala uch ham ma'lum aeroportlar bo'lishi kerak.
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

  /// Barqaror ko'rsatish uchun kod bo'yicha saralangan barcha ma'lum aeroportlar.
  List<Airport> get airports => _airports.values.toList(growable: false)
    ..sort((a, b) => a.code.compareTo(b.code));

  /// Tarmoqdagi barcha to'g'ridan-to'g'ri reyslar.
  List<Edge> get flights => _graph.edges;

  int get airportCount => _graph.order;
  int get flightCount => _graph.size;
  bool get isEmpty => _graph.isEmpty;

  /// Aeroportning ko'rsatish ma'lumotlarini qidiradi, yoki noma'lum bo'lsa `null`.
  Airport? airport(String code) => _airports[code];

  /// Dijkstra orqali eng arzon (yoki qisqa/tezkor) marshrutni topadi.
  ShortestPath cheapestRoute(
    String from,
    String to, {
    RouteMetric metric = RouteMetric.cost,
  }) {
    _requireAirport(from);
    _requireAirport(to);
    return dijkstra(_graph, from, to, metric: metric);
  }

  /// Kruskal MST orqali eng arzon zaxira aloqa tarmog'ini quradi.
  SpanningTree backupNetworkKruskal({RouteMetric metric = RouteMetric.cost}) =>
      kruskalMst(_graph, metric: metric);

  /// Algoritm taqqoslashi uchun Prim MST orqali xuddi shu tarmoq.
  SpanningTree backupNetworkPrim({RouteMetric metric = RouteMetric.cost}) =>
      primMst(_graph, metric: metric);

  /// [closed] aeroportlardan qochadigan barcha muqobil marshrutlar (rekursiv orqaga qaytish).
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
