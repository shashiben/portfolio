part of '../home_screen.dart';

class _DnaRecord extends StatelessWidget {
  const _DnaRecord();

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle('Education', metric: educationList.length),
        RevealGroup(
          children: [
            for (var i = 0; i < educationList.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DetailTrigger(
                  kicker: 'Education',
                  title: educationList[i].institution,
                  description: educationList[i].degree,
                  facts: [
                    DetailFact('Period', educationList[i].period),
                    if (educationList[i].score != null) DetailFact('Score', educationList[i].score!),
                  ],
                  links: [if (educationList[i].url != null) DetailLink('Credential', educationList[i].url!)],
                  child: HudFrame(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                educationList[i].period,
                                style: text.labelSmall?.copyWith(color: c.accent, letterSpacing: 1.6),
                              ),
                            ),
                            if (educationList[i].score != null)
                              Text(
                                educationList[i].score!,
                                style: text.labelSmall?.copyWith(color: c.accent, letterSpacing: 1.6),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(educationList[i].institution, style: text.titleMedium?.copyWith(color: c.textPrimary)),
                        const SizedBox(height: 4),
                        Text(educationList[i].degree, style: text.bodyMedium?.copyWith(color: c.textSecondary)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
