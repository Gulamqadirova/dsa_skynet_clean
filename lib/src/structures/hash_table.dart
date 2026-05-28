/// Alohida zanjir bilan [K] kalitlarini [V] qiymatlarga xaritalovchi **Xesh Jadval**.
///
/// Vaqt-xotira almashuvini aniq ko'rsatish uchun birinchi tamoyillardan qurilgan:
/// chelaklar [_maxLoadFactor] dan past saqlanadi va bu chegaradan oshganda
/// massiv ikki barobar kengayadi. Ko'proq chelak ⇒ qisqaroq zanjirlar ⇒
/// tezroq qidirish, xotira hisobiga.
///
/// | Operatsiya | O'rtacha    | Eng yomon holat |
/// |------------|-------------|-----------------|
/// | `put`      | `O(1)`      | `O(n)`          |
/// | `get`      | `O(1)`      | `O(n)`          |
/// | `remove`   | `O(1)`      | `O(n)`          |
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

  /// Kalit/qiymat yozuvlari soni. `O(1)`.
  int get length => _size;

  /// Jadval bo'shligini tekshiradi. `O(1)`.
  bool get isEmpty => _size == 0;

  /// Yozuvlarning chelakka nisbati — "to'liqlik" jonli ko'rinishi. `O(1)`.
  double get loadFactor => _size / _buckets.length;

  /// Hozir ajratilgan chelaklar soni. `O(1)`.
  int get bucketCount => _buckets.length;

  /// [key] uchun qiymatni kiritadi yoki yangilaydi. O'rtacha `O(1)`.
  void put(K key, V value) {
    final chain = _chainFor(key);
    for (final pair in chain) {
      if (pair.key == key) {
        pair.value = value; // o'rnida yangilash.
        return;
      }
    }
    chain.add(_Pair<K, V>(key, value));
    _size++;
    if (loadFactor > _maxLoadFactor) _resize();
  }

  /// [key] uchun qiymatni qaytaradi, yoki yo'q bo'lsa `null`. O'rtacha `O(1)`.
  V? get(K key) {
    for (final pair in _chainFor(key)) {
      if (pair.key == key) return pair.value;
    }
    return null;
  }

  /// [key] mavjudligini tekshiradi. O'rtacha `O(1)`.
  bool containsKey(K key) {
    for (final pair in _chainFor(key)) {
      if (pair.key == key) return true;
    }
    return false;
  }

  /// [key] ni olib tashlaydi va olib tashlangan qiymatni yoki `null` qaytaradi. O'rtacha `O(1)`.
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

  /// Tartibsiz barcha qiymatlar. `O(n)`.
  List<V> values() => [
        for (final chain in _buckets)
          for (final pair in chain) pair.value,
      ];

  /// Eng uzun zanjir uzunligi — to'qnashuv taqsimotini diagnostika qilish uchun. `O(n)`.
  int get longestChain =>
      _buckets.fold(0, (m, c) => c.length > m ? c.length : m);

  /// Jadvalni tozalaydi. `O(1)`.
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
    // Manfiy xeshlar uchun modul to'g'ri oralig'da bo'lishi uchun belgini o'chiradi.
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
