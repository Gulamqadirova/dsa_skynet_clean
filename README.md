# SkyNet — Global Aviation Logistics & Management System

A browser-based **Dart** application (no Flutter) implementing the five phases
of the Unit 26 *Data Structures & Algorithms* brief. The UI runs in the browser;
all data structures and algorithms are written from scratch in pure Dart.

## Phases & the structures behind them

| Phase | Operational problem | Data structure / algorithm |
|-------|---------------------|----------------------------|
| 1 · Network | Cheapest route & backup network | **Graph** (adjacency list), **Dijkstra**, **Kruskal & Prim** MST |
| 2 · Operations | Tiered check-in, boarding, cargo | **Max-Heap priority queue**, **FIFO queue**, **LIFO stack** |
| 3 · Search | Price range queries, PNR lookup | **AVL tree**, **Hash table** (separate chaining) |
| 4 · Analytics | Schedule sorting, name search | **QuickSort vs MergeSort**, **Knuth–Morris–Pratt** |
| 5 · Contingency | Rerouting around closures | **Recursive backtracking** |

## Project layout

```
lib/
  skynet.dart                 # public barrel export
  src/
    structures/               # pure ADTs: stack, queue, heap, AVL, hash table, graph
    algorithms/               # dijkstra, MST, sorting, KMP, backtracking
    models/                   # Airport, Flight, Passenger
    services/                 # one service per phase — the encapsulation boundary
    data/sample_data.dart     # seed data
    ui/                       # package:web presentation layer (views + widgets)
web/
  index.html  styles.css  main.dart   # browser entry point
tool/serve.dart               # dependency-free static server
test/                         # VM unit tests + a browser smoke test
```

The core library under `lib/src/structures`, `algorithms`, `models` and
`services` has **zero third-party dependencies** — only the UI depends on
`package:web`. The UI talks exclusively to the phase services, never to the
underlying structures, keeping the implementation independent of the interface.

## Run it

Prerequisites: Dart SDK 3.5+.

```bash
dart pub get
dart compile js web/main.dart -o web/main.dart.js
dart run tool/serve.dart            # serves web/ on http://localhost:8080
```

Then open <http://localhost:8080>. (Pass a port, e.g. `dart run tool/serve.dart 9000`.)

> Any static file server works — `tool/serve.dart` is provided so no extra
> tooling is required.

## Tests

```bash
dart test                       # unit tests (VM)
dart test -p chrome             # includes the browser smoke test (needs Chrome)
```

Edge cases covered include: empty flight network, unreachable/cyclic routes,
disconnected graphs (spanning forest), priority collisions in the heap,
empty-structure pops, hash collisions/resize, and oversized/empty KMP patterns.
# dsa_skynet_clean
