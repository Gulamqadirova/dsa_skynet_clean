import 'dart:js_interop';

import 'package:web/web.dart' as web;

web.HTMLElement el(
  String tag, {
  String? classes,
  String? text,
  List<web.Node> children = const [],
  Map<String, String> attributes = const {},
  void Function(web.Event event)? onClick,
}) {
  final node = web.document.createElement(tag) as web.HTMLElement;
  if (classes != null) node.className = classes;
  if (text != null) node.textContent = text;
  for (final entry in attributes.entries) {
    node.setAttribute(entry.key, entry.value);
  }
  for (final child in children) {
    node.appendChild(child);
  }
  if (onClick != null) {
    node.addEventListener('click', onClick.toJS);
  }
  return node;
}

web.HTMLElement div({
  String? classes,
  String? text,
  List<web.Node> children = const [],
  void Function(web.Event event)? onClick,
}) =>
    el('div',
        classes: classes, text: text, children: children, onClick: onClick);

web.HTMLElement span({String? classes, String? text}) =>
    el('span', classes: classes, text: text);

web.HTMLElement para({String? classes, String? text}) =>
    el('p', classes: classes, text: text);

web.HTMLElement heading(int level, String text, {String? classes}) =>
    el('h$level', classes: classes, text: text);

web.HTMLElement button(
  String label, {
  String? classes,
  required void Function() onPressed,
}) =>
    el(
      'button',
      classes: classes ?? 'btn',
      text: label,
      onClick: (_) => onPressed(),
    );

web.HTMLInputElement textInput({
  String? placeholder,
  String value = '',
  void Function(String value)? onInput,
}) {
  final input = web.document.createElement('input') as web.HTMLInputElement
    ..type = 'text'
    ..value = value;
  if (placeholder != null) input.placeholder = placeholder;
  if (onInput != null) {
    input.addEventListener(
      'input',
      ((web.Event _) => onInput(input.value)).toJS,
    );
  }
  return input;
}

String inputValue(web.HTMLElement input) {
  if (input.isA<web.HTMLInputElement>()) {
    return (input as web.HTMLInputElement).value;
  }
  if (input.isA<web.HTMLSelectElement>()) {
    return (input as web.HTMLSelectElement).value;
  }
  return '';
}

web.HTMLSelectElement dropdown(
  List<(String value, String label)> options, {
  String? selected,
}) {
  final select = web.document.createElement('select') as web.HTMLSelectElement;
  for (final (value, label) in options) {
    final option = web.document.createElement('option') as web.HTMLOptionElement
      ..value = value
      ..textContent = label;
    if (value == selected) option.selected = true;
    select.appendChild(option);
  }
  return select;
}

web.HTMLElement table(List<String> headers, List<List<web.Node>> rows) {
  final thead = el(
    'thead',
    children: [
      el('tr', children: [for (final h in headers) el('th', text: h)]),
    ],
  );
  final tbody = el(
    'tbody',
    children: [
      for (final row in rows)
        el('tr', children: [
          for (final cell in row) el('td', children: [cell])
        ]),
    ],
  );
  return el('table', classes: 'data-table', children: [thead, tbody]);
}

web.HTMLElement badge(String text, {String tone = 'neutral'}) =>
    span(classes: 'badge badge-$tone', text: text);

void replaceChildren(web.HTMLElement parent, List<web.Node> children) {
  while (parent.firstChild != null) {
    parent.removeChild(parent.firstChild!);
  }
  for (final child in children) {
    parent.appendChild(child);
  }
}

web.HTMLElement field(String label, web.HTMLElement control) => div(
      classes: 'field',
      children: [el('label', text: label), control],
    );
