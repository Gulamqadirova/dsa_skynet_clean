import 'package:web/web.dart' as web;

import 'dom.dart';

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

web.HTMLElement statTile(String value, String caption,
        {String tone = 'neutral'}) =>
    div(
      classes: 'stat stat-$tone',
      children: [
        div(classes: 'stat-value', text: value),
        div(classes: 'stat-caption', text: caption),
      ],
    );

web.HTMLElement grid(List<web.Node> children, {String classes = 'grid'}) =>
    div(classes: classes, children: children);

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

web.HTMLElement notice(String text, {String tone = 'info'}) =>
    div(classes: 'notice notice-$tone', text: text);
web.HTMLElement codeBlock(String text) =>
    el('pre', classes: 'code', children: [el('code', text: text)]);
