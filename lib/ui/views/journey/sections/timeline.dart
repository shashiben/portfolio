part of '../journey_screen.dart';

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Row(
      children: [
        Container(width: 24, height: 2, color: c.accent),
        const SizedBox(width: 12),
        ScrambleText(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: c.textPrimary, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SizedBox(
            height: 10,
            child: LineDraw(
              strokeWidth: 1,
              duration: AppMotion.long,
              pathBuilder: (size) => Path()
                ..moveTo(0, size.height / 2)
                ..lineTo(size.width, size.height / 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _Timeline extends StatefulWidget {
  const _Timeline({required this.companies, required this.gutter});

  static const double _railWidth = 12;

  final List<Company> companies;
  final double gutter;

  @override
  State<_Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<_Timeline> {
  final ValueNotifier<double> _progress = ValueNotifier<double>(0);
  ScrollPosition? _position;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateProgress());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final position = Scrollable.maybeOf(context)?.position;
    if (!identical(position, _position)) {
      _position?.removeListener(_updateProgress);
      _position = position;
      _position?.addListener(_updateProgress);
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_updateProgress);
    _progress.dispose();
    super.dispose();
  }

  /// Line is drawn down to the point 75% of the way down the viewport.
  void _updateProgress() {
    if (!mounted) return;
    if (AppMotion.reduceMotion(context)) {
      _progress.value = 1;
      return;
    }
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || box.size.height <= 0) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final reach = MediaQuery.sizeOf(context).height * 0.75 - top;
    _progress.value = (reach / box.size.height).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final companies = widget.companies;
    final gutter = widget.gutter;
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 6,
          bottom: 0,
          width: _Timeline._railWidth,
          child: ValueListenableBuilder<double>(
            valueListenable: _progress,
            builder: (context, value, _) => LineDraw(pathBuilder: _verticalLine, progress: value, color: c.accent),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < companies.length; i++)
              Padding(
                padding: EdgeInsets.only(bottom: i == companies.length - 1 ? 0 : 40),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 22),
                      child: Container(
                        width: _Timeline._railWidth,
                        height: _Timeline._railWidth,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: c.accent,
                          border: Border.all(color: c.bg0, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(width: gutter),
                    Expanded(
                      child: Reveal(
                        begin: Offset(i.isEven ? 0.08 : -0.08, 0),
                        child: _CompanyCard(company: companies[i]),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
