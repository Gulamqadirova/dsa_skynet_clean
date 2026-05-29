@TestOn('browser')
library;

import 'package:skynet/src/skynet_system.dart';
import 'package:skynet/src/ui/app.dart';
import 'package:test/test.dart';
import 'package:web/web.dart' as web;

void main() {
  test('app mounts and renders the shell + default view', () {
    final root = web.document.createElement('div') as web.HTMLElement;
    SkyNetApp(SkyNetSystem.seeded()).mount(root);

    expect(root.querySelector('.sidebar'), isNotNull);
    expect(root.querySelector('.content'), isNotNull);
    expect(root.querySelector('.brand-name')?.textContent, 'SkyNet');
    expect(root.querySelectorAll('.nav-item').length, 7);
    expect(root.querySelector('.page-title')?.textContent, contains('SkyNet'));
  });

  test('navigating to a phase swaps the content view', () {
    final root = web.document.createElement('div') as web.HTMLElement;
    SkyNetApp(SkyNetSystem.seeded()).mount(root);

    final networkNav =
        root.querySelector('#nav-network') as web.HTMLElement?;
    expect(networkNav, isNotNull);
    networkNav!.click();

    expect(networkNav.className, contains('nav-active'));
    expect(
      root.querySelector('.page-title')?.textContent,
      contains('Global Navigation'),
    );
    expect(root.querySelectorAll('select').length, greaterThan(0));
    expect(root.querySelectorAll('.btn').length, greaterThan(0));
  });
}
