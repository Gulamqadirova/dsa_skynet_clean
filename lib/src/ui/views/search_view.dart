import 'package:web/web.dart' as web;

import '../dom.dart';
import '../phase_view.dart';
import '../widgets.dart';

class SearchView extends PhaseView {
  SearchView(super.system);

  @override
  String get id => 'search';
  @override
  String get navLabel => '3 · Qidiruv';
  @override
  String get title => "Yuqori Tezlikdagi Qidiruv va Ma'lumotlarni Olish";
  @override
  String get subtitle =>
      'An AVL tree answers price range queries in O(log n + k); a hash table '
      'retrieves passenger profiles by PNR in expected O(1).';

  @override
  web.HTMLElement build() => div(
        classes: 'stack-lg',
        children: [
          grid([
            statTile('${system.search.indexedFlightCount}', 'Indekslangan reyslar'),
            statTile('${system.search.priceIndexHeight}', 'AVL daraxt balandligi'),
            statTile('${system.search.profileCount}', 'Profiller (xesh jadval)'),
            statTile(
              system.search.profileLoadFactor.toStringAsFixed(2),
              'Xesh yuklama koeffitsienti',
            ),
          ]),
          _priceRange(),
          _pnrLookup(),
        ],
      );

  // ---- AVL range query ------------------------------------------------------

  web.HTMLElement _priceRange() {
    final min = textInput(placeholder: 'min \$', value: '100');
    final max = textInput(placeholder: 'max \$', value: '500');
    final results = div(classes: 'results');

    void query() {
      final lo = double.tryParse(min.value);
      final hi = double.tryParse(max.value);
      if (lo == null || hi == null) {
        replaceChildren(
            results, [notice('Enter numeric price bounds.', tone: 'warning')]);
        return;
      }
      final flights = system.search.flightsInPriceRange(lo, hi);
      if (flights.isEmpty) {
        replaceChildren(results, [
          notice('No flights priced between \$$lo and \$$hi.', tone: 'info'),
        ]);
        return;
      }
      replaceChildren(results, [
        badge('${flights.length} flights in range', tone: 'good'),
        table(
          ['Flight', 'Route', 'Departs', 'Price \$'],
          [
            for (final f in flights)
              [
                span(text: f.flightNo),
                span(text: '${f.origin} → ${f.destination}'),
                span(text: f.departureLabel),
                span(text: f.price.toStringAsFixed(0)),
              ],
          ],
        ),
      ]);
    }

    return card(
      "Reys narx diapazoni so'rovi · AVL daraxt",
      hint: 'Ascending results, only the relevant subtree is visited.',
      children: [
        div(
          classes: 'toolbar',
          children: [
            field('Min narx', min),
            field('Max narx', max),
            button('Diapazon qidirish', onPressed: query),
          ],
        ),
        results,
      ],
    );
  }

  // ---- Hash table lookup ----------------------------------------------------

  web.HTMLElement _pnrLookup() {
    final pnr = textInput(placeholder: 'e.g. PNR007', value: 'PNR007');
    final results = div(classes: 'results');

    void lookup() {
      final code = pnr.value.trim().toUpperCase();
      final profile = system.search.profileByPnr(code);
      if (profile == null) {
        replaceChildren(results, [
          notice('No profile found for "$code". Security: deny boarding.',
              tone: 'error'),
        ]);
        return;
      }
      replaceChildren(results, [
        div(
          classes: 'profile',
          children: [
            heading(4, profile.name),
            badge('PNR ${profile.pnr}'),
            badge('Tier ${profile.tier.label}', tone: 'good'),
          ],
        ),
      ]);
    }

    return card(
      "Yo'lovchi profili qidirish · Xesh jadval",
      hint: 'Separate chaining. Longest chain: '
          '${system.search.profileLongestChain}, '
          'buckets: ${system.search.profileBucketCount}.',
      children: [
        div(
          classes: 'toolbar',
          children: [
            field('PNR', pnr),
            button('Qidirish', onPressed: lookup),
          ],
        ),
        results,
      ],
    );
  }
}
