/// **Knuth–Morris–Pratt (KMP)** aniq qatorni qidirish.
///
/// KMP naqsh uchun "eng uzun to'g'ri prefiks, shuningdek suffiks" (LPS) jadvalini
/// oldindan hisoblab chiqadi, so'ngra birorta belgini qayta tekshirmasdan matnni
/// skanerlaydi — shuning uchun mos kelish `n` uzunlikdagi matn va `m` uzunlikdagi
/// naqsh uchun `O(n + m)`.
/// LPS jadvalini qurish `O(m)` vaqt va xotira sarflaydi.
///
/// Katta reys manifestlarda yo'lovchi ismlarini topish uchun ishlatiladi.
library;

/// KMP muvaffaqiyatsizlik (LPS) jadvalini [pattern] uchun quradi. `O(m)`.
List<int> buildLpsTable(String pattern) {
  final lps = List<int>.filled(pattern.length, 0);
  var len = 0; // oldingi eng uzun prefiks-suffiks uzunligi.
  var i = 1;
  while (i < pattern.length) {
    if (pattern[i] == pattern[len]) {
      lps[i++] = ++len;
    } else if (len != 0) {
      len = lps[len - 1]; // i ni oldinga surmasdan orqaga qaytadi.
    } else {
      lps[i++] = 0;
    }
  }
  return lps;
}

/// [pattern] ning [text] da uchraydigan har bir boshlang'ich indeksini qaytaradi. `O(n + m)`.
///
/// [caseSensitive] = `false` bilan katta-kichik harfdan mustaqil qidiruv taklif etiladi,
/// bu inson ismlarini moslashtirish uchun amaliy standart. Bo'sh naqsh hech narsaga
/// mos kelmaydi (har bir pozitsiyada emas), bu qidiruv oynasi uchun foydali xulq-atvor.
List<int> kmpSearch(
  String text,
  String pattern, {
  bool caseSensitive = false,
}) {
  if (pattern.isEmpty || text.length < pattern.length) return const [];

  final t = caseSensitive ? text : text.toLowerCase();
  final p = caseSensitive ? pattern : pattern.toLowerCase();
  final lps = buildLpsTable(p);
  final matches = <int>[];

  var i = 0; // matndagi indeks
  var j = 0; // naqshdagi indeks
  while (i < t.length) {
    if (t[i] == p[j]) {
      i++;
      j++;
      if (j == p.length) {
        matches.add(i - j);
        j = lps[j - 1]; // qoplanadigan mosliklar uchun qidirishni davom ettiradi.
      }
    } else if (j != 0) {
      j = lps[j - 1]; // jadvalni qayta ishlating; i ni orqaga qaytarma.
    } else {
      i++;
    }
  }
  return matches;
}

/// Qulaylik predikati: [text] [pattern] ni kamida bir marta o'z ichiga oladimi?
bool kmpContains(String text, String pattern, {bool caseSensitive = false}) =>
    kmpSearch(text, pattern, caseSensitive: caseSensitive).isNotEmpty;
