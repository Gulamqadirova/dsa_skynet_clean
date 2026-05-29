List<int> buildLpsTable(String pattern) {
  final lps = List<int>.filled(pattern.length, 0);
  var len = 0;
  var i = 1;
  while (i < pattern.length) {
    if (pattern[i] == pattern[len]) {
      lps[i++] = ++len;
    } else if (len != 0) {
      len = lps[len - 1];
    } else {
      lps[i++] = 0;
    }
  }
  return lps;
}

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

  var i = 0;
  var j = 0;
  while (i < t.length) {
    if (t[i] == p[j]) {
      i++;
      j++;
      if (j == p.length) {
        matches.add(i - j);
        j = lps[j - 1];
      }
    } else if (j != 0) {
      j = lps[j - 1];
    } else {
      i++;
    }
  }
  return matches;
}

bool kmpContains(String text, String pattern, {bool caseSensitive = false}) =>
    kmpSearch(text, pattern, caseSensitive: caseSensitive).isNotEmpty;
