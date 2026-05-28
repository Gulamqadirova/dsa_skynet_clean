import 'package:web/web.dart' as web;

import '../skynet_system.dart';
import 'dom.dart';
import 'phase_view.dart';
import 'views/analytics_view.dart';
import 'views/evaluation_view.dart';
import 'views/network_view.dart';
import 'views/operations_view.dart';
import 'views/overview_view.dart';
import 'views/rerouting_view.dart';
import 'views/search_view.dart';

/// The single-page application shell: a fixed sidebar of phase navigation and a
/// content area that re-renders the selected [PhaseView] on demand.
class SkyNetApp {
  SkyNetApp(SkyNetSystem system)
      : _views = [
          OverviewView(system),
          NetworkView(system),
          OperationsView(system),
          SearchView(system),
          AnalyticsView(system),
          ReroutingView(system),
          EvaluationView(system),
        ];

  final List<PhaseView> _views;

  late final web.HTMLElement _content = div(classes: 'content');
  late final web.HTMLElement _nav = el('nav', classes: 'nav');
  final Map<String, web.HTMLElement> _navItems = {};
  String _activeId = 'overview';

  /// Mounts the application into [root].
  void mount(web.HTMLElement root) {
    final shell = div(
      classes: 'app',
      children: [_buildSidebar(), _content],
    );
    root.appendChild(shell);
    _select(_activeId);
  }

  web.HTMLElement _buildSidebar() {
    final links = <web.Node>[];
    for (final view in _views) {
      final item = button(
        view.navLabel,
        classes: 'nav-item',
        onPressed: () => _select(view.id),
      )..id = 'nav-${view.id}';
      _navItems[view.id] = item;
      links.add(item);
    }
    replaceChildren(_nav, links);
    return el(
      'aside',
      classes: 'sidebar',
      children: [
        div(
          classes: 'brand',
          children: [
            div(classes: 'brand-mark', text: '✈'),
            div(
              children: [
                div(classes: 'brand-name', text: 'SkyNet'),
                div(classes: 'brand-sub', text: 'Aviatsiya Logistikasi'),
              ],
            ),
          ],
        ),
        _nav,
        div(
          classes: 'sidebar-foot',
          children: [
            span(text: "26-Birlik · Ma'lumotlar Tuzilmalari & Algoritmlar"),
          ],
        ),
      ],
    );
  }

  void _select(String id) {
    _activeId = id;
    final view = _views.firstWhere((v) => v.id == id);

    // Reflect the active state in the nav.
    _navItems.forEach((viewId, item) {
      item.className = viewId == id ? 'nav-item nav-active' : 'nav-item';
    });

    replaceChildren(_content, [
      el(
        'header',
        classes: 'page-head',
        children: [
          heading(1, view.title, classes: 'page-title'),
          para(classes: 'page-sub', text: view.subtitle),
        ],
      ),
      view.build(),
    ]);
    _content.scrollTop = 0;
  }
}
