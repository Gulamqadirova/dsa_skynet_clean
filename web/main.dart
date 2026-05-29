import 'package:skynet/src/skynet_system.dart';
import 'package:skynet/src/ui/app.dart';
import 'package:web/web.dart' as web;


void main() {
  final system = SkyNetSystem.seeded();
  final root = web.document.getElementById('app-root') as web.HTMLElement?;
  if (root == null) {
    throw StateError('index.html da #app-root elementi topilmadi');
  }
  SkyNetApp(system).mount(root);
}
