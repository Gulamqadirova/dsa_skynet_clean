import 'package:web/web.dart' as web;

import '../../structures/edge.dart';
import '../dom.dart';
import '../phase_view.dart';
import '../widgets.dart';

/// Phase 5 — Contingency Planning (recursive backtracking).
class ReroutingView extends PhaseView {
  ReroutingView(super.system);

  @override
  String get id => 'rerouting';
  @override
  String get navLabel => '5 · Favqulodda';
  @override
  String get title => "Favqulodda Rejalashtirish va Marshrutni O'zgartirish";
  @override
  String get subtitle =>
      'Recursive backtracking enumerates every alternative path when hub '
      'airports close, ranked best-first.';

  @override
  web.HTMLElement build() {
    final codes =
        system.network.airports.map((a) => (a.code, a.toString())).toList();
    final allCodes = codes.map((c) => c.$1).toList();

    final from = dropdown(codes, selected: codes.first.$1);
    final to = dropdown(codes, selected: codes.last.$1);
    final metric = dropdown(
      [for (final m in RouteMetric.values) (m.name, m.label)],
      selected: RouteMetric.cost.name,
    );
    final checkboxes = <String, web.HTMLInputElement>{};
    final results = div(classes: 'results');

    Set<String> closedAirports() => {
          for (final entry in checkboxes.entries)
            if (entry.value.checked) entry.key,
        };

    void reroute() {
      final src = inputValue(from);
      final dst = inputValue(to);
      final m = RouteMetric.values.byName(inputValue(metric));
      final closed = closedAirports();
      if (src == dst) {
        replaceChildren(results,
            [notice('Origin and destination must differ.', tone: 'warning')]);
        return;
      }
      if (closed.contains(src) || closed.contains(dst)) {
        replaceChildren(results, [
          notice('Origin/destination cannot themselves be closed.',
              tone: 'warning'),
        ]);
        return;
      }
      final routes = system.rerouting
          .reroute(from: src, to: dst, closed: closed, metric: m);
      if (routes.isEmpty) {
        replaceChildren(results, [
          notice(
            closed.isEmpty
                ? 'No path from $src to $dst exists in the network.'
                : 'All paths from $src to $dst are severed by the closure of '
                    '${closed.join(", ")}.',
            tone: 'error',
          ),
        ]);
        return;
      }
      replaceChildren(results, [
        badge('${routes.length} viable alternatives', tone: 'good'),
        if (closed.isNotEmpty)
          badge('avoiding ${closed.join(", ")}', tone: 'warning'),
        div(
          classes: 'route-list',
          children: [
            for (var i = 0; i < routes.length; i++)
              div(
                classes: i == 0 ? 'route-card route-best' : 'route-card',
                children: [
                  div(
                    classes: 'route-card-head',
                    children: [
                      if (i == 0)
                        badge('best', tone: 'good')
                      else
                        badge('#${i + 1}'),
                      badge(
                        '${routes[i].totalWeight.toStringAsFixed(0)} ${m.unit}',
                      ),
                      badge('${routes[i].hops} hops'),
                    ],
                  ),
                  routeChips(routes[i].path),
                ],
              ),
          ],
        ),
      ]);
    }

    final closurePanel = div(
      classes: 'checkbox-grid',
      children: [
        for (final code in allCodes)
          _checkbox(code, (input) => checkboxes[code] = input),
      ],
    );

    return div(
      children: [
        card(
          'Muqobil marshrut qidirish · Orqaga qaytish',
          hint: 'Enumerates simple paths (no repeats), bounded by max hops, '
              'sorted by total weight.',
          children: [
            div(
              classes: 'toolbar',
              children: [
                field('From', from),
                field('To', to),
                field('Rank by', metric),
                button('Muqobillar topish', onPressed: reroute),
              ],
            ),
            para(
                classes: 'subtle',
                text: 'Aeroportlarni yopish (havo fazosini yopishni simulyatsiya):'),
            closurePanel,
            results,
          ],
        ),
      ],
    );
  }

  web.HTMLElement _checkbox(
      String code, void Function(web.HTMLInputElement) register) {
    final input = web.document.createElement('input') as web.HTMLInputElement
      ..type = 'checkbox'
      ..id = 'close-$code';
    register(input);
    final label = web.document.createElement('label') as web.HTMLLabelElement
      ..htmlFor = 'close-$code'
      ..textContent = code;
    return div(
      classes: 'checkbox-item',
      children: [input, label],
    );
  }
}
