/// Ikkilik **Maks-Heap** asosidagi Ustuvorlik Navbati.
///
/// Eng yuqori ustuvorlikdagi element — kiritilgan [compare] funksiyasi
/// tomonidan belgilangan — har doim birinchi qaytariladi.
/// `compare(a, b)` musbat son qaytarsa "a ning ustuvorligi b dan yuqori" degani.
///
/// ## Nima uchun heap?
/// Saralangan ro'yxat `O(1)` peek beradi, lekin `O(n)` kiritish;
/// saralanmagan ro'yxat `O(1)` kiritish, lekin `O(n)` chiqarish.
/// Ikkilik heap ikkalasini `O(log n)` da muvozanatlaydi.
///
/// | Operatsiya  | Murakkablik |
/// |-------------|-------------|
/// | `peek`      | `O(1)`      |
/// | `insert`    | `O(log n)`  |
/// | `removeMax` | `O(log n)`  |
class PriorityQueue<T> {
  final int Function(T a, T b) _compare;
  final List<_Entry<T>> _heap = [];
  int _sequence = 0;

  /// [compare] bilan tartiblanadigan maks-heap yaratadi.
  PriorityQueue(int Function(T a, T b) compare) : _compare = compare;

  /// Navbatdagi elementlar soni. `O(1)`.
  int get length => _heap.length;

  /// Navbat bo'shligini tekshiradi. `O(1)`.
  bool get isEmpty => _heap.isEmpty;

  /// Navbatda kamida bitta element borligini tekshiradi. `O(1)`.
  bool get isNotEmpty => _heap.isNotEmpty;

  /// [value] ni kiritadi va to'g'ri joyga ko'taradi. `O(log n)`.
  void insert(T value) {
    _heap.add(_Entry<T>(value, _sequence++));
    _siftUp(_heap.length - 1);
  }

  /// Olib tashlamasdan eng yuqori ustuvorlikdagi elementni qaytaradi. `O(1)`.
  ///
  /// Navbat bo'sh bo'lsa [StateError] chiqaradi.
  T peek() {
    if (_heap.isEmpty) {
      throw StateError('peek() bo\'sh ustuvorlik navbatida chaqirildi');
    }
    return _heap.first.value;
  }

  /// Eng yuqori ustuvorlikdagi elementni olib tashlaydi va qaytaradi. `O(log n)`.
  ///
  /// Navbat bo'sh bo'lsa [StateError] chiqaradi.
  T removeMax() {
    if (_heap.isEmpty) {
      throw StateError('removeMax() bo\'sh ustuvorlik navbatida chaqirildi');
    }
    final top = _heap.first.value;
    final last = _heap.removeLast();
    if (_heap.isNotEmpty) {
      _heap[0] = last;
      _siftDown(0);
    }
    return top;
  }

  /// Ko'rsatish uchun ustuvorlik tartibidagi snapshot (eng yuquri birinchi). `O(n log n)`.
  List<T> toOrderedList() {
    final copy = List<_Entry<T>>.of(_heap)..sort(_entryCompare);
    return copy.map((e) => e.value).toList(growable: false);
  }

  /// Barcha elementlarni olib tashlaydi. `O(1)`.
  void clear() {
    _heap.clear();
    _sequence = 0;
  }

  int _entryCompare(_Entry<T> a, _Entry<T> b) {
    final byPriority = _compare(b.value, a.value); // kamayish tartibida
    if (byPriority != 0) return byPriority;
    return a.sequence.compareTo(b.sequence); // tenglashda avvalroq kelgan birinchi
  }

  bool _higher(int i, int j) => _entryCompare(_heap[i], _heap[j]) < 0;

  void _siftUp(int index) {
    var child = index;
    while (child > 0) {
      final parent = (child - 1) >> 1;
      if (!_higher(child, parent)) break;
      _swap(child, parent);
      child = parent;
    }
  }

  void _siftDown(int index) {
    final n = _heap.length;
    var parent = index;
    while (true) {
      final left = 2 * parent + 1;
      final right = left + 1;
      var best = parent;
      if (left < n && _higher(left, best)) best = left;
      if (right < n && _higher(right, best)) best = right;
      if (best == parent) break;
      _swap(parent, best);
      parent = best;
    }
  }

  void _swap(int i, int j) {
    final tmp = _heap[i];
    _heap[i] = _heap[j];
    _heap[j] = tmp;
  }
}

class _Entry<T> {
  final T value;
  final int sequence;
  const _Entry(this.value, this.sequence);
}
