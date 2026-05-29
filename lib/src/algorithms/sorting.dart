class SortStats {
  final String algorithm;
  final int comparisons;
  final Duration elapsed;
  final int n;

  const SortStats({
    required this.algorithm,
    required this.comparisons,
    required this.elapsed,
    required this.n,
  });

  double get microseconds => elapsed.inMicroseconds.toDouble();
}

class SortResult<T> {
  final List<T> sorted;
  final SortStats stats;
  const SortResult(this.sorted, this.stats);
}

class _Counter {
  int comparisons = 0;
}

SortResult<T> quickSort<T>(List<T> input, Comparator<T> compare) {
  final list = List<T>.of(input);
  final counter = _Counter();
  final sw = Stopwatch()..start();
  _quickSort(list, 0, list.length - 1, compare, counter);
  sw.stop();
  return SortResult<T>(
    list,
    SortStats(
      algorithm: 'QuickSort',
      comparisons: counter.comparisons,
      elapsed: sw.elapsed,
      n: list.length,
    ),
  );
}

void _quickSort<T>(
  List<T> a,
  int lo,
  int hi,
  Comparator<T> compare,
  _Counter c,
) {
  while (lo < hi) {
    final p = _partition(a, lo, hi, compare, c);
    if (p - lo < hi - p) {
      _quickSort(a, lo, p - 1, compare, c);
      lo = p + 1;
    } else {
      _quickSort(a, p + 1, hi, compare, c);
      hi = p - 1;
    }
  }
}

int _partition<T>(
    List<T> a, int lo, int hi, Comparator<T> compare, _Counter c) {
  final mid = lo + ((hi - lo) >> 1);
  _medianOfThree(a, lo, mid, hi, compare, c);
  final pivot = a[hi];
  var i = lo - 1;
  for (var j = lo; j < hi; j++) {
    c.comparisons++;
    if (compare(a[j], pivot) <= 0) {
      i++;
      _swap(a, i, j);
    }
  }
  _swap(a, i + 1, hi);
  return i + 1;
}

void _medianOfThree<T>(
  List<T> a,
  int lo,
  int mid,
  int hi,
  Comparator<T> compare,
  _Counter c,
) {
  c.comparisons++;
  if (compare(a[mid], a[lo]) < 0) _swap(a, mid, lo);
  c.comparisons++;
  if (compare(a[hi], a[lo]) < 0) _swap(a, hi, lo);
  c.comparisons++;
  if (compare(a[hi], a[mid]) < 0) _swap(a, hi, mid);
  _swap(a, mid, hi);
}

void _swap<T>(List<T> a, int i, int j) {
  final tmp = a[i];
  a[i] = a[j];
  a[j] = tmp;
}


SortResult<T> mergeSort<T>(List<T> input, Comparator<T> compare) {
  final list = List<T>.of(input);
  final counter = _Counter();
  final buffer = List<T?>.filled(list.length, null);
  final sw = Stopwatch()..start();
  _mergeSort(list, buffer, 0, list.length - 1, compare, counter);
  sw.stop();
  return SortResult<T>(
    list,
    SortStats(
      algorithm: 'MergeSort',
      comparisons: counter.comparisons,
      elapsed: sw.elapsed,
      n: list.length,
    ),
  );
}

void _mergeSort<T>(
  List<T> a,
  List<T?> buf,
  int lo,
  int hi,
  Comparator<T> compare,
  _Counter c,
) {
  if (lo >= hi) return;
  final mid = lo + ((hi - lo) >> 1);
  _mergeSort(a, buf, lo, mid, compare, c);
  _mergeSort(a, buf, mid + 1, hi, compare, c);
  _merge(a, buf, lo, mid, hi, compare, c);
}

void _merge<T>(
  List<T> a,
  List<T?> buf,
  int lo,
  int mid,
  int hi,
  Comparator<T> compare,
  _Counter c,
) {
  var i = lo;
  var j = mid + 1;
  var k = lo;
  while (i <= mid && j <= hi) {
    c.comparisons++;
    if (compare(a[i], a[j]) <= 0) {
      buf[k++] = a[i++];
    } else {
      buf[k++] = a[j++];
    }
  }
  while (i <= mid) buf[k++] = a[i++];
  while (j <= hi) buf[k++] = a[j++];
  for (var x = lo; x <= hi; x++) {
    a[x] = buf[x] as T;
  }
}
