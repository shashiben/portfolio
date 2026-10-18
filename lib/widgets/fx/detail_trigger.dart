import 'package:flutter/material.dart';

import '../../app/app.locator.dart';
import '../../app/theme/app_theme_colors.dart';
import '../../core/services/url_launcher_service.dart';
import 'hud_frame.dart';
import 'magnetic_button.dart';

class DetailFact {
  const DetailFact(this.label, this.value);

  final String label;
  final String value;
}

class DetailLink {
  const DetailLink(this.label, this.url);

  final String label;
  final String url;
}

/// Tap target that opens [title] and its credentials in a dialog on wide
/// screens and a bottom sheet on mobile.
class DetailTrigger extends StatelessWidget {
  const DetailTrigger({
    super.key,
    required this.child,
    required this.title,
    this.kicker,
    this.description,
    this.facts = const [],
    this.links = const [],
    this.tags = const [],
  });

  final Widget child;
  final String title;
  final String? kicker;
  final String? description;
  final List<DetailFact> facts;
  final List<DetailLink> links;
  final List<String> tags;

  static const double _wide = 800;

  void _open(BuildContext context) {
    final spec = _DetailSpec(
      title: title,
      kicker: kicker,
      description: description,
      facts: [
        for (final fact in facts)
          if (fact.value.isNotEmpty) fact,
      ],
      links: [
        for (final link in links)
          if (link.url.isNotEmpty) link,
      ],
      tags: tags,
    );
    if (MediaQuery.sizeOf(context).width >= _wide) {
      showDialog<void>(
        context: context,
        barrierColor: const Color(0xB8000000),
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: _DetailPanel(spec: spec),
          ),
        ),
      );
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final colors = context.appColors;
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.bg0,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border(top: BorderSide(color: colors.accent.withValues(alpha: 0.45))),
            ),
            child: SafeArea(
              top: false,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.86),
                child: _DetailPanel(spec: spec, sheet: true),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Semantics(
        button: true,
        label: title,
        child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => _open(context), child: child),
      ),
    );
  }
}

class _DetailSpec {
  const _DetailSpec({
    required this.title,
    required this.facts,
    required this.links,
    required this.tags,
    this.kicker,
    this.description,
  });

  final String title;
  final String? kicker;
  final String? description;
  final List<DetailFact> facts;
  final List<DetailLink> links;
  final List<String> tags;
}

class _DetailPanel extends StatelessWidget {
  const _DetailPanel({required this.spec, this.sheet = false});

  final _DetailSpec spec;
  final bool sheet;

  @override
  Widget build(BuildContext context) {
    final framed = ColoredBox(
      color: context.appColors.bg0,
      child: HudFrame(
        padding: const EdgeInsets.fromLTRB(22, 16, 14, 22),
        child: _DetailBody(spec: spec),
      ),
    );
    if (!sheet) {
      final width = MediaQuery.sizeOf(context).width - 64;
      return SizedBox(
        width: width > 440 ? 440 : width,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.86),
          child: SingleChildScrollView(
            child: SizedBox(width: double.infinity, child: framed),
          ),
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(color: context.appColors.line, borderRadius: BorderRadius.circular(2)),
          ),
          Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 16), child: framed),
        ],
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.spec});

  final _DetailSpec spec;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final text = Theme.of(context).textTheme;
    final description = spec.description;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: spec.kicker == null
                  ? const SizedBox(height: 28)
                  : Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        spec.kicker!.toUpperCase(),
                        style: text.labelSmall?.copyWith(color: c.accent, letterSpacing: 1.6),
                      ),
                    ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 32, height: 32),
              icon: Icon(Icons.close, color: c.textTertiary, size: 18),
              tooltip: 'Close',
            ),
          ],
        ),
        Text(
          spec.title,
          style: text.titleLarge?.copyWith(color: c.textPrimary, fontWeight: FontWeight.w700),
        ),
        if (description != null && description.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(description, style: text.bodyMedium?.copyWith(color: c.textSecondary, height: 1.55)),
        ],
        if (spec.facts.isNotEmpty) ...[
          const SizedBox(height: 18),
          Wrap(
            spacing: 28,
            runSpacing: 14,
            children: [
              for (final fact in spec.facts)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      fact.label.toUpperCase(),
                      style: text.labelSmall?.copyWith(color: c.textTertiary, letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 4),
                    Text(fact.value, style: text.bodyMedium?.copyWith(color: c.textPrimary)),
                  ],
                ),
            ],
          ),
        ],
        if (spec.tags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final tag in spec.tags)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: c.accent.withValues(alpha: 0.08),
                    border: Border.all(color: c.accent.withValues(alpha: 0.25)),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(tag, style: text.labelSmall?.copyWith(color: c.accent)),
                ),
            ],
          ),
        ],
        if (spec.links.isNotEmpty) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final link in spec.links)
                MagneticButton(
                  onTap: () {
                    Navigator.of(context).pop();
                    locator.get<UrlLauncherService>().open(link.url);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Text('${link.label.toUpperCase()} ↗', style: text.labelLarge?.copyWith(color: c.accent)),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
