import 'package:web/web.dart' as web;

import '../dom.dart';
import '../phase_view.dart';
import '../widgets.dart';

/// Landing screen: system status and a map of the five phases.
class OverviewView extends PhaseView {
  OverviewView(super.system);

  @override
  String get id => 'overview';
  @override
  String get navLabel => 'Overview';
  @override
  String get title => 'SkyNet — Operations Dashboard';
  @override
  String get subtitle =>
      'A unified backend for flight operations, passenger handling and '
      'logistics, built on classic data structures and algorithms.';

  @override
  web.HTMLElement build() => div(
        classes: 'stack-lg',
        children: [
          grid([
            statTile('${system.network.airportCount}', 'Airports',
                tone: 'good'),
            statTile('${system.network.flightCount}', "To'g'ridan-to'g'ri reyslar"),
            statTile(
                '${system.search.indexedFlightCount}', 'Rejalashtirilgan reyslar'),
            statTile('${system.search.profileCount}', "Yo'lovchilar"),
          ]),
          card(
            'Phase map',
            hint: 'Each phase pairs a real operational problem with the data '
                'structure that solves it best.',
            children: [
              grid(
                classes: 'phase-grid',
                [
                  _phase('1', 'Global Navigatsiya', 'Graph · Dijkstra · MST',
                      'Eng arzon marshrutlar va minimal xarajatli zaxira tarmoq.'),
                  _phase(
                      '2',
                      'Priority & Boarding',
                      'Max-Heap · FIFO Queue · Stack',
                      "Darajali ro'yxatdan o'tish, tartiblangan bortga o'tirish, LIFO yuk bo'limi."),
                  _phase('3', 'Yuqori Tezlikdagi Qidiruv', 'AVL Tree · Hash Table',
                      "Narx diapazoni so'rovlari va O(1) PNR qidiruvlari."),
                  _phase(
                      '4',
                      'Analytics & Strings',
                      'QuickSort · MergeSort · KMP',
                      'Jadval saralash va manifest ism moslashtirish.'),
                  _phase('5', 'Favqulodda Holat', 'Recursive Backtracking',
                      "Yopilgan havo fazosidan chetlab o'tuvchi muqobil marshrutlash."),
                ],
              ),
            ],
          ),
        ],
      );

  web.HTMLElement _phase(String n, String title, String tech, String desc) =>
      div(
        classes: 'phase-tile',
        children: [
          div(classes: 'phase-num', text: n),
          heading(4, title),
          badge(tech),
          para(classes: 'subtle', text: desc),
        ],
      );
}
