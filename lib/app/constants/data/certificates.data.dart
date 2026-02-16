class CertificateItem {
  const CertificateItem({
    required this.name,
    this.issuer,
    this.url,
  });

  final String name;
  final String? issuer;
  final String? url;
}

final List<CertificateItem> certificateList = [
  const CertificateItem(
    name: 'Convolutional Neural Networks',
    issuer: 'Coursera',
    url: 'https://www.coursera.org/account/accomplishments/certificate/4M6JSMCDDYAM',
  ),
  const CertificateItem(
    name: 'Basic Image Classification with TensorFlow',
    issuer: 'Coursera',
    url: 'https://www.coursera.org/account/accomplishments/certificate/89AY29KQPR7W',
  ),
  const CertificateItem(
    name: 'Image Data Augmentation with Keras',
    issuer: 'Coursera',
    url: 'https://www.coursera.org/account/accomplishments/certificate/VRLJ7VJP6A3P',
  ),
  const CertificateItem(
    name: 'Custom Prediction Routine on Google AI Platform',
    issuer: 'Coursera',
    url: 'https://www.coursera.org/account/accomplishments/certificate/7BZL6GYCQABH',
  ),
  const CertificateItem(
    name: 'The Essential Android O Developer Course (Java)',
    issuer: 'Udemy',
    url: 'https://www.udemy.com/certificate/UC-E6HSH204/',
  ),
  const CertificateItem(
    name: 'Problem Solving Certificate',
    issuer: 'HackerRank',
    url: 'https://www.hackerrank.com/certificates/59a8e49d679f',
  ),
  const CertificateItem(
    name: 'Cloud Computing',
    issuer: 'NPTEL',
    url:
        'https://archive.nptel.ac.in/content/noc/NOC20/SEM2/Ecertificates/106/noc20-cs65/Course/NPTEL20CS20S41850026095214.jpg',
  ),
];
