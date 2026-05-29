import 'package:skynet/skynet.dart';
import 'package:test/test.dart';

Graph _sampleGraph() {
  return Graph()
    ..addEdge(const Edge(from: 'A', to: 'B', cost: 1, distanceKm: 10, timeMinutes: 10))
    ..addEdge(const Edge(from: 'B', to: 'C', cost: 2, distanceKm: 20, timeMinutes: 20))
    ..addEdge(const Edge(from: 'A', to: 'C', cost: 10, distanceKm: 5, timeMinutes: 5))
    ..addEdge(const Edge(from: 'C', to: 'D', cost: 1, distanceKm: 30, timeMinutes: 30));
}

void main() {
  group('Dijkstra', () {
    test('finds the cheapest (not fewest-hop) route', () {
      final path = dijkstra(_sampleGraph(), 'A', 'C');
      expect(path.path, ['A', 'B', 'C']);
      expect(path.totalWeight, 3);
    });

    test('optimises by the chosen metric', () {
      final byDistance =
          dijkstra(_sampleGraph(), 'A', 'C', metric: RouteMetric.distance);
      expect(byDistance.path, ['A', 'C']);
    });

    test('reports unreachable destinations gracefully', () {
      final g = Graph()
        ..addVertex('X')
        ..addVertex('Y');
      final path = dijkstra(g, 'X', 'Y');
      expect(path.isReachable, isFalse);
      expect(path.totalWeight, double.infinity);
    });

    test('unknown airport throws ArgumentError', () {
      expect(() => dijkstra(_sampleGraph(), 'A', 'Z'), throwsArgumentError);
    });
  });

  group('Minimum Spanning Tree', () {
    test('Kruskal and Prim agree on total weight for a connected graph', () {
      final g = Graph()
        ..addUndirectedEdge(const Edge(from: 'A', to: 'B', cost: 1, distanceKm: 1, timeMinutes: 1))
        ..addUndirectedEdge(const Edge(from: 'B', to: 'C', cost: 2, distanceKm: 1, timeMinutes: 1))
        ..addUndirectedEdge(const Edge(from: 'A', to: 'C', cost: 3, distanceKm: 1, timeMinutes: 1))
        ..addUndirectedEdge(const Edge(from: 'C', to: 'D', cost: 4, distanceKm: 1, timeMinutes: 1));
      final k = kruskalMst(g);
      final p = primMst(g);
      expect(k.totalWeight, p.totalWeight);
      expect(k.totalWeight, 7); // 1 + 2 + 4
      expect(k.isConnected, isTrue);
      expect(k.edges.length, g.order - 1);
    });

    test('empty graph yields an empty, connected tree', () {
      final tree = kruskalMst(Graph());
      expect(tree.edges, isEmpty);
      expect(tree.isConnected, isTrue);
    });

    test('disconnected graph yields a flagged spanning forest', () {
      final g = Graph()
        ..addUndirectedEdge(const Edge(from: 'A', to: 'B', cost: 1, distanceKm: 1, timeMinutes: 1))
        ..addVertex('Z'); // isolated island.
      expect(kruskalMst(g).isConnected, isFalse);
      expect(primMst(g).isConnected, isFalse);
    });
  });

  group('Sorting', () {
    final data = [5, 3, 8, 1, 9, 2, 7, 4, 6, 0];
    int cmp(int a, int b) => a.compareTo(b);

    test('QuickSort and MergeSort both sort correctly', () {
      expect(quickSort(data, cmp).sorted, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      expect(mergeSort(data, cmp).sorted, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
    });

    test('do not mutate the input list', () {
      final copy = List<int>.of(data);
      quickSort(data, cmp);
      mergeSort(data, cmp);
      expect(data, copy);
    });

    test('report comparison counts for performance comparison', () {
      expect(quickSort(data, cmp).stats.comparisons, greaterThan(0));
      expect(mergeSort(data, cmp).stats.comparisons, greaterThan(0));
    });

    test('handle empty and single-element lists', () {
      expect(quickSort(<int>[], cmp).sorted, isEmpty);
      expect(mergeSort([42], cmp).sorted, [42]);
    });
  });

  group('KMP string matching', () {
    test('finds all occurrences including overlaps', () {
      expect(kmpSearch('abababab', 'abab'), [0, 2, 4]);
    });

    test('is case-insensitive by default', () {
      expect(kmpContains('Amelia Watson', 'watson'), isTrue);
    });

    test('empty pattern matches nothing', () {
      expect(kmpSearch('anything', ''), isEmpty);
    });

    test('pattern longer than text matches nothing', () {
      expect(kmpSearch('hi', 'hello'), isEmpty);
    });
  });

  group('Backtracking rerouting', () {
    test('finds alternative simple paths, sorted best-first', () {
      final routes = findAlternativeRoutes(_sampleGraph(), 'A', 'C');
      expect(routes, isNotEmpty);
      expect(routes.first.totalWeight, 3);
      for (final r in routes) {
        expect(r.path.toSet().length, r.path.length);
      }
    });

    test('avoids closed hubs', () {
      final routes =
          findAlternativeRoutes(_sampleGraph(), 'A', 'C', blocked: {'B'});
      expect(routes, isNotEmpty);
      for (final r in routes) {
        expect(r.path, isNot(contains('B')));
      }
    });

    test('returns nothing when all paths are severed', () {
      final routes =
          findAlternativeRoutes(_sampleGraph(), 'A', 'D', blocked: {'C'});
      expect(routes, isEmpty);
    });

    test('cyclic graphs terminate (no infinite recursion)', () {
      final cyclic = Graph()
        ..addUndirectedEdge(const Edge(from: 'A', to: 'B', cost: 1, distanceKm: 1, timeMinutes: 1))
        ..addUndirectedEdge(const Edge(from: 'B', to: 'C', cost: 1, distanceKm: 1, timeMinutes: 1))
        ..addUndirectedEdge(const Edge(from: 'C', to: 'A', cost: 1, distanceKm: 1, timeMinutes: 1));
      final routes = findAlternativeRoutes(cyclic, 'A', 'C');
      expect(routes, isNotEmpty);
    });
  });

  group('SkyNetSystem integration', () {
    test('seeds every phase with sample data', () {
      final system = SkyNetSystem.seeded();
      expect(system.network.airportCount, greaterThan(0));
      expect(system.search.profileCount, greaterThan(0));
      expect(system.checkIn.waiting, greaterThan(0));
      expect(system.checkIn.peekNext().tier, TicketTier.platinum);
    });
  });
}
