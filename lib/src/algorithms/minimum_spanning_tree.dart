import '../structures/graph.dart';
import '../structures/priority_queue.dart';

class SpanningTree {
  final List<Edge> edges;
  final double totalWeight;
  final bool isConnected;

  const SpanningTree({
    required this.edges,
    required this.totalWeight,
    required this.isConnected,
  });
}

class _DisjointSet {
  final Map<String, String> _parent = {};
  final Map<String, int> _rank = {};

  void makeSet(String x) {
    _parent.putIfAbsent(x, () => x);
    _rank.putIfAbsent(x, () => 0);
  }

  String find(String x) {
    var root = x;
    while (_parent[root] != root) {
      root = _parent[root]!;
    }
    var node = x;
    while (_parent[node] != root) {
      final next = _parent[node]!;
      _parent[node] = root;
      node = next;
    }
    return root;
  }


  bool union(String a, String b) {
    final ra = find(a);
    final rb = find(b);
    if (ra == rb) return false;
    final rankA = _rank[ra]!;
    final rankB = _rank[rb]!;
    if (rankA < rankB) {
      _parent[ra] = rb;
    } else if (rankA > rankB) {
      _parent[rb] = ra;
    } else {
      _parent[rb] = ra;
      _rank[ra] = rankA + 1;
    }
    return true;
  }
}

SpanningTree kruskalMst(Graph graph, {RouteMetric metric = RouteMetric.cost}) {
  final dsu = _DisjointSet();
  for (final v in graph.vertices) {
    dsu.makeSet(v);
  }

  final sorted = graph.undirectedEdges
    ..sort((a, b) => metric.weightOf(a).compareTo(metric.weightOf(b)));

  final chosen = <Edge>[];
  var total = 0.0;
  for (final edge in sorted) {
    if (dsu.union(edge.from, edge.to)) {
      chosen.add(edge);
      total += metric.weightOf(edge);
      if (chosen.length == graph.order - 1) break;
    }
  }

  return SpanningTree(
    edges: chosen,
    totalWeight: total,
    isConnected: graph.order <= 1 || chosen.length == graph.order - 1,
  );
}

SpanningTree primMst(Graph graph, {RouteMetric metric = RouteMetric.cost}) {
  if (graph.isEmpty) {
    return const SpanningTree(edges: [], totalWeight: 0, isConnected: true);
  }

  final inTree = <String>{};
  final chosen = <Edge>[];
  var total = 0.0;
  final frontier = PriorityQueue<Edge>(
    (a, b) => metric.weightOf(b).compareTo(metric.weightOf(a)),
  );

  final start = graph.vertices.first;
  inTree.add(start);
  for (final e in graph.neighbours(start)) {
    frontier.insert(e);
  }

  while (frontier.isNotEmpty && inTree.length < graph.order) {
    final edge = frontier.removeMax();
    if (inTree.contains(edge.to)) continue;
    inTree.add(edge.to);
    chosen.add(edge);
    total += metric.weightOf(edge);
    for (final next in graph.neighbours(edge.to)) {
      if (!inTree.contains(next.to)) frontier.insert(next);
    }
  }

  return SpanningTree(
    edges: chosen,
    totalWeight: total,
    isConnected: inTree.length == graph.order,
  );
}
