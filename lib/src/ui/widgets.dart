import 'package:web/web.dart' as web;

import 'dom.dart';

/// Higher-level, app-specific building blocks composed from [dom] primitives.

/// A titled content card.
web.HTMLElement card(
  String title, {
  String? hint,
  List<web.Node> children = const [],
}) =>
    el(
      'section',
      classes: 'card',
      children: [
        el(
          'header',
          classes: 'card-head',
          children: [
            heading(3, title, classes: 'card-title'),
            if (hint != null) para(classes: 'card-hint', text: hint),
          ],
        ),
        div(classes: 'card-body', children: children),
      ],
    );

/// A compact metric tile (big value over a caption).
web.HTMLElement statTile(String value, String caption,
        {String tone = 'neutral'}) =>
    div(
      classes: 'stat stat-$tone',
      children: [
        div(classes: 'stat-value', text: value),
        div(classes: 'stat-caption', text: caption),
      ],
    );

/// A responsive grid wrapper.
web.HTMLElement grid(List<web.Node> children, {String classes = 'grid'}) =>
    div(classes: classes, children: children);

/// A horizontal row of airport "chips" joined by arrows, used to render a path.
web.HTMLElement routeChips(List<String> stops) {
  final children = <web.Node>[];
  for (var i = 0; i < stops.length; i++) {
    children.add(span(classes: 'chip', text: stops[i]));
    if (i < stops.length - 1) {
      children.add(span(classes: 'arrow', text: '→'));
    }
  }
  return div(classes: 'route', children: children);
}

/// An inline notice (info / success / warning / error).
web.HTMLElement notice(String text, {String tone = 'info'}) =>
    div(classes: 'notice notice-$tone', text: text);

/// A bordered "code" block for showing complexity notes or formal specs.
web.HTMLElement codeBlock(String text) =>
    el('pre', classes: 'code', children: [el('code', text: text)]);
