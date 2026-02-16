import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../app/constants/data/awards.data.dart';
import '../../../app/constants/route_constants.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../../../app/tokens/tokens.dart';
import '../../../core/services/url_launcher_service.dart';
import '../../../widgets/components/page_shell.dart';
import '../../../widgets/components/section_header.dart';

part 'awards_screen.viewmodel.dart';

class AwardsScreen extends StackedView<AwardsScreenViewModel> {
  const AwardsScreen({super.key});

  @override
  Widget builder(
    BuildContext context,
    AwardsScreenViewModel viewModel,
    Widget? child,
  ) {
    final highlightId = GoRouterState.of(context).uri.queryParameters['id'];
    return _AwardsContent(highlightId: highlightId);
  }

  @override
  AwardsScreenViewModel viewModelBuilder(BuildContext context) =>
      AwardsScreenViewModel();
}

class _AwardsContent extends StatefulWidget {
  const _AwardsContent({this.highlightId});

  final String? highlightId;

  @override
  State<_AwardsContent> createState() => _AwardsContentState();
}

class _AwardsContentState extends State<_AwardsContent> {
  final Map<String, GlobalKey> _cardKeys = {
    for (final a in awardList) a.id: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToHighlight());
  }

  void _scrollToHighlight() {
    final id = widget.highlightId;
    if (id == null || id.isEmpty) return;
    final key = _cardKeys[id];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: 0.2,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return SingleChildScrollView(
      child: PageShell(
        maxWidth: 560,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: SpacingTokens.lg),
            SectionHeader(
              title: 'Awards',
              subtitle: 'Recognition and achievements.',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => router.go(RouteConstants.about),
                style: IconButton.styleFrom(
                  foregroundColor: c.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: SpacingTokens.xxl),
            ...awardList.map(
              (award) => Padding(
                key: _cardKeys[award.id],
                padding: const EdgeInsets.only(bottom: SpacingTokens.md),
                child: _AwardCard(
                  item: award,
                  onOpen: award.url != null
                      ? () => locator.get<UrlLauncherService>().open(award.url!)
                      : null,
                  isHighlighted: award.id == widget.highlightId,
                ),
              ),
            ),
            const SizedBox(height: SpacingTokens.xxl),
          ],
        ),
      ),
    );
  }
}

class _AwardCard extends StatelessWidget {
  const _AwardCard({
    required this.item,
    this.onOpen,
    this.isHighlighted = false,
  });
  final AwardItem item;
  final VoidCallback? onOpen;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      padding: const EdgeInsets.all(SpacingTokens.lg),
      decoration: BoxDecoration(
        color: c.bg2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted ? c.accent : c.line,
          width: isHighlighted ? 2 : 1,
        ),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: c.accent.withAlpha(40),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c.accent.withAlpha(38),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.emoji_events_outlined,
              color: c.accent,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: c.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (item.issuer != null || item.year != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    [
                      if (item.issuer != null) item.issuer!,
                      if (item.year != null) item.year!,
                    ].join(' · '),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: c.textTertiary,
                        ),
                  ),
                ],
                if (item.description != null &&
                    item.description!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.description!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: c.textSecondary,
                          height: 1.45,
                        ),
                  ),
                ],
              ],
            ),
          ),
          if (onOpen != null)
            IconButton(
              icon: const Icon(Icons.open_in_new_rounded, size: 20),
              onPressed: onOpen,
              style: IconButton.styleFrom(
                foregroundColor: c.accent,
              ),
            ),
        ],
      ),
    );
  }
}
