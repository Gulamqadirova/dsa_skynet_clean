// A tiny dependency-free static file server for the compiled web app.
//
// Usage:
//   dart compile js web/main.dart -o web/main.dart.js
//   dart run tool/serve.dart            # then open http://localhost:8080
//
// Pass a port as the first argument to override the default 8080.
import 'dart:io';

const Map<String, String> _contentTypes = {
  '.html': 'text/html; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.map': 'application/json; charset=utf-8',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
};

Future<void> main(List<String> args) async {
  final port = args.isNotEmpty ? int.tryParse(args.first) ?? 8080 : 8080;
  final webDir = Directory('web');
  if (!webDir.existsSync()) {
    stderr.writeln('Run this from the project root (a web/ folder is required).');
    exit(1);
  }
  if (!File('web/main.dart.js').existsSync()) {
    stderr.writeln(
      'web/main.dart.js not found. Compile first:\n'
      '  dart compile js web/main.dart -o web/main.dart.js',
    );
    exit(1);
  }

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  stdout.writeln('SkyNet serving web/ at http://localhost:$port  (Ctrl+C to stop)');

  await for (final request in server) {
    await _handle(request, webDir);
  }
}

Future<void> _handle(HttpRequest request, Directory webDir) async {
  var path = request.uri.path;
  if (path == '/' || path.isEmpty) path = '/index.html';

  // Resolve safely within web/ to prevent path traversal.
  final resolved = File('${webDir.path}$path').absolute;
  final webRoot = webDir.absolute.path;
  if (!resolved.path.startsWith(webRoot) || !resolved.existsSync()) {
    request.response
      ..statusCode = HttpStatus.notFound
      ..write('404 Not Found: $path');
    await request.response.close();
    return;
  }

  final ext = path.substring(path.lastIndexOf('.'));
  request.response.headers.contentType =
      ContentType.parse(_contentTypes[ext] ?? 'application/octet-stream');
  await resolved.openRead().pipe(request.response);
}
