class PriorityQueue<T> {
  final int Function(T a, T b) _compare;
  final List<_Entry<T>> _heap = [];
  int _sequence = 0;

  PriorityQueue(int Function(T a, T b) compare) : _compare = compare;

  int get length => _heap.length;
  bool get isEmpty => _heap.isEmpty;
  bool get isNotEmpty => _heap.isNotEmpty;

  void insert(T value) {
    _heap.add(_Entry<T>(value, _sequence++));
    _siftUp(_heap.length - 1);
  }


  T peek() {
    if (_heap.isEmpty) {
      throw StateError('peek() bo\'sh ustuvorlik navbatida chaqirildi');
    }
    return _heap.first.value;
  }


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

  List<T> toOrderedList() {
    final copy = List<_Entry<T>>.of(_heap)..sort(_entryCompare);
    return copy.map((e) => e.value).toList(growable: false);
  }

  void clear() {
    _heap.clear();
    _sequence = 0;
  }

  int _entryCompare(_Entry<T> a, _Entry<T> b) {
    final byPriority = _compare(b.value, a.value);
    if (byPriority != 0) return byPriority;
    return a.sequence.compareTo(b.sequence);
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
