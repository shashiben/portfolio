import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../app/configs.dart';
import '../../../core/utils/ScreenUiHelper.dart';
import '../../../core/utils/adaptive.dart';
import '../../../core/utils/datetimeUtils.dart';
import '../../widgets/custom_scroller.dart';
import '../../widgets/experience_widget.dart';
import '../../widgets/trailing_widget.dart';
import 'experience_view_model.dart';

class ExperienceDesktopView extends HookWidget {
  final ScreenUiHelper? uiHelpers;
  final ExperienceViewModel? model;

  const ExperienceDesktopView({Key? key, this.uiHelpers, this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _scrollController = useScrollController();
    return Container(
      child: Row(
        children: [
          Container(
            width: assignWidth(
              context: context,
              fraction: 0.7,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: assignWidth(context: context, fraction: 0.04),
              vertical: assignHeight(context: context, fraction: 0.04),
            ),
            child: _buildExperience(context, _scrollController),
          ),
          SizedBox(
            width: assignWidth(
              context: context,
              fraction: 0.025,
            ),
          ),
          const Spacer(),
          TrailingInfo(
            width: assignWidth(
              context: context,
              fraction: 0.075,
            ),
            trailingWidget: CustomScroller(
              onUpTap: () {
                _scroll(_scrollController.position.minScrollExtent,
                    _scrollController);
              },
              onDownTap: () {
                _scroll(_scrollController.position.maxScrollExtent,
                    _scrollController);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperience(
      BuildContext context, ScrollController _scrollController) {
    return ExperienceTree(
      headTitle:
          '${DateTimeUtils().monthsList[DateTime.now().month]} - ${DateTime.now().year}',
      tailTitle: 'May - 2020',
      experienceData: PersonalDetails.experienceList,
      scrollController: _scrollController,
      widthOfTree: assignWidth(context: context, fraction: 0.62),
    );
  }

  _scroll(double offset, ScrollController _scrollController) {
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }
}
