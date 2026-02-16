class EducationEntry {
  const EducationEntry({
    required this.institution,
    required this.degree,
    required this.period,
    this.score,
    this.url,
  });

  final String institution;
  final String degree;
  final String period;
  final String? score;
  final String? url;
}

final List<EducationEntry> educationList = [
  const EducationEntry(
    institution: 'Sri Venkateswara University, Tirupati',
    degree: 'B.Tech, Computer Science & Engineering',
    period: '2017 – 2021',
    score: '75.4%',
  ),
  const EducationEntry(
    institution: 'Sri Chaitanya Jr College',
    degree: 'Intermediate, MPC',
    period: '2015 – 2017',
    score: '93%',
  ),
  const EducationEntry(
    institution: 'Cattamanchi Ramalinga Reddy High School',
    degree: 'SSC',
    period: '2014 – 2015',
    score: '95.2%',
  ),
];
