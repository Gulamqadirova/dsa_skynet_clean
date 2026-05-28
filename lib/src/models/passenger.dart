/// Ro'yxatdan o'tish ustuvorligini belgilovchi sodiqlik darajasi.
/// Yuqori [rank] maks-heap ustuvorlik navbati tomonidan birinchi xizmat qilinadi.
enum TicketTier {
  platinum('Platinum', 4),
  gold('Gold', 3),
  silver('Silver', 2),
  economy('Economy', 1);

  const TicketTier(this.label, this.rank);

  final String label;
  final int rank;
}

/// Tizim bo'ylab noyob [pnr] (Yo'lovchi Nomi Yozuvi) bilan kalitlangan yo'lovchi.
class Passenger {
  /// Yo'lovchi Nomi Yozuvi — xesh-jadvalda `O(1)` olish uchun kalit.
  final String pnr;
  final String name;
  final TicketTier tier;

  /// Ustuvorlik tenglashlarini hal qilish uchun monoton kelish tartibi (FIFO darajasida).
  final int arrivalOrder;

  const Passenger({
    required this.pnr,
    required this.name,
    required this.tier,
    this.arrivalOrder = 0,
  });

  Passenger copyWith({int? arrivalOrder}) => Passenger(
        pnr: pnr,
        name: name,
        tier: tier,
        arrivalOrder: arrivalOrder ?? this.arrivalOrder,
      );

  @override
  String toString() => '$name [$pnr] (${tier.label})';
}
