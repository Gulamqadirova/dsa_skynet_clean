import '../models/passenger.dart';
import '../structures/fifo_queue.dart';
import '../structures/stack.dart';

/// Yuk bo'limidagi bir dona bagaj.
class Luggage {
  final String tag;
  final String owner;
  const Luggage(this.tag, this.owner);

  @override
  String toString() => '$tag ($owner)';
}

/// Faza 2b — Bortga o'tirish va yuk logistikasi.
///
/// * **Bortga o'tirish eshigi** FIFO [FifoQueue]: yo'lovchilar kelish tartibida
///   bortga o'tiradi.
/// * **Yuk bo'limi** LIFO [Stack]: oxirgi yuklangan sumka birinchi tushiriladi,
///   bu yuk bo'limining qanday to'ldirilishi va bo'shatilishini to'liq aks ettiradi.
class BoardingService {
  final FifoQueue<Passenger> _gate = FifoQueue<Passenger>();
  final Stack<Luggage> _hold = Stack<Luggage>();

  // ---- Bortga o'tirish eshigi (FIFO) ----------------------------------------

  int get queueLength => _gate.length;
  bool get gateIsEmpty => _gate.isEmpty;

  /// Yo'lovchi navbat oxiriga qo'shiladi. `O(1)`.
  void joinQueue(Passenger passenger) => _gate.enqueue(passenger);

  /// Navbat boshidagi keyingi yo'lovchi bortga o'tiradi. `O(1)`.
  ///
  /// Hech kim kutmayotgan bo'lsa [StateError] chiqaradi.
  Passenger boardNext() => _gate.dequeue();

  /// Bortga o'tirish tartibining old-dan-orqa snapshoti. `O(n)`.
  List<Passenger> get boardingOrder => _gate.toListFrontToRear();

  // ---- Yuk bo'limi (LIFO) ---------------------------------------------------

  int get holdSize => _hold.length;
  bool get holdIsEmpty => _hold.isEmpty;

  /// Sumkani yuk bo'limi tepasiga yuklaydi. `O(1)`.
  void loadLuggage(Luggage item) => _hold.push(item);

  /// Oxirgi yuklangan sumkani tushiradi. `O(1)`.
  ///
  /// Yuk bo'limi bo'sh bo'lsa [StateError] chiqaradi.
  Luggage unloadLuggage() => _hold.pop();

  /// Yuk bo'limining tepa-dan-pastga snapshoti (keyingi tushiriladigan birinchi). `O(n)`.
  List<Luggage> get holdContents => _hold.toListTopToBottom();

  void clear() {
    _gate.clear();
    _hold.clear();
  }
}
