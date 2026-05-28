import '../algorithms/sorting.dart';
import '../algorithms/string_matching.dart';
import '../models/flight.dart';
import '../models/passenger.dart';

/// Kunlik jadval saralash uchun kalit.
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

/// Bir xil ma'lumotlarni ikkala algoritm bilan saralashning yonma-yon natijasi.
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

/// KMP tomonidan manifest ichida aniqlangan bir yo'lovchi.
class ManifestMatch {
  final Passenger passenger;
  final int index; // manifest qatoridagi moslikning ofseti.
  const ManifestMatch(this.passenger, this.index);
}

/// Faza 4 — Ma'lumotlar analitikasi va qatorni qayta ishlash.
class AnalyticsService {
  /// [flights] ni [key] bo'yicha QuickSort ham MergeSort bilan saralaydi va
  /// taqqoslash uchun metrikalarini qaytaradi. Ikkalasi ham bir xil tartiblarni beradi;
  /// faqat asboblar farq qiladi.
  SortComparison compareSorts(List<Flight> flights, FlightSortKey key) {
    final cmp = key.comparator;
    final quick = quickSort(flights, cmp);
    final merge = mergeSort(flights, cmp);
    return SortComparison(
      sorted: merge.sorted, // ko'rsatish uchun barqaror tartib.
      quick: quick.stats,
      merge: merge.stats,
    );
  }

  /// [query] ni o'z ichiga olgan ismli yo'lovchilarni manifest bo'yicha KMP yordamida topadi.
  /// Mosliklarni manifest tartibida qaytaradi.
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
