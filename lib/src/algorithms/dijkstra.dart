import '../structures/graph.dart';
import '../structures/priority_queue.dart';

/// Bitta manbadan qisqa yo'l qidiruvining natijasi.
class ShortestPath {
  /// Manbadan manzilgacha (ham kirgan) tartibli tepalar ro'yxati.
  final List<String> path;

  /// [path] bo'ylab to'plangan umumiy og'irlik.
  final double totalWeight;

  /// Tartib bo'yicha bosib o'tilgan qirralar.
  final List<Edge> edges;

  const ShortestPath({
    required this.path,
    required this.totalWeight,
    required this.edges,
  });

  /// Manbadan manzilgacha yo'l mavjudligini tekshiradi.
  bool get isReachable => path.isNotEmpty;
}

/// **Dijkstra algoritmi** — ikki shahar orasidagi eng arzon yo'l.
///
/// Ikkilik-heap [PriorityQueue] bilan murakkablik `O((V + E) log V)`,
/// massiv skaniga nisbatan `O(V²)` o'rniga. Dijkstra manfiy bo'lmagan
/// qirra og'irliklarini talab qiladi (narx, masofa va vaqt ≥ 0).
///
/// [ShortestPath] qaytaradi; erishib bo'lmaydigan [target] istisno tashlash
/// o'rniga bo'sh yo'l va cheksiz og'irlik qaytaradi, shuning uchun chaqiruvchilar
/// "yo'l yo'q" ni ko'rsatishi mumkin.
ShortestPath dijkstra(
  Graph graph,
  String source,
  String target, {
  RouteMetric metric = RouteMetric.cost,
}) {
  if (!graph.containsVertex(source)) {
    throw ArgumentError('Noma\'lum manba aeroporti "$source"');
  }
  if (!graph.containsVertex(target)) {
    throw ArgumentError('Noma\'lum manzil aeroporti "$target"');
  }

  final dist = <String, double>{
    for (final v in graph.vertices) v: double.infinity,
  };
  final previous = <String, Edge>{};
  final settled = <String>{};
  dist[source] = 0;

  // Eng *kichik* taxminiy masofaga tartiblanadigan chegara, shuning uchun
  // maks-heap uchun teskari. Har bir yozuv navbatga qo'shilgan masofani
  // saqlaydi (eski yozuvlarni aniqlash uchun "dangasa o'chirish").
  final frontier = PriorityQueue<({String vertex, double dist})>(
    (a, b) => b.dist.compareTo(a.dist),
  )..insert((vertex: source, dist: 0));

  while (frontier.isNotEmpty) {
    final current = frontier.removeMax();
    if (!settled.add(current.vertex)) continue; // allaqachon yakunlangan.
    if (current.vertex == target) break; // manzil joylashganda erta chiqish.

    for (final edge in graph.neighbours(current.vertex)) {
      if (settled.contains(edge.to)) continue;
      final candidate = dist[current.vertex]! + metric.weightOf(edge);
      if (candidate < dist[edge.to]!) {
        dist[edge.to] = candidate;
        previous[edge.to] = edge;
        frontier.insert((vertex: edge.to, dist: candidate));
      }
    }
  }

  if (dist[target] == double.infinity) {
    return const ShortestPath(path: [], totalWeight: double.infinity, edges: []);
  }
  return _reconstruct(source, target, previous, dist[target]!);
}

ShortestPath _reconstruct(
  String source,
  String target,
  Map<String, Edge> previous,
  double totalWeight,
) {
  final edges = <Edge>[];
  final path = <String>[target];
  var node = target;
  while (node != source) {
    final edge = previous[node]!;
    edges.add(edge);
    path.add(edge.from);
    node = edge.from;
  }
  return ShortestPath(
    path: path.reversed.toList(growable: false),
    totalWeight: totalWeight,
    edges: edges.reversed.toList(growable: false),
  );
}
