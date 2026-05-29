import '../structures/graph.dart';

class AlternativeRoute {
  final List<String> path;
  final List<Edge> edges;
  final double totalWeight;

  const AlternativeRoute({
    required this.path,
    required this.edges,
    required this.totalWeight,
  });

  int get hops => edges.length;
}

List<AlternativeRoute> findAlternativeRoutes(
  Graph graph,
  String source,
  String target, {
  Set<String> blocked = const {},
  RouteMetric metric = RouteMetric.cost,
  int maxHops = 6,
  int maxRoutes = 25,
}) {
  if (!graph.containsVertex(source) || !graph.containsVertex(target)) {
    return const [];
  }
  if (blocked.contains(source) || blocked.contains(target)) {
    return const [];
  }

  final results = <AlternativeRoute>[];
  final visited = <String>{source};
  final pathStack = <String>[source];
  final edgeStack = <Edge>[];

  void backtrack(String current, double weightSoFar) {
    if (results.length >= maxRoutes) return;
    if (current == target) {
      results.add(
        AlternativeRoute(
          path: List<String>.of(pathStack),
          edges: List<Edge>.of(edgeStack),
          totalWeight: weightSoFar,
        ),
      );
      return;
    }
    if (edgeStack.length >= maxHops) return;
    for (final edge in graph.neighbours(current)) {
      final next = edge.to;
      if (blocked.contains(next) || visited.contains(next)) continue;
      visited.add(next);
      pathStack.add(next);
      edgeStack.add(edge);
      backtrack(next, weightSoFar + metric.weightOf(edge));
      visited.remove(next);
      pathStack.removeLast();
      edgeStack.removeLast();
    }
  }

  backtrack(source, 0);
  results.sort((a, b) => a.totalWeight.compareTo(b.totalWeight));
  return results;
}
