import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../../widgets/chrome/app_bar.dart';
import '../../../widgets/chrome/boot_overlay.dart';
import '../../../widgets/fx/fx.dart';
import '../../../widgets/omnitrix/omnitrix.dart';
import '../../../widgets/three_d/three_d.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // attach() reads MediaQuery, so it can't run in initState.
    QualityGate.instance.attach(context);
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.viewPaddingOf(context);
    final compact = MediaQuery.sizeOf(context).shortestSide < 600;
    return Scaffold(
      body: OmniCursor(
        child: Stack(
          children: [
            const Positioned.fill(child: EnergyBackground(child: SizedBox.expand())),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppBarWidget(),
                Expanded(child: widget.navigationShell),
              ],
            ),
            Positioned(right: 16 + pad.right, bottom: (compact ? 28 : 16) + pad.bottom, child: const OmnitrixDock()),
            const Positioned.fill(child: IgnorePointer(child: TransformFlash())),
            const Positioned.fill(child: OmniBootOverlay()),
          ],
        ),
      ),
    );
  }
}
