import 'package:web/web.dart' as web;

import '../dom.dart';
import '../phase_view.dart';
import '../widgets.dart';

class EvaluationView extends PhaseView {
  EvaluationView(super.system);

  @override
  String get id => 'evaluation';
  @override
  String get navLabel => 'Baholash';
  @override
  String get title => 'Dizayn, Murakkablik va Baholash';
  @override
  String get subtitle =>
      'Formal ADT specifications, asymptotic analysis, encapsulation rationale '
      'and tested edge cases.';

  @override
  web.HTMLElement build() => div(
        classes: 'stack-lg',
        children: [
          _adtSpecs(),
          _complexityTable(),
          _encapsulation(),
          _tradeoffs(),
          _edgeCases(),
        ],
      );

  web.HTMLElement _adtSpecs() => card(
        'Formal ADT specifications (imperative)',
        hint: 'Stack, Queue and Graph — operations, axioms and preconditions.',
        children: [
          codeBlock(_stackSpec),
          codeBlock(_queueSpec),
          codeBlock(_graphSpec),
        ],
      );

  web.HTMLElement _complexityTable() => card(
        'Asymptotic analysis (Big-O)',
        hint: 'Time and memory for every implemented structure & algorithm.',
        children: [
          table(
            ['Structure / Algorithm', 'Key operation', 'Time', 'Memory'],
            [
              for (final r in _complexityRows)
                [
                  span(text: r.$1),
                  span(text: r.$2),
                  span(text: r.$3),
                  span(text: r.$4),
                ],
            ],
          ),
        ],
      );

  web.HTMLElement _encapsulation() => card(
        'Encapsulation & information hiding',
        children: [
          para(
            text: 'Every concrete data structure exposes its state through '
                'private fields (Dart’s leading-underscore convention). The UI '
                'never holds a heap array, an adjacency list or a hash bucket — '
                'it talks only to the phase services (NetworkService, '
                'CheckInService, …), which in turn talk to the structures.',
          ),
          para(
            text: 'This boundary means the internal representation can change '
                '(e.g. swapping the adjacency list for a matrix, or the binary '
                'heap for a pairing heap) without touching a single line of UI '
                'code — the defining benefit of an implementation-independent '
                'ADT.',
          ),
        ],
      );

  web.HTMLElement _tradeoffs() => card(
        'Time–memory trade-offs',
        children: [
          el(
            'ul',
            classes: 'bullet-list',
            children: [
              el('li',
                  text: 'Hash table: O(1) average lookup is bought with spare '
                      'buckets — a load factor kept below 0.75 wastes memory to '
                      'keep chains short. The live table is at load factor '
                      '${system.search.profileLoadFactor.toStringAsFixed(2)}.'),
              el('li',
                  text:
                      'MergeSort guarantees O(n log n) and stability but needs '
                      'O(n) auxiliary memory; QuickSort sorts in place but risks '
                      'O(n²).'),
              el('li',
                  text:
                      'Adjacency list uses O(V+E) memory and is ideal for sparse '
                      'flight networks; an adjacency matrix gives O(1) edge '
                      'lookup but costs O(V²) memory.'),
              el('li',
                  text:
                      'AVL trees do extra rotation work on insert to guarantee '
                      'O(log n) queries — paying at write time to save at read '
                      'time.'),
            ],
          ),
        ],
      );

  web.HTMLElement _edgeCases() => card(
        'Tested edge cases',
        hint: 'Covered by the automated suite under test/ (run: dart test).',
        children: [
          el(
            'ul',
            classes: 'bullet-list',
            children: [
              for (final c in _edgeCaseList) el('li', text: c),
            ],
          ),
        ],
      );

  static const List<(String, String, String, String)> _complexityRows = [
    ('Stack (LIFO)', 'push / pop / peek', 'O(1)', 'O(n)'),
    ('FIFO Queue (ring buffer)', 'enqueue / dequeue', 'O(1) amortised', 'O(n)'),
    ('Priority Queue (max-heap)', 'insert / removeMax', 'O(log n)', 'O(n)'),
    ('AVL Tree', 'insert / search', 'O(log n)', 'O(n)'),
    ('AVL Tree', 'range query (k hits)', 'O(log n + k)', 'O(n)'),
    ('Hash Table', 'put / get (average)', 'O(1)', 'O(n)'),
    ('Hash Table', 'put / get (worst)', 'O(n)', 'O(n)'),
    ('Dijkstra (binary heap)', 'shortest path', 'O((V+E) log V)', 'O(V)'),
    ('Kruskal MST', 'spanning tree', 'O(E log E)', 'O(V)'),
    ('Prim MST (heap)', 'spanning tree', 'O(E log V)', 'O(V)'),
    ('QuickSort', 'sort', 'O(n log n) avg', 'O(log n)'),
    ('MergeSort', 'sort', 'O(n log n)', 'O(n)'),
    ('KMP', 'substring search', 'O(n + m)', 'O(m)'),
    ('Backtracking', 'all simple paths', 'O(V!) worst', 'O(V)'),
  ];

  static const List<String> _edgeCaseList = [
    'Empty flight network — Dijkstra/MST return "no route"/empty tree, no crash.',
    'Unreachable destination — shortest path reports infinite/empty path.',
    'Disconnected graph — MST returns a spanning forest and flags it.',
    'Cyclic routes — backtracking visits each airport at most once (simple paths).',
    'Priority collisions — equal tiers fall back to arrival order, deterministically.',
    'Empty stack/queue/heap pop — throws StateError rather than corrupting state.',
    'Hash collisions — separate chaining keeps lookups correct; resize rehashes.',
    'Empty / oversized KMP pattern — returns no matches instead of throwing.',
    'AVL sorted insertion — height stays O(log n) via rotations.',
  ];

  static const String _stackSpec = '''
ADT Stack<T>
  new()            -> Stack<T>
  push(Stack, T)   -> Stack
  pop(Stack)       -> (T, Stack)        pre: not isEmpty
  peek(Stack)      -> T                 pre: not isEmpty
  isEmpty(Stack)   -> bool
axioms:
  isEmpty(new()) = true
  peek(push(s, x)) = x
  pop(push(s, x))  = (x, s)''';

  static const String _queueSpec = '''
ADT Queue<T>
  new()              -> Queue<T>
  enqueue(Queue, T)  -> Queue
  dequeue(Queue)     -> (T, Queue)      pre: not isEmpty
  front(Queue)       -> T               pre: not isEmpty
  isEmpty(Queue)     -> bool
axioms:
  isEmpty(new()) = true
  dequeue(enqueue(new(), x)) = (x, new())   // FIFO''';

  static const String _graphSpec = '''
ADT Graph<V>
  new()                    -> Graph<V>
  addVertex(Graph, V)      -> Graph
  addEdge(Graph, Edge)     -> Graph
  neighbours(Graph, V)     -> List<Edge>
  order(Graph)             -> int        // |V|
  size(Graph)              -> int        // |E|
axioms:
  order(new()) = 0
  containsVertex(addVertex(g, v), v) = true
  neighbours(addEdge(g, e), e.from) contains e''';
}
