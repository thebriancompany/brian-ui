import 'package:web/web.dart' as web;

void openSiteLink(String path) {
  final uri = Uri.parse(web.document.baseURI).resolve(path);
  if (uri.scheme != 'http' && uri.scheme != 'https') return;
  web.window.location.assign(uri.toString());
}
