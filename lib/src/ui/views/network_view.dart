import 'package:web/web.dart' as web;

import '../../algorithms/minimum_spanning_tree.dart';
import '../../structures/edge.dart';
import '../dom.dart';
import '../phase_view.dart';
import '../widgets.dart';

class NetworkView extends PhaseView {
  NetworkView(super.system);

  @override
  String get id => 'network';
  @override
  String get navLabel => '1 · Tarmoq';
  @override
  String get title => 'Global Navigatsiya & Infratuzilma';
  @override
  String get subtitle =>
      'Airports as graph nodes, flights as weighted edges — Dijkstra for the '
      'cheapest route, Kruskal & Prim for the backup network.';

  @override
  web.HTMLElement build() {
    final network = system.network;
    final codes = network.airports.map((a) => (a.code, a.toString())).toList();

    return div(
      children: [
        grid([
          statTile('${network.airportCount}', 'Aeroportlar (tepalar)'),
          statTile('${network.flightCount}', "To'g'ridan-to'g'ri reyslar (qirralar)"),
        ]),
        _routeFinder(codes),
        _backupNetwork(),
      ],
    );
  }

  // ---- Dijkstra route finder ------------------------------------------------

  web.HTMLElement _routeFinder(List<(String, String)> codes) {
    final from = dropdown(codes, selected: codes.first.$1);
    final to = dropdown(codes, selected: codes.last.$1);
    final metric = _metricDropdown();
    final results = div(classes: 'results');

    void search() {
      final src = inputValue(from);
      final dst = inputValue(to);
      final m = RouteMetric.values.byName(inputValue(metric));
      if (src == dst) {
        replaceChildren(results, [
          notice('Origin and destination must differ.', tone: 'warning'),
        ]);
        return;
      }
      final path = system.network.cheapestRoute(src, dst, metric: m);
      if (!path.isReachable) {
        replaceChildren(results, [
          notice('No route exists from $src to $dst.', tone: 'error'),
        ]);
        return;
      }
      replaceChildren(results, [
        routeChips(path.path),
        div(
          classes: 'result-line',
          children: [
            badge(
              'Total ${m.label}: ${path.totalWeight.toStringAsFixed(0)} ${m.unit}',
              tone: 'good',
            ),
            badge('${path.edges.length} legs'),
          ],
        ),
        table(
          ['Leg', 'Cost \$', 'Distance km', 'Time min'],
          [
            for (final e in path.edges)
              [
                span(text: '${e.from} → ${e.to}'),
                span(text: e.cost.toStringAsFixed(0)),
                span(text: e.distanceKm.toStringAsFixed(0)),
                span(text: '${e.timeMinutes}'),
              ],
          ],
        ),
      ]);
    }

    return card(
      'Eng arzon marshrut · Dijkstra',
      hint: 'O((V + E) log V) with a binary-heap priority queue.',
      children: [
        div(
          classes: 'toolbar',
          children: [
            field('Kimdan', from),
            field('Kimga', to),
            field('Optimallashtirish', metric),
            button('Marshrut topish', onPressed: search),
          ],
        ),
        results,
      ],
    );
  }

  // ---- Kruskal & Prim backup network ---------------------------------------

  web.HTMLElement _backupNetwork() {
    final metric = _metricDropdown();
    final results = div(classes: 'results');

    void build() {
      final m = RouteMetric.values.byName(inputValue(metric));
      final kruskal = system.network.backupNetworkKruskal(metric: m);
      final prim = system.network.backupNetworkPrim(metric: m);
      replaceChildren(results, [
        grid([
          _mstCard('Kruskal', kruskal, m),
          _mstCard('Prim', prim, m),
        ]),
        if (!kruskal.isConnected)
          notice(
            'Network is disconnected — the result is a spanning forest, not a '
            'single tree.',
            tone: 'warning',
          )
        else
          notice(
            'Both algorithms connect all ${system.network.airportCount} '
            'airports with equal minimum total ${m.label.toLowerCase()} — as '
            'theory predicts for a connected graph.',
            tone: 'info',
          ),
      ]);
    }

    return card(
      "Zaxira aloqa tarmog'i · Minimal Yoyuvchi Daraxt",
      hint: 'Kruskal O(E log E) vs Prim O(E log V) — lowest-cost connectivity.',
      children: [
        div(
          classes: 'toolbar',
          children: [
            field('Minimallashtirish', metric),
            button('Zaxira tarmoq qurish', onPressed: build),
          ],
        ),
        results,
      ],
    );
  }

  web.HTMLElement _mstCard(String name, SpanningTree tree, RouteMetric m) =>
      div(
        classes: 'subcard',
        children: [
          heading(4, name),
          badge(
            'Total: ${tree.totalWeight.toStringAsFixed(0)} ${m.unit}',
            tone: 'good',
          ),
          badge('${tree.edges.length} links'),
          el(
            'ul',
            classes: 'edge-list',
            children: [
              for (final e in tree.edges)
                el(
                  'li',
                  text: '${e.from} — ${e.to}  '
                      '(${m.weightOf(e).toStringAsFixed(0)} ${m.unit})',
                ),
            ],
          ),
        ],
      );

  web.HTMLSelectElement _metricDropdown() => dropdown(
        [for (final m in RouteMetric.values) (m.name, m.label)],
        selected: RouteMetric.cost.name,
      );
}
