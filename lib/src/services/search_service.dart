import '../models/flight.dart';
import '../models/passenger.dart';
import '../structures/avl_tree.dart';
import '../structures/hash_table.dart';

class SearchService {
  final AvlTree<double, Flight> _priceIndex =
      AvlTree<double, Flight>((a, b) => a.compareTo(b));
  final HashTable<String, Passenger> _profiles = HashTable<String, Passenger>();
  void indexFlight(Flight flight) => _priceIndex.insert(flight.price, flight);

  List<Flight> flightsInPriceRange(double min, double max) =>
      _priceIndex.rangeQuery(min, max);
  List<Flight> get flightsByPrice =>
      _priceIndex.inOrder().map((e) => e.value).toList(growable: false);

  int get indexedFlightCount => _priceIndex.length;
  int get priceIndexHeight => _priceIndex.height;


  void registerProfile(Passenger passenger) =>
      _profiles.put(passenger.pnr, passenger);
  Passenger? profileByPnr(String pnr) => _profiles.get(pnr);

  bool hasProfile(String pnr) => _profiles.containsKey(pnr);

  int get profileCount => _profiles.length;
  double get profileLoadFactor => _profiles.loadFactor;
  int get profileLongestChain => _profiles.longestChain;
  int get profileBucketCount => _profiles.bucketCount;
  List<Passenger> get allProfiles => _profiles.values();
}
