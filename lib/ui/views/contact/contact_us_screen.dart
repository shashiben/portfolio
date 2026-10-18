import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/constants/data/my_info.data.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../../../core/services/url_launcher_service.dart';
import '../../../widgets/chrome/footer.dart';
import '../../../widgets/fx/fx.dart';
import '../../../widgets/fx/fx_common.dart';

part 'contact_us_screen.viewmodel.dart';
part 'sections/terminal.dart';
part 'sections/orbit.dart';

class ContactUsScreen extends StackedView<ContactUsScreenViewModel> {
  const ContactUsScreen({super.key});

  @override
  Widget builder(BuildContext context, ContactUsScreenViewModel viewModel, Widget? child) {
    final c = context.appColors;
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= 800;
    final mono = GoogleFonts.jetBrainsMono();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: wide ? 64 : 24, vertical: wide ? 64 : 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScrambleText(
                  'Contact',
                  style: Theme.of(context).textTheme.displayMedium
                      ?.copyWith(color: c.textPrimary, fontWeight: FontWeight.w700, fontSize: wide ? 48 : 36),
                ),
                const SizedBox(height: 32),
                if (wide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Reveal(child: _Terminal(onOpen: viewModel.open)),
                      ),
                      const SizedBox(width: 48),
                      Reveal(
                        delay: const Duration(milliseconds: 150),
                        child: _SocialOrbit(onOpen: viewModel.open),
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Reveal(child: _Terminal(onOpen: viewModel.open)),
                      const SizedBox(height: 40),
                      Center(
                        child: Reveal(
                          delay: const Duration(milliseconds: 150),
                          child: _SocialOrbit(onOpen: viewModel.open),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 40),
                Text('> voice line', style: mono.copyWith(color: c.textTertiary, fontSize: 12)),
                const SizedBox(height: 4),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => viewModel.open(viewModel.phoneLink),
                    child: Text(MYInfo.phone, style: mono.copyWith(color: c.textPrimary, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
          const SiteFooter(),
        ],
      ),
    );
  }

  @override
  ContactUsScreenViewModel viewModelBuilder(BuildContext context) => ContactUsScreenViewModel();
}
