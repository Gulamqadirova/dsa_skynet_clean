/// Oxirgi-kirgan-birinchi-chiqadi (LIFO) Stack abstrakt ma'lumotlar turi.
///
/// ## Formal ADT spetsifikatsiyasi
///
/// ```
/// ADT Stack<T>
///   konstruktorlar
///     new()            -> Stack<T>            // bo'sh stek yaratadi
///   operatsiyalar
///     push(Stack<T>, T) -> Stack<T>           // yuqoriga element qo'shish
///     pop(Stack<T>)     -> (T, Stack<T>)      // yuqorini olib tashlash va qaytarish
///     peek(Stack<T>)    -> T                   // yuqoriga qarash, o'zgartirishsiz
///     isEmpty(Stack<T>) -> bool
///     size(Stack<T>)    -> int
///   aksiomalar (barcha s: Stack<T>, x: T uchun)
///     isEmpty(new())                = true
///     isEmpty(push(s, x))           = false
///     peek(push(s, x))              = x
///     pop(push(s, x))               = (x, s)
///   oldindan shartlar
///     pop / peek isEmpty(s) bo'lmashini talab qiladi
/// ```
///
/// Yagona ichki maydon [_items] shaxsiy: chaqiruvchilar hech qachon
/// zaxira ro'yxatiga erisha olmaydi — bu ma'lumotlarni yashirish mohiyati.
/// Har bir operatsiyaning amortizatsiya qilingan narxi `O(1)`.
class Stack<T> {
  final List<T> _items = [];

  /// Hozir saqlanayotgan elementlar soni. `O(1)`.
  int get length => _items.length;

  /// Stekda elementlar yo'qligini tekshiradi. `O(1)`.
  bool get isEmpty => _items.isEmpty;

  /// Stekda kamida bitta element borligini tekshiradi. `O(1)`.
  bool get isNotEmpty => _items.isNotEmpty;

  /// [value] ni stekning tepasiga qo'yadi. Amortizatsiyalangan `O(1)`.
  void push(T value) => _items.add(value);

  /// Yuqori elementni olib tashlaydi va qaytaradi. `O(1)`.
  ///
  /// Stek bo'sh bo'lsa [StateError] chiqaradi (oldindan shart buzilgan).
  T pop() {
    if (_items.isEmpty) {
      throw StateError('pop() bo\'sh stekda chaqirildi');
    }
    return _items.removeLast();
  }

  /// Yuqori elementni olib tashlamasdan qaytaradi. `O(1)`.
  ///
  /// Stek bo'sh bo'lsa [StateError] chiqaradi.
  T peek() {
    if (_items.isEmpty) {
      throw StateError('peek() bo\'sh stekda chaqirildi');
    }
    return _items.last;
  }

  /// UI ga xavfsiz ko'rsatish uchun yuqoridan-pastga o'zgarmas snapshot. `O(n)`.
  List<T> toListTopToBottom() => _items.reversed.toList(growable: false);

  /// Barcha elementlarni olib tashlaydi. `O(n)`.
  void clear() => _items.clear();
}
