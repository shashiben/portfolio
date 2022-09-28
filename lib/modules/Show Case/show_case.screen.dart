import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio/app/constants/colors.dart';
import 'package:portfolio/gen/assets.gen.dart';
import 'package:portfolio/modules/Show%20Case/show_case.view_model.dart';
import 'package:portfolio/widgets/logo.dart';
import 'package:flutter_next/flutter_next.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stacked/stacked.dart';

class ShowCaseScreen extends StatelessWidget {
  const ShowCaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ShowCaseViewModel>.reactive(
        viewModelBuilder: () => ShowCaseViewModel(),
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: context.width < 600
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(Assets.icons.menu,
                              color: ColorConfigs.iconColor),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: {
                        'Home': 0,
                        'About me': 1,
                        "Experience": 3,
                        "Projects": 4,
                        'Contact': 5
                      }
                          .entries
                          .map((e) => TextButton(
                              onPressed: () {
                                model.itemScrollController.scrollTo(
                                    index: e.value,
                                    duration: const Duration(
                                      milliseconds: 600,
                                    ));
                              },
                              child: Text(e.key)))
                          .toList()),
              leadingWidth: 400,
              leading: const LogoComponent(),
            ),
            backgroundColor: ColorConfigs.backgroundColor,
            body: ScrollablePositionedList.builder(
              itemCount: model.views.length,
              itemBuilder: (context, index) => model.views[index],
              itemPositionsListener: model.itemPositionsListener,
              itemScrollController: model.itemScrollController,
            ),
          );
        });
  }
}
