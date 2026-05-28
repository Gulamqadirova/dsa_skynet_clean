import 'package:web/web.dart' as web;

import '../../services/analytics_service.dart';
import '../dom.dart';
import '../phase_view.dart';
import '../widgets.dart';

/// Faza 4 — Ma'lumotlar Analitikasi va Qatorni Qayta Ishlash (saralash + KMP).
class AnalyticsView extends PhaseView {
  AnalyticsView(super.system);

  @override
  String get id => 'analytics';
  @override
  String get navLabel => '4 · Analitika';
  @override
  String get title => "Ma'lumotlar Analitikasi va Qatorni Qayta Ishlash";
  @override
  String get subtitle =>
      'Kunlik jadvalda QuickSort va MergeSort taqqoslovi, hamda manifestda '
      'yo\'lovchilarni topish uchun KMP naqsh qidirish.';

  @override
  web.HTMLElement build() => div(
        classes: 'stack-lg',
        children: [_sortComparison(), _manifestSearch()],
      );

  // ---- QuickSort va MergeSort -----------------------------------------------

  web.HTMLElement _sortComparison() {
    final key = dropdown(
      [for (final k in FlightSortKey.values) (k.name, k.label)],
      selected: FlightSortKey.departure.name,
    );
    final results = div(classes: 'results');

    void run() {
      final sortKey = FlightSortKey.values.byName(inputValue(key));
      final flights = system.search.flightsByPrice;
      if (flights.isEmpty) {
        replaceChildren(results, [notice('Saralash uchun reyslar yo\'q.', tone: 'info')]);
        return;
      }
      final cmp = system.analytics.compareSorts(flights, sortKey);
      final fasterQuick = cmp.quick.microseconds <= cmp.merge.microseconds;
      replaceChildren(results, [
        table(
          ['Algoritm', 'Taqqoslashlar', 'Vaqt (µs)', 'Big-O'],
          [
            [
              span(text: 'QuickSort'),
              span(text: '${cmp.quick.comparisons}'),
              span(text: cmp.quick.microseconds.toStringAsFixed(1)),
              span(text: 'o\'rtacha O(n log n) / eng yomon O(n²)'),
            ],
            [
              span(text: 'MergeSort'),
              span(text: '${cmp.merge.comparisons}'),
              span(text: cmp.merge.microseconds.toStringAsFixed(1)),
              span(text: 'O(n log n), barqaror, O(n) xotira'),
            ],
          ],
        ),
        notice(
          fasterQuick
              ? 'QuickSort bu yerda tezroq (o\'rnatilgan, kesh-qulay), lekin eng yomon '
                  'holati O(n²). MergeSort kafolatlangan chegara va barqarorlik uchun O(n) xotirani sarflaydi.'
              : 'MergeSort bu kiritishda tezroq. U O(n log n) ni kafolatlaydi '
                  'va O(n) qo\'shimcha xotira evaziga barqarorlikni ta\'minlaydi.',
          tone: 'info',
        ),
        heading(4, '${sortKey.label.toLowerCase()} bo\'yicha saralandi'),
        table(
          ['Reys', 'Marshrut', 'Jo\'nash', 'Narx \$', 'Yonilg\'i samar.'],
          [
            for (final f in cmp.sorted)
              [
                span(text: f.flightNo),
                span(text: '${f.origin} → ${f.destination}'),
                span(text: f.departureLabel),
                span(text: f.price.toStringAsFixed(0)),
                span(text: f.fuelEfficiency.toStringAsFixed(1)),
              ],
          ],
        ),
      ]);
    }

    return card(
      'Jadval saralash · QuickSort va MergeSort',
      hint: 'Ikkalasi ham bir xil tartiblarni beradi; taqqoslashlar va vaqt '
          'adolatli taqqoslash uchun asboblashtirilgan (M2).',
      children: [
        div(
          classes: 'toolbar',
          children: [
            field('Saralash asosi', key),
            button('Saralash va taqqoslash', onPressed: run),
          ],
        ),
        results,
      ],
    );
  }

  // ---- KMP manifest qidirish ------------------------------------------------

  web.HTMLElement _manifestSearch() {
    final query = textInput(placeholder: 'masalan: Watson', value: 'Watson');
    final results = div(classes: 'results');

    void search() {
      final matches =
          system.analytics.searchManifest(system.manifest, query.value);
      if (matches.isEmpty) {
        replaceChildren(results, [
          notice('Yo\'lovchi "${query.value}" topilmadi.', tone: 'info'),
        ]);
        return;
      }
      replaceChildren(results, [
        badge('${matches.length} mos keldi', tone: 'good'),
        el(
          'ul',
          classes: 'queue-list',
          children: [
            for (final m in matches)
              el(
                'li',
                children: [
                  span(text: m.passenger.name),
                  badge('PNR ${m.passenger.pnr}'),
                  badge('mos @ ${m.index}'),
                ],
              ),
          ],
        ),
      ]);
    }

    return card(
      'Manifest ism qidirish · Knuth-Morris-Pratt',
      hint: 'O(n + m) qator qidirish, katta-kichik harfdan mustaqil.',
      children: [
        div(
          classes: 'toolbar',
          children: [
            field('Ism qidirish', query),
            button('Manifestni qidirish', onPressed: search),
          ],
        ),
        results,
      ],
    );
  }
}
