class AwardItem {
  const AwardItem({
    required this.id,
    required this.name,
    this.issuer,
    this.year,
    this.description,
    this.url,
  });

  final String id;
  final String name;
  final String? issuer;
  final String? year;
  final String? description;
  final String? url;
}

final List<AwardItem> awardList = [
  const AwardItem(
    id: 'mvp_may_2021',
    name: 'Most Valued Performer',
    issuer: 'Webknot Technologies',
    year: 'May 2021',
    description:
        'Certified as Most Valued Performer for excellent effort contributed to Hubble Project at Webknot Technologies Pvt Ltd, Bengaluru.',
  ),
  const AwardItem(
    id: 'spot_award_oct_2021',
    name: 'Spot Award',
    issuer: 'Webknot Technologies',
    year: 'Oct 2021',
    description:
        'Awarded for exceptional performance in recognized times on multiple projects at Webknot Technologies Pvt Ltd, Bengaluru.',
  ),
  const AwardItem(
    id: 'mvp_oct_2022',
    name: 'MVP OCT 2022',
    issuer: 'Webknot Technologies',
    year: 'Oct 2022',
    description: 'Received MVP for excellent contribution towards the project U-Space.',
  ),
  const AwardItem(
    id: 'spot_award_jan_2023',
    name: 'Spot Award Jan 2023',
    issuer: 'Webknot Technologies',
    year: 'Jan 2023',
    description: 'Received Spot award for performance in the project Quadraverse.',
  ),
  const AwardItem(
    id: 'spot_award_sep_2023',
    name: 'Spot Award September 2023',
    issuer: 'Betsol & Avaya',
    year: 'Sep 2023',
    description: 'Received for exceptional performance with Betsol & Avaya Client.',
  ),
  const AwardItem(
    id: 'spot_award_betsol_apr_2024',
    name: 'Spot Award from Betsol',
    issuer: 'Betsol',
    year: 'Apr 2024',
    description: 'Received for exceptional performance for Avaya CCaaS SDK development.',
  ),
  const AwardItem(
    id: 'spot_award_sep_2024',
    name: 'Spot Award September 2024',
    year: 'Sep 2024',
  ),
];

/// Lookup awards by ID for experience sub-entry linking.
AwardItem? getAwardById(String id) {
  try {
    return awardList.firstWhere((a) => a.id == id);
  } catch (_) {
    return null;
  }
}
