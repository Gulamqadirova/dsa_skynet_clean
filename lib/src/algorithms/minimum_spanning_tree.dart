import '../structures/graph.dart';
import '../structures/priority_queue.dart';

/// Minimal Yoyuvchi Daraxt (zaxira tarmoq) qurishning natijasi.
class SpanningTree {
  /// Daraxt uchun tanlangan qirralar.
  final List<Edge> edges;

  /// Tanlangan qirralar og'irliklarining yig'indisi.
  final double totalWeight;

  /// Har bir aeroport ulanganda `true` (bitta yoyuvchi daraxt).
  /// Graf uzluksiz bo'lsa `false` — bu holda yoyuvchi *o'rmon*.
  final bool isConnected;

  const SpanningTree({
    required this.edges,
    required this.totalWeight,
    required this.isConnected,
  });
}

/// Yo'l siqish va darajasi bo'yicha birlashtirishli ittifoq-topish / ajratilgan to'plam o'rmoni.
///
/// Ikkala operatsiya ham `O(α(n))` amortizatsiyalangan vaqtda ishlaydi,
/// bu erda `α` teskari Ackermann funksiyasi — har qanday real kiritish uchun ≤ 4.
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
    // Yo'l siqish: yo'ldagi har bir tuganni ildizga yo'naltiradi.
    var node = x;
    while (_parent[node] != root) {
      final next = _parent[node]!;
      _parent[node] = root;
      node = next;
    }
    return root;
  }

  /// Ikkita to'plam alohida bo'lsa va endi birlashtirilgan bo'lsa `true` qaytaradi.
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

/// **Kruskal algoritmi** — barcha aeroprotlarni bog'laydigan eng arzon tarmoq.
/// Tsikl hosil qilmaydigan eng yengil qirrani ochko'zlarcha qo'shadi.
///
/// Murakkablik `O(E log E)`, qirralarni saralash ustun; ittifoq-topish
/// tsikl tekshiruvi amalda doimiy. Siyrak graflar uchun ideal.
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
      if (chosen.length == graph.order - 1) break; // daraxt to'liq.
    }
  }

  return SpanningTree(
    edges: chosen,
    totalWeight: total,
    isConnected: graph.order <= 1 || chosen.length == graph.order - 1,
  );
}

/// **Prim algoritmi** — boshlang'ich tepadan tashqariga bitta daraxtni o'stiradi,
/// har doim chegara kesib o'tadigan eng arzon qirrani qabul qiladi (heap bilan dangasa variant).
/// Murakkablik `O(E log V)`. Kruskal bilan yonma-yon taqqoslash uchun qaytariladi;
/// ulangan grafda ikkalasi teng umumiy og'irlik beradi.
SpanningTree primMst(Graph graph, {RouteMetric metric = RouteMetric.cost}) {
  if (graph.isEmpty) {
    return const SpanningTree(edges: [], totalWeight: 0, isConnected: true);
  }

  final inTree = <String>{};
  final chosen = <Edge>[];
  var total = 0.0;
  final frontier = PriorityQueue<Edge>(
    (a, b) => metric.weightOf(b).compareTo(metric.weightOf(a)), // og'irlik bo'yicha min
  );

  final start = graph.vertices.first;
  inTree.add(start);
  for (final e in graph.neighbours(start)) {
    frontier.insert(e);
  }

  while (frontier.isNotEmpty && inTree.length < graph.order) {
    final edge = frontier.removeMax(); // eng yengil kesuvchi qirra.
    if (inTree.contains(edge.to)) continue; // eski: ikkalasi ham allaqachon ichida.
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
