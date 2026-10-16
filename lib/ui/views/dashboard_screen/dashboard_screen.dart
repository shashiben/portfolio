import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/fx/fx.dart';
import '../../../widgets/omnitrix.dart';
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
            const Positioned(bottom: 16, right: 16, child: OmnitrixDock()),
            const Positioned.fill(child: IgnorePointer(child: TransformFlash())),
          ],
        ),
      ),
    );
  }
}
