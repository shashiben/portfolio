class BlogItem {
  const BlogItem({
    required this.title,
    required this.excerpt,
    this.url,
    this.date,
  });

  final String title;
  final String excerpt;
  final String? url;
  final String? date;
}
