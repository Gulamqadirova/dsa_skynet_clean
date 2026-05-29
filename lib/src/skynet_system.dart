import 'data/sample_data.dart';
import 'models/passenger.dart';
import 'services/analytics_service.dart';
import 'services/boarding_service.dart';
import 'services/checkin_service.dart';
import 'services/network_service.dart';
import 'services/rerouting_service.dart';
import 'services/search_service.dart';
class SkyNetSystem {
  final NetworkService network = NetworkService();
  final CheckInService checkIn = CheckInService();
  final BoardingService boarding = BoardingService();
  final SearchService search = SearchService();
  final AnalyticsService analytics = AnalyticsService();
  late final ReroutingService rerouting = ReroutingService(network);

  SkyNetSystem();

  factory SkyNetSystem.seeded() {
    final system = SkyNetSystem();
    system.loadSampleData();
    return system;
  }

  void loadSampleData() {
    for (final airport in SampleData.airports) {
      network.addAirport(airport);
    }
    for (final (from, to, cost, dist, time) in SampleData.flights) {
      network.addFlight(
        from: from,
        to: to,
        cost: cost,
        distanceKm: dist,
        timeMinutes: time,
      );
    }
    for (final flight in SampleData.schedule) {
      search.indexFlight(flight);
    }
    for (final passenger in SampleData.passengers) {
      search.registerProfile(passenger);
      checkIn.checkIn(passenger);
    }
  }
  List<Passenger> get manifest => search.allProfiles;
}
