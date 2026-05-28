import '../structures/graph.dart';

/// Orqaga qaytish qidiruvida topilgan bir muqobil yo'l.
class AlternativeRoute {
  /// Tartib bo'yicha ko'rilgan aeroportlar, manba birinchi.
  final List<String> path;

  /// Tartib bo'yicha bosib o'tilgan qirralar.
  final List<Edge> edges;

  /// Tanlangan metrika bo'yicha umumiy og'irlik.
  final double totalWeight;

  const AlternativeRoute({
    required this.path,
    required this.edges,
    required this.totalWeight,
  });

  int get hops => edges.length;
}

/// Favqulodda rejalashtirish uchun **rekursiv orqaga qaytish** yo'l kashfiyotchisi.
///
/// Hub yopilganda, bu [blocked] aeroprotlardan qochib [source] dan [target] gacha
/// har bir *oddiy* yo'lni (takrorlanmagan aeroport) sanab chiqadi, so'ngra ularni
/// umumiy og'irlik bo'yicha tartiblab qaytaradi.
///
/// Qidiruv daraxti eng yomon holatda eksponentsial (`O(V!)`-ish),
/// bu "barcha yo'llarni o'rganish" uchun tug'ma. Ikki amaliy chegara uni
/// real tarmoqlarda boshqariladigan qiladi:
///   * [maxHops] makul oyoqlar sonidan uzunroq yo'llarni kesib tashlaydi;
///   * [maxRoutes] yetarli muqobillar topilgach to'xtatadi.
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
    return const []; // uchlari o'zi ishlatib bo'lmaydi.
  }

  final results = <AlternativeRoute>[];
  final visited = <String>{source};
  final pathStack = <String>[source];
  final edgeStack = <Edge>[];

  void backtrack(String current, double weightSoFar) {
    if (results.length >= maxRoutes) return; // yetarli muqobillar topildi.
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
    if (edgeStack.length >= maxHops) return; // chuqurlik chegarasi.

    for (final edge in graph.neighbours(current)) {
      final next = edge.to;
      if (blocked.contains(next) || visited.contains(next)) continue;

      // tanlash
      visited.add(next);
      pathStack.add(next);
      edgeStack.add(edge);

      backtrack(next, weightSoFar + metric.weightOf(edge));

      // qaytarish (orqaga qaytishning asosiy qadami)
      visited.remove(next);
      pathStack.removeLast();
      edgeStack.removeLast();
    }
  }

  backtrack(source, 0);
  results.sort((a, b) => a.totalWeight.compareTo(b.totalWeight));
  return results;
}
