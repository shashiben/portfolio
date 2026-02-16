import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  Future<bool> open(String url) async {
    final uri = Uri.parse(url);
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
