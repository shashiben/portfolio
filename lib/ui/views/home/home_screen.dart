import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import '../../../app/app.router.dart';
import '../../../app/constants/data/awards.data.dart';
import '../../../app/constants/data/education.data.dart';
import '../../../app/constants/data/my_info.data.dart';
import '../../../app/constants/route_constants.dart';
import '../../../app/theme/app_motion.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../../../gen/assets.gen.dart';
import '../../../widgets/chrome/footer.dart';
import '../../../widgets/fx/fx.dart';
import '../../../widgets/omnitrix/omnitrix.dart';
import '../../../widgets/three_d/three_d.dart';
import 'skill_galaxy/skill_galaxy.dart';

part 'home_screen.viewmodel.dart';
part 'sections/shared.dart';
part 'sections/hero.dart';
part 'sections/origin.dart';
part 'sections/dna.dart';

const double _breakpoint = 800;

bool _isWide(BuildContext context) => MediaQuery.sizeOf(context).width >= _breakpoint;

void _transformTo(String path) => transformController.play(atPeak: () => router.go(path));

class HomeScreen extends StackedView<HomeScreenViewModel> {
  const HomeScreen({super.key});

  @override
  Widget builder(BuildContext context, HomeScreenViewModel viewModel, Widget? child) {
    final pad = _isWide(context) ? 64.0 : 24.0;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: pad),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [_Hero(), _Origin(), _Roster(), _DnaRecord(), SizedBox(height: 96)],
            ),
          ),
          const SiteFooter(),
        ],
      ),
    );
  }

  @override
  HomeScreenViewModel viewModelBuilder(BuildContext context) => HomeScreenViewModel();
}

class _Roster extends StatelessWidget {
  const _Roster();

  @override
  Widget build(BuildContext context) =>
      const Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [_SectionTitle('Skills'), SkillGalaxy()]);
}
