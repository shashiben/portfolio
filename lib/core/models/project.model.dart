class Project {
  final String name;
  final String description;
  final String image;
  final String? demoUrl;
  final String? githubUrl;
  final List<String> technologies;
  final List<String> features;

  Project(
      {required this.name,
      required this.description,
      required this.image,
      this.demoUrl,
      this.githubUrl,
      this.features = const [],
      this.technologies = const []});
}
