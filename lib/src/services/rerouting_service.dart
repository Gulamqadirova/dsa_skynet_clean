import '../algorithms/rerouting.dart';
import '../structures/edge.dart';
import 'network_service.dart';

/// Faza 5 — Rekursiv orqaga qaytish orqali favqulodda rejalashtirish.
///
/// Uchish grafiga ega [NetworkService] ga delegatsiya qiladi, shuning uchun
/// topologiya har doim dolzarb va graf bir chegara ortida kapsullangan.
class ReroutingService {
  final NetworkService _network;

  ReroutingService(this._network);

  /// [closed] aeroprotlaridan qochadigan [from] dan [to] gacha barcha yashash
  /// muqobil marshrutlar, eng yaxshi (eng past og'irlik) birinchi.
  List<AlternativeRoute> reroute({
    required String from,
    required String to,
    Set<String> closed = const {},
    RouteMetric metric = RouteMetric.cost,
    int maxHops = 6,
    int maxRoutes = 25,
  }) =>
      _network.alternativeRoutes(
        from: from,
        to: to,
        closed: closed,
        metric: metric,
        maxHops: maxHops,
        maxRoutes: maxRoutes,
      );
}
