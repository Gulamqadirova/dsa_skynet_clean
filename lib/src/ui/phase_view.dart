import 'package:web/web.dart' as web;

import '../skynet_system.dart';

/// A single screen of the application. Each phase of the brief is one view.
///
/// Views are rebuilt fresh every time they are navigated to, so they always
/// reflect the live state of the [SkyNetSystem] they are handed.
abstract class PhaseView {
  PhaseView(this.system);

  /// The shared backend façade. Views talk to its services only.
  final SkyNetSystem system;

  /// Stable identifier used for navigation.
  String get id;

  /// Short navigation label.
  String get navLabel;

  /// Full screen title.
  String get title;

  /// One-line description shown under the title.
  String get subtitle;

  /// Builds the screen's content element.
  web.HTMLElement build();
}
