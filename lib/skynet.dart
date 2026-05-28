/// SkyNet — Global Aviatsiya Logistikasi va Boshqaruv Tizimi.
///
/// Ommaviy API yuzasi: domen modellari, faza xizmatlari va
/// [SkyNetSystem] fasadi. Konkret ma'lumotlar tuzilmalari va algoritmlar
/// `lib/src/` ostida joylashgan va birlik testlash uchun ataylab
/// erishish mumkin, ilovaning o'zi esa faqat bu yerda eksport qilingan
/// xizmatlarni iste'mol qiladi.
library;

export 'src/algorithms/dijkstra.dart' show ShortestPath, dijkstra;
export 'src/algorithms/minimum_spanning_tree.dart'
    show SpanningTree, kruskalMst, primMst;
export 'src/algorithms/rerouting.dart'
    show AlternativeRoute, findAlternativeRoutes;
export 'src/algorithms/sorting.dart'
    show SortResult, SortStats, mergeSort, quickSort;
export 'src/algorithms/string_matching.dart'
    show buildLpsTable, kmpContains, kmpSearch;
export 'src/models/airport.dart';
export 'src/models/flight.dart';
export 'src/models/passenger.dart';
export 'src/services/analytics_service.dart';
export 'src/services/boarding_service.dart';
export 'src/services/checkin_service.dart';
export 'src/services/network_service.dart';
export 'src/services/rerouting_service.dart';
export 'src/services/search_service.dart';
export 'src/skynet_system.dart';
export 'src/structures/avl_tree.dart';
export 'src/structures/edge.dart';
export 'src/structures/fifo_queue.dart';
export 'src/structures/graph.dart';
export 'src/structures/hash_table.dart';
export 'src/structures/priority_queue.dart';
export 'src/structures/stack.dart';
