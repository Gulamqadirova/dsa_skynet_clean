import 'edge.dart';

export 'edge.dart';

class Graph {
  final Map<String, List<Edge>> _adjacency = {};
  Set<String> get vertices => _adjacency.keys.toSet();
  int get order => _adjacency.length;
  int get size => _adjacency.values.fold(0, (sum, list) => sum + list.length);
  bool get isEmpty => _adjacency.isEmpty;
  void addVertex(String vertex) {
    _adjacency.putIfAbsent(vertex, () => []);
  }
  void addEdge(Edge edge) {
    addVertex(edge.from);
    addVertex(edge.to);
    _adjacency[edge.from]!.add(edge);
  }
  void addUndirectedEdge(Edge edge) {
    addEdge(edge);
    addEdge(edge.reversed());
  }
  bool containsVertex(String vertex) => _adjacency.containsKey(vertex);

  List<Edge> neighbours(String vertex) =>
      List<Edge>.unmodifiable(_adjacency[vertex] ?? const []);

  List<Edge> get edges => [
        for (final list in _adjacency.values) ...list,
      ];

  List<Edge> get undirectedEdges {
    final seen = <String>{};
    final result = <Edge>[];
    for (final edge in edges) {
      final key = edge.from.compareTo(edge.to) <= 0
          ? '${edge.from}->${edge.to}'
          : '${edge.to}->${edge.from}';
      if (seen.add(key)) result.add(edge);
    }
    return result;
  }
  void clear() => _adjacency.clear();
}
