import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../app/constants/data/blogs.data.dart';
import '../../../app/constants/route_constants.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../../../app/tokens/tokens.dart';
import '../../../core/services/url_launcher_service.dart';
import '../../../widgets/components/page_shell.dart';
import '../../../widgets/components/section_header.dart';

part 'blogs_screen.viewmodel.dart';

class BlogsScreen extends StackedView<BlogsScreenViewModel> {
  const BlogsScreen({super.key});

  @override
  Widget builder(
    BuildContext context,
    BlogsScreenViewModel viewModel,
    Widget? child,
  ) {
    final c = context.appColors;
    return SingleChildScrollView(
      child: PageShell(
        maxWidth: 640,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: SpacingTokens.lg),
            SectionHeader(
              title: 'Blogs',
              subtitle: 'Articles and thoughts on development.',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => router.go(RouteConstants.about),
                style: IconButton.styleFrom(
                  foregroundColor: c.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: SpacingTokens.xxl),
            ...blogList.map(
              (blog) => Padding(
                padding: const EdgeInsets.only(bottom: SpacingTokens.md),
                child: _BlogCard(
                  item: blog,
                  onOpen: blog.url != null
                      ? () => locator.get<UrlLauncherService>().open(blog.url!)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: SpacingTokens.xxl),
          ],
        ),
      ),
    );
  }

  @override
  BlogsScreenViewModel viewModelBuilder(BuildContext context) =>
      BlogsScreenViewModel();
}

class _BlogCard extends StatelessWidget {
  const _BlogCard({required this.item, this.onOpen});
  final BlogItem item;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      padding: const EdgeInsets.all(SpacingTokens.lg),
      decoration: BoxDecoration(
        color: c.bg2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: c.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (item.date != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.date!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: c.textTertiary,
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
          const SizedBox(height: 8),
          Text(
            item.excerpt,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: c.textSecondary,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}
