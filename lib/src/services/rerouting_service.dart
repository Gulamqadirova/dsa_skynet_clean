import '../algorithms/rerouting.dart';
import '../structures/edge.dart';
import 'network_service.dart';
class ReroutingService {
  final NetworkService _network;

  ReroutingService(this._network);
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
