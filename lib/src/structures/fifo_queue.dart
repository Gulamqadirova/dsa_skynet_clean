/// Birinchi-kirgan-birinchi-chiqadi (FIFO) Navbat abstrakt ma'lumotlar turi.
///
/// ## Formal ADT spetsifikatsiyasi
///
/// ```
/// ADT Queue<T>
///   konstruktorlar
///     new()              -> Queue<T>          // bo'sh navbat
///   operatsiyalar
///     enqueue(Queue<T>, T) -> Queue<T>        // orqaga qo'shish
///     dequeue(Queue<T>)    -> (T, Queue<T>)   // oldidan olib tashlash
///     front(Queue<T>)      -> T               // oldini ko'rish
///     isEmpty(Queue<T>)    -> bool
///     size(Queue<T>)       -> int
///   aksiomalar (barcha q: Queue<T>, x: T uchun)
///     isEmpty(new())                       = true
///     dequeue(enqueue(new(), x))           = (x, new())
///     // FIFO tartib: eng eski element har doim birinchi chiqadi.
///   oldindan shartlar
///     dequeue / front isEmpty(q) bo'lmashini talab qiladi
/// ```
///
/// Halqa bufer (doiraviy massiv) ustida amalga oshirilgan, shuning uchun
/// [enqueue] ham, [dequeue] ham amortizatsiyalangan `O(1)` — oddiy
/// `List.removeAt(0)` element siljishi tufayli har bir dequeue da `O(n)` bo'lardi.
/// Bufer to'lganda ikki barobar kengayadi.
class FifoQueue<T> {
  static const int _initialCapacity = 8;

  List<T?> _buffer =
      List<T?>.filled(_initialCapacity, null, growable: false);
  int _head = 0;
  int _count = 0;

  /// Navbatdagi elementlar soni. `O(1)`.
  int get length => _count;

  /// Navbat bo'shligini tekshiradi. `O(1)`.
  bool get isEmpty => _count == 0;

  /// Navbatda kamida bitta element borligini tekshiradi. `O(1)`.
  bool get isNotEmpty => _count != 0;

  /// [value] ni navbat orqasiga qo'shadi. Amortizatsiyalangan `O(1)`.
  void enqueue(T value) {
    if (_count == _buffer.length) _grow();
    final tail = (_head + _count) % _buffer.length;
    _buffer[tail] = value;
    _count++;
  }

  /// Old (eng eski) elementni olib tashlaydi va qaytaradi. `O(1)`.
  ///
  /// Navbat bo'sh bo'lsa [StateError] chiqaradi.
  T dequeue() {
    if (_count == 0) {
      throw StateError('dequeue() bo\'sh navbatda chaqirildi');
    }
    final value = _buffer[_head] as T;
    _buffer[_head] = null; // Axlat yig'uvchi uchun havolani bo'shatadi.
    _head = (_head + 1) % _buffer.length;
    _count--;
    return value;
  }

  /// Olib tashlamasdan old elementni qaytaradi. `O(1)`.
  ///
  /// Navbat bo'sh bo'lsa [StateError] chiqaradi.
  T front() {
    if (_count == 0) {
      throw StateError('front() bo\'sh navbatda chaqirildi');
    }
    return _buffer[_head] as T;
  }

  /// UI ga xavfsiz ko'rsatish uchun old-dan-orqa o'zgarmas snapshot. `O(n)`.
  List<T> toListFrontToRear() => List<T>.generate(
        _count,
        (i) => _buffer[(_head + i) % _buffer.length] as T,
        growable: false,
      );

  /// Barcha elementlarni olib tashlaydi. `O(1)`.
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
