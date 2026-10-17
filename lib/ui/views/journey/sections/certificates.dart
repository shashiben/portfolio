part of '../journey_screen.dart';

class _CertificateStrip extends StatelessWidget {
  const _CertificateStrip();

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final theme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < certificateList.length; i++) ...[
            if (i > 0) const SizedBox(width: 16),
            Builder(
              builder: (context) {
                final cert = certificateList[i];
                final url = cert.url;
                return SizedBox(
                  width: 220,
                  height: 150,
                  child: TiltCard(
                    onTap: url == null ? null : () => locator.get<UrlLauncherService>().open(url),
                    child: HudFrame(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (cert.issuer ?? 'CERT').toUpperCase(),
                            style: theme.labelSmall?.copyWith(color: c.accent, letterSpacing: 1.6),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Text(
                              cert.name,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: theme.titleSmall?.copyWith(color: c.textPrimary, fontWeight: FontWeight.w600),
                            ),
                          ),
                          if (url != null)
                            Text(
                              'VIEW ↗',
                              style: theme.labelSmall?.copyWith(color: c.textTertiary, letterSpacing: 1.4),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
