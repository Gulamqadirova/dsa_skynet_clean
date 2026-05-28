import 'edge.dart';

export 'edge.dart';

/// Qo'shnilik ro'yxati sifatida saqlangan og'irlikli yo'nalishli **Graf**.
///
/// ## Formal ADT spetsifikatsiyasi
///
/// ```
/// ADT Graph<V>
///   konstruktorlar
///     new()                       -> Graph<V>       // bo'sh graf
///   operatsiyalar
///     addVertex(Graph, V)         -> Graph
///     addEdge(Graph, Edge)        -> Graph          // yo'nalishli, og'irlikli
///     neighbours(Graph, V)        -> List<Edge>     // V ning chiquvchi qirralari
///     vertices(Graph)             -> Set<V>
///     edges(Graph)                -> List<Edge>
///     containsVertex(Graph, V)    -> bool
///     order(Graph)                -> int            // |V|
///     size(Graph)                 -> int            // |E|
///   aksiomalar
///     order(new())                          = 0
///     containsVertex(addVertex(g, v), v)    = true
///     neighbours(addEdge(g, e), e.from) e ni o'z ichiga oladi
/// ```
///
/// Qo'shnilik ro'yxati `O(V + E)` xotira sarflaydi va tepaning qo'shnilarini
/// `O(deg(v))` da ro'yxatlaydi — bu yerda modellashtiriladigan siyrak uchish
/// tarmoqlari uchun ideal (qo'shnilik *matritsasi* aksariyat yo'q yo'llarda
/// `O(V²)` xotirani isrof qiladi).
class Graph {
  final Map<String, List<Edge>> _adjacency = {};

  /// Tepa identifikatorlari to'plami. `O(V)`.
  Set<String> get vertices => _adjacency.keys.toSet();

  /// Tepalar soni, `|V|`. `O(1)`.
  int get order => _adjacency.length;

  /// Yo'nalishli qirralar soni, `|E|`. `O(V)`.
  int get size => _adjacency.values.fold(0, (sum, list) => sum + list.length);

  /// Graf tepalar mavjud emasligini tekshiradi. `O(1)`.
  bool get isEmpty => _adjacency.isEmpty;

  /// Agar mavjud bo'lmasa, ajratilgan tepa qo'shadi. `O(1)`.
  void addVertex(String vertex) {
    _adjacency.putIfAbsent(vertex, () => []);
  }

  /// Yo'nalishli [edge] qo'shadi, agar kerak bo'lsa, uning uchlari yaratiladi. `O(1)`.
  void addEdge(Edge edge) {
    addVertex(edge.from);
    addVertex(edge.to);
    _adjacency[edge.from]!.add(edge);
  }

  /// [edge] ni ikki yo'nalishda qo'shadi (Minimal Yoyuvchi Daraxt uchun). `O(1)`.
  void addUndirectedEdge(Edge edge) {
    addEdge(edge);
    addEdge(edge.reversed());
  }

  /// [vertex] grafda mavjudligini tekshiradi. `O(1)`.
  bool containsVertex(String vertex) => _adjacency.containsKey(vertex);

  /// [vertex] ning chiquvchi qirralari (noma'lum bo'lsa bo'sh). `O(1)`.
  List<Edge> neighbours(String vertex) =>
      List<Edge>.unmodifiable(_adjacency[vertex] ?? const []);

  /// Grafdagi barcha yo'nalishli qirralar. `O(E)`.
  List<Edge> get edges => [
        for (final list in _adjacency.values) ...list,
      ];

  /// Har bir yo'nalishsiz aloqa bir marta (pastroq endpoint id birinchi),
  /// Kruskal/Prim uchun mos. `O(E)`.
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

  /// Barcha tepalar va qirralarni olib tashlaydi. `O(1)`.
  void clear() => _adjacency.clear();
}
