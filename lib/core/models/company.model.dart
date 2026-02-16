class ExperienceSubEntry {
  const ExperienceSubEntry({
    required this.period,
    required this.points,
    this.title,
    this.awardIds = const [],
  });

  final String period;
  final List<String> points;
  final String? title;

  /// Award IDs from [awardList] received during this role (by date).
  final List<String> awardIds;
}

class Company {
  const Company({
    required this.name,
    required this.period,
    this.points = const [],
    this.image,
    this.subEntries = const [],
    this.isCurrent = false,
  });

  final String name;
  final String period;
  final List<String> points;
  final String? image;
  final List<ExperienceSubEntry> subEntries;
  final bool isCurrent;
}
