import '../algorithms/sorting.dart';
import '../algorithms/string_matching.dart';
import '../models/flight.dart';
import '../models/passenger.dart';

enum FlightSortKey {
  departure('Jo\'nash vaqti'),
  fuelEfficiency('Yonilg\'i samaradorligi'),
  price('Narx');

  const FlightSortKey(this.label);
  final String label;

  Comparator<Flight> get comparator => switch (this) {
        FlightSortKey.departure => (a, b) =>
            a.departureMinutes.compareTo(b.departureMinutes),
        FlightSortKey.fuelEfficiency => (a, b) =>
            a.fuelEfficiency.compareTo(b.fuelEfficiency),
        FlightSortKey.price => (a, b) => a.price.compareTo(b.price),
      };
}

class SortComparison {
  final List<Flight> sorted;
  final SortStats quick;
  final SortStats merge;

  const SortComparison({
    required this.sorted,
    required this.quick,
    required this.merge,
  });
}

class ManifestMatch {
  final Passenger passenger;
  final int index;
  const ManifestMatch(this.passenger, this.index);
}

class AnalyticsService {
  SortComparison compareSorts(List<Flight> flights, FlightSortKey key) {
    final cmp = key.comparator;
    final quick = quickSort(flights, cmp);
    final merge = mergeSort(flights, cmp);
    return SortComparison(
      sorted: merge.sorted,
      quick: quick.stats,
      merge: merge.stats,
    );
  }

  List<ManifestMatch> searchManifest(
    List<Passenger> manifest,
    String query,
  ) {
    if (query.trim().isEmpty) return const [];
    final matches = <ManifestMatch>[];
    for (final p in manifest) {
      final hits = kmpSearch(p.name, query.trim());
      if (hits.isNotEmpty) matches.add(ManifestMatch(p, hits.first));
    }
    return matches;
  }
}
