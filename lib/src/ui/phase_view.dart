import 'package:web/web.dart' as web;

import '../skynet_system.dart';

abstract class PhaseView {
  PhaseView(this.system);
  final SkyNetSystem system;
  String get id;
  String get navLabel;
  String get title;
  String get subtitle;
  web.HTMLElement build();
}
