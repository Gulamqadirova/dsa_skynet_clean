import '../structures/graph.dart';
import '../structures/priority_queue.dart';


class ShortestPath {
  final List<String> path;
  final double totalWeight;

  final List<Edge> edges;

  const ShortestPath({
    required this.path,
    required this.totalWeight,
    required this.edges,
  });
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

  final frontier = PriorityQueue<({String vertex, double dist})>(
    (a, b) => b.dist.compareTo(a.dist),
  )..insert((vertex: source, dist: 0));

  while (frontier.isNotEmpty) {
    final current = frontier.removeMax();
    if (!settled.add(current.vertex)) continue;
    if (current.vertex == target) break;

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
