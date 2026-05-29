import '../models/passenger.dart';
import '../structures/fifo_queue.dart';
import '../structures/stack.dart';

class Luggage {
  final String tag;
  final String owner;
  const Luggage(this.tag, this.owner);

  @override
  String toString() => '$tag ($owner)';
}

class BoardingService {
  final FifoQueue<Passenger> _gate = FifoQueue<Passenger>();
  final Stack<Luggage> _hold = Stack<Luggage>();
  int get queueLength => _gate.length;
  bool get gateIsEmpty => _gate.isEmpty;
  void joinQueue(Passenger passenger) => _gate.enqueue(passenger);
  Passenger boardNext() => _gate.dequeue();
  List<Passenger> get boardingOrder => _gate.toListFrontToRear();
  int get holdSize => _hold.length;
  bool get holdIsEmpty => _hold.isEmpty;
  void loadLuggage(Luggage item) => _hold.push(item);
  Luggage unloadLuggage() => _hold.pop();
  List<Luggage> get holdContents => _hold.toListTopToBottom();

  void clear() {
    _gate.clear();
    _hold.clear();
  }
}
