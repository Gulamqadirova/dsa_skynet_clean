import '../models/passenger.dart';
import '../structures/priority_queue.dart';

/// Faza 2a — Maks-heap [PriorityQueue] tomonidan ta'minlangan aqlli ro'yxatdan o'tish stoli.
///
/// Yo'lovchilar [TicketTier] bo'yicha xizmat qilinadi (Platinum birinchi), darajadagi
/// tenglashlar kelish tartibiga qaytadi — oldinroq kelgan Gold Platinum kabi
/// keyinroq kelgan Gold dan oldin xizmat qilinadi. Heap yashirin;
/// chaqiruvchilar faqat [checkIn] va [serveNext] ni chaqiradi.
class CheckInService {
  final PriorityQueue<Passenger> _queue;
  int _arrivalCounter = 0;

  CheckInService()
      : _queue = PriorityQueue<Passenger>((a, b) {
          final byTier = a.tier.rank.compareTo(b.tier.rank);
          if (byTier != 0) return byTier; // yuqori daraja ⇒ yuqori ustuvorlik.
          // Darajada tenglashda oldinroq kelgan keyinroq kelgandan ustun.
          return b.arrivalOrder.compareTo(a.arrivalOrder);
        });

  /// Kutayotgan yo'lovchilar soni. `O(1)`.
  int get waiting => _queue.length;

  bool get isEmpty => _queue.isEmpty;

  bool get isNotEmpty => _queue.isNotEmpty;

  /// [passenger] ni stolga qo'shadi, kelish tartibini belgilaydi. `O(log n)`.
  void checkIn(Passenger passenger) {
    _queue.insert(passenger.copyWith(arrivalOrder: _arrivalCounter++));
  }

  /// Olib tashlamasdan xizmat qilinadigan keyingi yo'lovchi. `O(1)`.
  ///
  /// Stol bo'sh bo'lsa [StateError] chiqaradi.
  Passenger peekNext() => _queue.peek();

  /// Eng yuqori ustuvorlikdagi yo'lovchiga xizmat qiladi (olib tashlaydi va qaytaradi). `O(log n)`.
  ///
  /// Stol bo'sh bo'lsa [StateError] chiqaradi.
  Passenger serveNext() => _queue.removeMax();

  /// Ko'rsatish uchun ustuvorlik tartibidagi snapshot (eng yuquri birinchi). `O(n log n)`.
  List<Passenger> get pendingOrder => _queue.toOrderedList();

  void clear() {
    _queue.clear();
    _arrivalCounter = 0;
  }
}
