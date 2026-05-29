import '../models/passenger.dart';
import '../structures/priority_queue.dart';

class CheckInService {
  final PriorityQueue<Passenger> _queue;
  int _arrivalCounter = 0;

  CheckInService()
      : _queue = PriorityQueue<Passenger>((a, b) {
          final byTier = a.tier.rank.compareTo(b.tier.rank);
          if (byTier != 0) return byTier; .
          return b.arrivalOrder.compareTo(a.arrivalOrder);
        });

  int get waiting => _queue.length;
  bool get isEmpty => _queue.isEmpty;
  bool get isNotEmpty => _queue.isNotEmpty;
  void checkIn(Passenger passenger) {
    _queue.insert(passenger.copyWith(arrivalOrder: _arrivalCounter++));
  }
  Passenger peekNext() => _queue.peek();
  Passenger serveNext() => _queue.removeMax();
  List<Passenger> get pendingOrder => _queue.toOrderedList();

  void clear() {
    _queue.clear();
    _arrivalCounter = 0;
  }
}
