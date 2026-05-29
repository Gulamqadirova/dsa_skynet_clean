class Stack<T> {
  final List<T> _items = [];
  int get length => _items.length;
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;
  void push(T value) => _items.add(value);
  T pop() {
    if (_items.isEmpty) {
      throw StateError('pop() bo\'sh stekda chaqirildi');
    }
    return _items.removeLast();
  }
  T peek() {
    if (_items.isEmpty) {
      throw StateError('peek() bo\'sh stekda chaqirildi');
    }
    return _items.last;
  }
  List<T> toListTopToBottom() => _items.reversed.toList(growable: false);
  void clear() => _items.clear();
}
