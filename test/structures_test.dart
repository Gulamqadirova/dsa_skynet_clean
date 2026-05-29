import 'package:skynet/skynet.dart';
import 'package:test/test.dart';

void main() {
  group('Stack (LIFO)', () {
    test('respects last-in-first-out order', () {
      final s = Stack<int>()
        ..push(1)
        ..push(2)
        ..push(3);
      expect(s.length, 3);
      expect(s.pop(), 3);
      expect(s.peek(), 2);
      expect(s.pop(), 2);
      expect(s.pop(), 1);
      expect(s.isEmpty, isTrue);
    });

    test('pop/peek on empty stack throws (error handling)', () {
      final s = Stack<int>();
      expect(s.pop, throwsStateError);
      expect(s.peek, throwsStateError);
    });
  });

  group('FifoQueue (FIFO)', () {
    test('respects first-in-first-out order', () {
      final q = FifoQueue<String>()
        ..enqueue('a')
        ..enqueue('b')
        ..enqueue('c');
      expect(q.front(), 'a');
      expect(q.dequeue(), 'a');
      expect(q.dequeue(), 'b');
      expect(q.toListFrontToRear(), ['c']);
    });

    test('grows correctly past initial capacity (ring buffer)', () {
      final q = FifoQueue<int>();
      for (var i = 0; i < 50; i++) {
        q.enqueue(i);
      }
      for (var i = 0; i < 50; i++) {
        expect(q.dequeue(), i);
      }
      expect(q.isEmpty, isTrue);
    });

    test('dequeue on empty queue throws', () {
      expect(FifoQueue<int>().dequeue, throwsStateError);
    });
  });

  group('PriorityQueue (max-heap)', () {
    test('returns elements in descending priority', () {
      final pq = PriorityQueue<int>((a, b) => a.compareTo(b))
        ..insert(3)
        ..insert(10)
        ..insert(1)
        ..insert(7);
      expect(pq.peek(), 10);
      expect(pq.removeMax(), 10);
      expect(pq.removeMax(), 7);
      expect(pq.removeMax(), 3);
      expect(pq.removeMax(), 1);
    });

    test('priority collisions break ties by insertion order (stable)', () {
      final pq = PriorityQueue<(int, String)>((a, b) => a.$1.compareTo(b.$1));
      pq
        ..insert((5, 'first'))
        ..insert((5, 'second'))
        ..insert((5, 'third'));
      expect(pq.removeMax().$2, 'first');
      expect(pq.removeMax().$2, 'second');
      expect(pq.removeMax().$2, 'third');
    });

    test('removeMax on empty heap throws', () {
      expect(PriorityQueue<int>((a, b) => a.compareTo(b)).removeMax,
          throwsStateError);
    });
  });

  group('AvlTree', () {
    test('stays balanced (O(log n) height) on sorted insertion', () {
      final tree = AvlTree<int, int>((a, b) => a.compareTo(b));
      for (var i = 1; i <= 1000; i++) {
        tree.insert(i, i);
      }
      expect(tree.height, lessThanOrEqualTo(14));
      expect(tree.length, 1000);
    });

    test('range query returns sorted values within bounds', () {
      final tree = AvlTree<int, String>((a, b) => a.compareTo(b));
      for (final v in [50, 20, 80, 10, 30, 60, 90, 25]) {
        tree.insert(v, 'v$v');
      }
      final result = tree.rangeQuery(20, 60);
      expect(result, ['v20', 'v25', 'v30', 'v50', 'v60']);
    });

    test('inverted range (low > high) returns nothing', () {
      final tree = AvlTree<int, int>((a, b) => a.compareTo(b))..insert(5, 5);
      expect(tree.rangeQuery(10, 1), isEmpty);
    });

    test('duplicate keys are bucketed', () {
      final tree = AvlTree<int, String>((a, b) => a.compareTo(b))
        ..insert(7, 'a')
        ..insert(7, 'b');
      expect(tree.search(7), containsAll(['a', 'b']));
    });
  });

  group('HashTable', () {
    test('put/get/remove round-trip', () {
      final h = HashTable<String, int>()
        ..put('one', 1)
        ..put('two', 2);
      expect(h.get('one'), 1);
      expect(h.containsKey('two'), isTrue);
      expect(h.remove('one'), 1);
      expect(h.get('one'), isNull);
      expect(h.length, 1);
    });

    test('updates existing key in place', () {
      final h = HashTable<String, int>()
        ..put('k', 1)
        ..put('k', 2);
      expect(h.length, 1);
      expect(h.get('k'), 2);
    });

    test('handles many keys with resize, staying correct', () {
      final h = HashTable<int, int>();
      for (var i = 0; i < 500; i++) {
        h.put(i, i * i);
      }
      expect(h.length, 500);
      expect(h.loadFactor, lessThanOrEqualTo(0.75));
      for (var i = 0; i < 500; i++) {
        expect(h.get(i), i * i);
      }
    });
  });
}
