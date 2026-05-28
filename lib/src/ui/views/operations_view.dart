import 'package:web/web.dart' as web;

import '../../models/passenger.dart';
import '../../services/boarding_service.dart';
import '../dom.dart';
import '../phase_view.dart';
import '../widgets.dart';

/// Phase 2 — Passenger Priority & Check-in (heaps, queues, stacks).
class OperationsView extends PhaseView {
  OperationsView(super.system);

  int _bagCounter = 0;

  @override
  String get id => 'operations';
  @override
  String get navLabel => '2 · Operatsiyalar';
  @override
  String get title => "Yo'lovchi Ustuvorligi va Bortga O'tirish Logistikasi";
  @override
  String get subtitle =>
      'A max-heap ranks check-in by tier, a FIFO queue boards passengers in '
      'order, and a LIFO stack models the cargo hold.';

  @override
  web.HTMLElement build() => div(
        children: [
          grid([_checkInCard(), _boardingCard(), _cargoCard()]),
        ],
        classes: 'stack-lg',
      );

  // ---- Check-in: Max-heap priority queue ------------------------------------

  web.HTMLElement _checkInCard() {
    final body = div();

    void render() {
      final pending = system.checkIn.pendingOrder;
      replaceChildren(body, [
        div(
          classes: 'toolbar',
          children: [
            badge('${system.checkIn.waiting} waiting'),
            button(
              'Keyingiga xizmat',
              onPressed: () {
                if (system.checkIn.isEmpty) return;
                final served = system.checkIn.serveNext();
                render();
                _flash(body, '${served.name} (${served.tier.label}) served.');
              },
            ),
          ],
        ),
        if (pending.isEmpty)
          notice('Check-in desk is empty.', tone: 'info')
        else
          el(
            'ol',
            classes: 'queue-list',
            children: [
              for (final p in pending)
                el(
                  'li',
                  children: [
                    span(text: p.name),
                    badge(p.tier.label, tone: _tierTone(p.tier)),
                  ],
                ),
            ],
          ),
      ]);
    }

    render();
    return card(
      "Aqlli ro'yxatdan o'tish · Maks-Heap ustuvorlik navbati",
      hint: 'Served by tier (Platinum→Economy); ties broken by arrival order. '
          'insert/removeMax in O(log n).',
      children: [body],
    );
  }

  // ---- Boarding gate: FIFO queue --------------------------------------------

  web.HTMLElement _boardingCard() {
    final body = div();

    void render() {
      final order = system.boarding.boardingOrder;
      replaceChildren(body, [
        div(
          classes: 'toolbar',
          children: [
            badge('${system.boarding.queueLength} in line'),
            button(
              "Ro'yxatdan to'ldirish",
              onPressed: () {
                while (system.checkIn.isNotEmpty) {
                  system.boarding.joinQueue(system.checkIn.serveNext());
                }
                render();
              },
            ),
            button(
              "Keyingini o'tkazish",
              onPressed: () {
                if (system.boarding.gateIsEmpty) return;
                final boarded = system.boarding.boardNext();
                render();
                _flash(body, '${boarded.name} boarded (FIFO).');
              },
            ),
          ],
        ),
        if (order.isEmpty)
          notice('Boarding queue is empty. Fill it from the check-in desk.',
              tone: 'info')
        else
          el(
            'ol',
            classes: 'queue-list',
            children: [for (final p in order) el('li', text: p.name)],
          ),
      ]);
    }

    render();
    return card(
      "Bortga o'tirish eshigi · FIFO navbati",
      hint: 'First-in-first-out over a ring buffer. enqueue/dequeue in O(1).',
      children: [body],
    );
  }

  // ---- Cargo hold: LIFO stack -----------------------------------------------

  web.HTMLElement _cargoCard() {
    final body = div();

    void render() {
      final contents = system.boarding.holdContents;
      replaceChildren(body, [
        div(
          classes: 'toolbar',
          children: [
            badge('${system.boarding.holdSize} bags'),
            button(
              'Sumka yuklash',
              onPressed: () {
                _bagCounter++;
                system.boarding.loadLuggage(
                  Luggage('BAG${_bagCounter.toString().padLeft(3, '0')}',
                      'Passenger $_bagCounter'),
                );
                render();
              },
            ),
            button(
              'Sumka tushirish',
              onPressed: () {
                if (system.boarding.holdIsEmpty) return;
                final bag = system.boarding.unloadLuggage();
                render();
                _flash(body, 'Unloaded ${bag.tag} (last in, first out).');
              },
            ),
          ],
        ),
        if (contents.isEmpty)
          notice('Cargo hold is empty.', tone: 'info')
        else
          div(
            classes: 'cargo-stack',
            children: [
              for (var i = 0; i < contents.length; i++)
                div(
                  classes: i == 0 ? 'cargo-item cargo-top' : 'cargo-item',
                  children: [
                    span(text: contents[i].tag),
                    if (i == 0) badge('top · next out', tone: 'good'),
                  ],
                ),
            ],
          ),
      ]);
    }

    render();
    return card(
      "Yuk bo'limi · LIFO steki",
      hint: 'Last-in-first-out: the last bag loaded is the first unloaded. '
          'push/pop in O(1).',
      children: [body],
    );
  }

  String _tierTone(TicketTier tier) => switch (tier) {
        TicketTier.platinum => 'good',
        TicketTier.gold => 'warning',
        TicketTier.silver => 'neutral',
        TicketTier.economy => 'muted',
      };

  void _flash(web.HTMLElement body, String message) {
    body.appendChild(notice(message, tone: 'success'));
  }
}
