import 'dart:io';

import 'package:dart_rss/domain/rss_feed.dart';
import 'package:dart_rss/domain/rss_item.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

const _feedUrl = 'https://medium.com/feed/@shashiben';

String _escape(String s) => s.replaceAll(r'\', r'\\').replaceAll("'", r"\'");

String _stripHtml(String html) {
  return html
      .replaceAll(RegExp(r'<[^>]*>'), ' ')
      .replaceAll(RegExp(r'&nbsp;'), ' ')
      .replaceAll(RegExp(r'&amp;'), '&')
      .replaceAll(RegExp(r'&lt;'), '<')
      .replaceAll(RegExp(r'&gt;'), '>')
      .replaceAll(RegExp(r'&quot;'), '"')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

String _formatDate(String? pubDate) {
  if (pubDate == null || pubDate.isEmpty) return '';
  try {
    final match = RegExp(r'(\d{1,2})\s+(\w{3})\s+(\d{4})').firstMatch(pubDate);
    if (match != null) {
      const months = {
        'Jan': 1,
        'Feb': 2,
        'Mar': 3,
        'Apr': 4,
        'May': 5,
        'Jun': 6,
        'Jul': 7,
        'Aug': 8,
        'Sep': 9,
        'Oct': 10,
        'Nov': 11,
        'Dec': 12,
      };
      final m = months[match.group(2)];
      if (m != null) {
        final d = int.tryParse(match.group(1) ?? '') ?? 0;
        final y = int.tryParse(match.group(3) ?? '') ?? 0;
        return '$y-${m.toString().padLeft(2, '0')}-${d.toString().padLeft(2, '0')}';
      }
    }
    final dt = DateTime.tryParse(pubDate);
    if (dt != null) {
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    }
  } catch (_) {}
  return pubDate;
}

String _excerpt(RssItem item) {
  final content = item.content?.value;
  if (content != null && content.isNotEmpty) {
    final plain = _stripHtml(content);
    if (plain.length > 140) return '${plain.substring(0, 140).trim()}…';
    return plain;
  }
  final desc = item.description;
  if (desc != null && desc.isNotEmpty) {
    final plain = _stripHtml(desc);
    if (plain.length > 140) return '${plain.substring(0, 140).trim()}…';
    return plain;
  }
  return '';
}

Future<void> main() async {
  final projectRoot = path.dirname(path.dirname(Platform.script.toFilePath()));
  final outputPath = path.join(
    projectRoot,
    'lib',
    'app',
    'constants',
    'data',
    'blogs.data.dart',
  );

  print('Fetching from Medium...');
  final response = await http.get(Uri.parse(_feedUrl)).timeout(
        const Duration(seconds: 15),
      );

  if (response.statusCode != 200) {
    print('Failed to fetch: ${response.statusCode}');
    exit(1);
  }

  final feed = RssFeed.parse(response.body);
  final buffer = StringBuffer();

  buffer.writeln("import '../../../core/models/blog_item.model.dart';");
  buffer.writeln();
  buffer.writeln("export '../../../core/models/blog_item.model.dart';");
  buffer.writeln();
  buffer.writeln('final List<BlogItem> blogList = [');

  for (final item in feed.items) {
    final title = item.title ?? 'Untitled';
    final link = item.link?.trim() ?? '';
    final excerpt = _excerpt(item);
    final date = _formatDate(item.pubDate);

    buffer.writeln('  BlogItem(');
    buffer.writeln("    title: '${_escape(title)}',");
    buffer.writeln("    excerpt: '${_escape(excerpt)}',");
    buffer.writeln(
        "    url: ${link.isNotEmpty ? "'${_escape(link)}'" : 'null'},");
    buffer.writeln("    date: ${date.isNotEmpty ? "'$date'" : 'null'},");
    buffer.writeln('  ),');
  }

  buffer.writeln('];');

  await File(outputPath).writeAsString(buffer.toString());
  print('Updated $outputPath with ${feed.items.length} articles.');
}
