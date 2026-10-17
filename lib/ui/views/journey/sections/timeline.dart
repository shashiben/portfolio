part of '../journey_screen.dart';

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Row(
      children: [
        Container(width: 24, height: 2, color: c.accent),
        const SizedBox(width: 12),
        ScrambleText(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: c.textPrimary, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({super.key, required this.companies, required this.progress, required this.gutter});

  static const double _railWidth = 12;

  final List<Company> companies;
  final ValueNotifier<double> progress;
  final double gutter;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 6,
          bottom: 0,
          width: _railWidth,
          child: ValueListenableBuilder<double>(
            valueListenable: progress,
            builder: (context, value, _) => LineDraw(pathBuilder: _verticalLine, progress: value, color: c.accent),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < companies.length; i++)
              Padding(
                padding: EdgeInsets.only(bottom: i == companies.length - 1 ? 0 : 40),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 22),
                      child: Container(
                        width: _railWidth,
                        height: _railWidth,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: c.accent,
                          border: Border.all(color: c.bg0, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(width: gutter),
                    Expanded(
                      child: Reveal(
                        begin: Offset(i.isEven ? 0.08 : -0.08, 0),
                        child: _CompanyCard(company: companies[i]),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
