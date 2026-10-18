import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import '../../../app/app.router.dart';
import '../../../app/constants/data/awards.data.dart';
import '../../../app/constants/data/education.data.dart';
import '../../../app/constants/data/skill.data.dart';
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

double _parallaxOf(BuildContext context, double offset) {
  if (AppMotion.reduceMotion(context) || MediaQuery.sizeOf(context).width < _breakpoint) return 0;
  return (offset * 0.12).clamp(-28.0, 48.0);
}

class HomeScreen extends StackedView<HomeScreenViewModel> {
  const HomeScreen({super.key});

  @override
  Widget builder(BuildContext context, HomeScreenViewModel viewModel, Widget? child) {
    final pad = _isWide(context) ? 64.0 : 24.0;
    return _HomeScroll(
      pad: pad,
      onContact: () => viewModel.openRoute(RouteConstants.contact),
      onWork: () => viewModel.openRoute(RouteConstants.work),
    );
  }

  @override
  HomeScreenViewModel viewModelBuilder(BuildContext context) => HomeScreenViewModel();
}

class _HomeScroll extends StatefulWidget {
  const _HomeScroll({required this.pad, required this.onContact, required this.onWork});

  final double pad;
  final VoidCallback onContact;
  final VoidCallback onWork;

  @override
  State<_HomeScroll> createState() => _HomeScrollState();
}

class _HomeScrollState extends State<_HomeScroll> {
  final ScrollController _scroll = ScrollController();
  final ValueNotifier<double> _offset = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() => _offset.value = _scroll.offset);
  }

  @override
  void dispose() {
    _scroll.dispose();
    _offset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scroll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.pad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Hero(parallax: _offset, onContact: widget.onContact, onWork: widget.onWork),
                _Origin(parallax: _offset),
                const _Roster(),
                const _DnaRecord(),
                const SizedBox(height: 96),
              ],
            ),
          ),
          const SiteFooter(),
        ],
      ),
    );
  }
}

class _Roster extends StatelessWidget {
  const _Roster();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _SectionTitle('Skills', metric: skillList.length),
      const SkillGalaxy(),
    ],
  );
}
