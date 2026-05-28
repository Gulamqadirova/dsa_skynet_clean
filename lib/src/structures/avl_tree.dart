/// [K] tipidagi kalit va [V] tipidagi qiymatni tartiblaydigan o'z-o'zini
/// muvozanatlagan **AVL Daraxti**.
///
/// Oddiy Ikkilik Qidiruv Daraxti saralangan kiritishda ro'yxatga aylanadi
/// (`O(n)`) — bu aviatsiya narxlari oqimidagi kirish namunasi. AVL invarianti
/// har bir pastki daraxt bolalari balandligini 1 ichida saqlaydi, bu
/// `insert`, `search` va `rangeQuery` da `O(log n)` ni kafolatlaydi.
///
/// Bir xil kalitga bir nechta qiymat ega bo'lishi mumkin (masalan, bir xil
/// narxdagi bir nechta reys), shuning uchun har bir tugun qiymatlar *chelagi* saqlaydi.
///
/// | Operatsiya    | Murakkablik    |
/// |---------------|----------------|
/// | `insert`      | `O(log n)`     |
/// | `search`      | `O(log n)`     |
/// | `rangeQuery`  | `O(log n + k)` |
/// | `inOrder`     | `O(n)`         |
class AvlTree<K, V> {
  final int Function(K a, K b) _compare;
  _Node<K, V>? _root;
  int _size = 0;

  /// [compare] tartibida daraxt yaratadi.
  AvlTree(int Function(K a, K b) compare) : _compare = compare;

  /// Saqlangan qiymatlar umumiy soni (alohida kalitlar emas). `O(1)`.
  int get length => _size;

  /// Daraxt qiymatlar mavjud emasligini tekshiradi. `O(1)`.
  bool get isEmpty => _size == 0;

  /// Daraxt balandligi; bo'sh daraxt balandligi 0. `O(1)`.
  int get height => _height(_root);

  /// [key] ostiga [value] kiritadi, qaytib kelayotganda muvozanatlaydi. `O(log n)`.
  void insert(K key, V value) {
    _root = _insert(_root, key, value);
    _size++;
  }

  /// [key] ostida saqlangan barcha qiymatlarni qaytaradi, yoki bo'sh ro'yxat. `O(log n)`.
  List<V> search(K key) {
    var node = _root;
    while (node != null) {
      final cmp = _compare(key, node.key);
      if (cmp == 0) return List<V>.unmodifiable(node.values);
      node = cmp < 0 ? node.left : node.right;
    }
    return const [];
  }

  /// Kaliti `[low, high]` oralig'ida bo'lgan barcha qiymatlarni o'suvchi tartibda qaytaradi.
  /// Faqat tegishli pastki daraxt ko'riladi: `k` mos uchun narxi `O(log n + k)`.
  List<V> rangeQuery(K low, K high) {
    final out = <V>[];
    _range(_root, low, high, out);
    return out;
  }

  /// `(key, value)` juftliklari o'suvchi tartibda. `O(n)`.
  List<({K key, V value})> inOrder() {
    final out = <({K key, V value})>[];
    _inOrder(_root, out);
    return out;
  }

  /// Daraxt tarkibini tozalaydi. `O(1)`.
  void clear() {
    _root = null;
    _size = 0;
  }

  _Node<K, V> _insert(_Node<K, V>? node, K key, V value) {
    if (node == null) return _Node<K, V>(key, value);
    final cmp = _compare(key, node.key);
    if (cmp == 0) {
      node.values.add(value);
      return node; // tarkibiy o'zgarish yo'q.
    } else if (cmp < 0) {
      node.left = _insert(node.left, key, value);
    } else {
      node.right = _insert(node.right, key, value);
    }
    _update(node);
    return _rebalance(node);
  }

  void _range(_Node<K, V>? node, K low, K high, List<V> out) {
    if (node == null) return;
    final cmpLow = _compare(node.key, low);
    final cmpHigh = _compare(node.key, high);
    if (cmpLow > 0) _range(node.left, low, high, out);
    if (cmpLow >= 0 && cmpHigh <= 0) out.addAll(node.values);
    if (cmpHigh < 0) _range(node.right, low, high, out);
  }

  void _inOrder(_Node<K, V>? node, List<({K key, V value})> out) {
    if (node == null) return;
    _inOrder(node.left, out);
    for (final v in node.values) {
      out.add((key: node.key, value: v));
    }
    _inOrder(node.right, out);
  }

  // ---- Muvozanatlash primitivlari ------------------------------------------

  int _height(_Node<K, V>? node) => node?.height ?? 0;

  int _balanceFactor(_Node<K, V> node) =>
      _height(node.left) - _height(node.right);

  void _update(_Node<K, V> node) {
    final lh = _height(node.left);
    final rh = _height(node.right);
    node.height = 1 + (lh > rh ? lh : rh);
  }

  _Node<K, V> _rebalance(_Node<K, V> node) {
    final balance = _balanceFactor(node);
    if (balance > 1) {
      if (_balanceFactor(node.left!) < 0) {
        node.left = _rotateLeft(node.left!); // Chap-O'ng holat
      }
      return _rotateRight(node); // Chap-Chap holat
    }
    if (balance < -1) {
      if (_balanceFactor(node.right!) > 0) {
        node.right = _rotateRight(node.right!); // O'ng-Chap holat
      }
      return _rotateLeft(node); // O'ng-O'ng holat
    }
    return node;
  }

  _Node<K, V> _rotateRight(_Node<K, V> y) {
    final x = y.left!;
    y.left = x.right;
    x.right = y;
    _update(y);
    _update(x);
    return x;
  }

  _Node<K, V> _rotateLeft(_Node<K, V> x) {
    final y = x.right!;
    x.right = y.left;
    y.left = x;
    _update(x);
    _update(y);
    return y;
  }
}

class _Node<K, V> {
  final K key;
  final List<V> values;
  _Node<K, V>? left;
  _Node<K, V>? right;
  int height = 1;

  _Node(this.key, V value) : values = [value];
}
