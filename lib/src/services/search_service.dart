import '../models/flight.dart';
import '../models/passenger.dart';
import '../structures/avl_tree.dart';
import '../structures/hash_table.dart';

/// Faza 3 — Yuqori tezlikdagi qidiruv va ma'lumotlarni olish.
///
/// * Reys **narxlari** narx bo'yicha kalitlangan [AvlTree] da joylashgan,
///   bu `O(log n + k)` diapazon so'rovlarini beradi ("\$200 dan \$500 gacha reyslar").
/// * Yo'lovchi **profillari** PNR bo'yicha kalitlangan [HashTable] da joylashgan,
///   bu xavfsizlik tekshiruvlari uchun `O(1)` qidiruvlarni beradi.
class SearchService {
  final AvlTree<double, Flight> _priceIndex =
      AvlTree<double, Flight>((a, b) => a.compareTo(b));
  final HashTable<String, Passenger> _profiles = HashTable<String, Passenger>();

  // ---- Narx indeksi (AVL) ---------------------------------------------------

  /// [flight] ni narxi bo'yicha indekslaydi. `O(log n)`.
  void indexFlight(Flight flight) => _priceIndex.insert(flight.price, flight);

  /// Narxi `[min, max]` oralig'ida bo'lgan barcha indekslangan reyslar, o'suvchi tartibda. `O(log n + k)`.
  List<Flight> flightsInPriceRange(double min, double max) =>
      _priceIndex.rangeQuery(min, max);

  /// O'suvchi narx tartibidagi barcha indekslangan reyslar. `O(n)`.
  List<Flight> get flightsByPrice =>
      _priceIndex.inOrder().map((e) => e.value).toList(growable: false);

  int get indexedFlightCount => _priceIndex.length;

  /// Muvozanatlangan daraxtning hozirgi balandligi — `O(log n)` chegarasining dalili.
  int get priceIndexHeight => _priceIndex.height;

  // ---- Profil do'koni (Xesh jadval) ----------------------------------------

  /// PNR bo'yicha yo'lovchi profilini saqlaydi yoki yangilaydi. `O(1)` o'rtacha.
  void registerProfile(Passenger passenger) =>
      _profiles.put(passenger.pnr, passenger);

  /// PNR bo'yicha profilni oladi, yoki noma'lum bo'lsa `null`. `O(1)` o'rtacha.
  Passenger? profileByPnr(String pnr) => _profiles.get(pnr);

  bool hasProfile(String pnr) => _profiles.containsKey(pnr);

  int get profileCount => _profiles.length;

  /// Profil jadvalining jonli yuklama koeffitsienti — tezlik-xotira murosasini
  /// ko'rsatish uchun baholash ko'rinishida ishlatiladi.
  double get profileLoadFactor => _profiles.loadFactor;

  /// Eng uzun to'qnashuv zanjiri — xesh taqsimot sifatini diagnostika qilish uchun.
  int get profileLongestChain => _profiles.longestChain;

  int get profileBucketCount => _profiles.bucketCount;

  /// Barcha saqlangan profiller (tartibsiz). `O(n)`.
  List<Passenger> get allProfiles => _profiles.values();
}
