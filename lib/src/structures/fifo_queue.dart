class FifoQueue<T> {
  static const int _initialCapacity = 8;

  List<T?> _buffer =
      List<T?>.filled(_initialCapacity, null, growable: false);
  int _head = 0;
  int _count = 0;
  int get length => _count;
  bool get isEmpty => _count == 0;
  bool get isNotEmpty => _count != 0;

  void enqueue(T value) {
    if (_count == _buffer.length) _grow();
    final tail = (_head + _count) % _buffer.length;
    _buffer[tail] = value;
    _count++;
  }
  T dequeue() {
    if (_count == 0) {
      throw StateError('dequeue() bo\'sh navbatda chaqirildi');
    }
    final value = _buffer[_head] as T;
    _buffer[_head] = null;
    _head = (_head + 1) % _buffer.length;
    _count--;
    return value;
  }


  T front() {
    if (_count == 0) {
      throw StateError('front() bo\'sh navbatda chaqirildi');
    }
    return _buffer[_head] as T;
  }

  List<T> toListFrontToRear() => List<T>.generate(
        _count,
        (i) => _buffer[(_head + i) % _buffer.length] as T,
        growable: false,
      );

  void clear() {
    _buffer = List<T?>.filled(_initialCapacity, null, growable: false);
    _head = 0;
    _count = 0;
  }

  void _grow() {
    final next =
        List<T?>.filled(_buffer.length * 2, null, growable: false);
    for (var i = 0; i < _count; i++) {
      next[i] = _buffer[(_head + i) % _buffer.length];
    }
    _buffer = next;
    _head = 0;
  }
}
