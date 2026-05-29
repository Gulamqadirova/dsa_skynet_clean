class HashTable<K, V> {
  static const int _initialCapacity = 16;
  static const double _maxLoadFactor = 0.75;

  List<List<_Pair<K, V>>> _buckets;
  int _size = 0;

  HashTable()
      : _buckets = List.generate(
          _initialCapacity,
          (_) => <_Pair<K, V>>[],
          growable: false,
        );

  int get length => _size;
  bool get isEmpty => _size == 0;
  double get loadFactor => _size / _buckets.length;
  int get bucketCount => _buckets.length;

  void put(K key, V value) {
    final chain = _chainFor(key);
    for (final pair in chain) {
      if (pair.key == key) {
        pair.value = value;
        return;
      }
    }
    chain.add(_Pair<K, V>(key, value));
    _size++;
    if (loadFactor > _maxLoadFactor) _resize();
  }

  V? get(K key) {
    for (final pair in _chainFor(key)) {
      if (pair.key == key) return pair.value;
    }
    return null;
  }

  bool containsKey(K key) {
    for (final pair in _chainFor(key)) {
      if (pair.key == key) return true;
    }
    return false;
  }

  V? remove(K key) {
    final chain = _chainFor(key);
    for (var i = 0; i < chain.length; i++) {
      if (chain[i].key == key) {
        final removed = chain.removeAt(i);
        _size--;
        return removed.value;
      }
    }
    return null;
  }

  List<V> values() => [
        for (final chain in _buckets)
          for (final pair in chain) pair.value,
      ];

  int get longestChain =>
      _buckets.fold(0, (m, c) => c.length > m ? c.length : m);

  void clear() {
    _buckets = List.generate(
      _initialCapacity,
      (_) => <_Pair<K, V>>[],
      growable: false,
    );
    _size = 0;
  }

  List<_Pair<K, V>> _chainFor(K key) => _buckets[_indexFor(key)];

  int _indexFor(K key) {
    return (key.hashCode & 0x7fffffff) % _buckets.length;
  }

  void _resize() {
    final old = _buckets;
    _buckets = List.generate(
      old.length * 2,
      (_) => <_Pair<K, V>>[],
      growable: false,
    );
    for (final chain in old) {
      for (final pair in chain) {
        _buckets[_indexFor(pair.key)].add(pair);
      }
    }
  }
}

class _Pair<K, V> {
  final K key;
  V value;
  _Pair(this.key, this.value);
}
