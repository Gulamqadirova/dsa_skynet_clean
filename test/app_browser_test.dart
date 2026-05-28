@TestOn('browser')
library;

import 'package:skynet/src/skynet_system.dart';
import 'package:skynet/src/ui/app.dart';
import 'package:test/test.dart';
import 'package:web/web.dart' as web;

/// A runtime smoke test that mounts the full UI in a real browser engine,
/// exercising every `package:web` interop call the dart2js compiler cannot
/// validate statically.
void main() {
  test('app mounts and renders the shell + default view', () {
    final root = web.document.createElement('div') as web.HTMLElement;
    SkyNetApp(SkyNetSystem.seeded()).mount(root);

    // Sidebar and content both present.
    expect(root.querySelector('.sidebar'), isNotNull);
    expect(root.querySelector('.content'), isNotNull);
    // Brand and all nav items rendered.
    expect(root.querySelector('.brand-name')?.textContent, 'SkyNet');
    expect(root.querySelectorAll('.nav-item').length, 7);
    // Default page is the overview dashboard.
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
    // The network view renders interactive controls.
    expect(root.querySelectorAll('select').length, greaterThan(0));
    expect(root.querySelectorAll('.btn').length, greaterThan(0));
  });
}
