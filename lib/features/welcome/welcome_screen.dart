import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/demo_pill.dart';
import '../../data/providers.dart';

/// S1 — the demo's front door. No login: one tap goes to the Dashboard.
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final bool _animate = ref.read(isFirstLaunchProvider);

  // First launch: illustration fades in (400 ms), then the text.
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
    value: _animate ? 0 : 1,
  );
  late final Animation<double> _art = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.5, curve: Curves.easeOut),
  );
  late final Animation<double> _text = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.5, 1, curve: Curves.easeOut),
  );

  @override
  void initState() {
    super.initState();
    if (_animate) _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _explore() => context.go(Routes.dashboard);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            const _Circle(top: -70, right: -60, size: 220),
            const _Circle(top: 260, left: -90, size: 180),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Scale the artwork on short screens so the button stays
                  // in view; full size from about 760 px tall.
                  final compact = constraints.maxHeight < 760;
                  final artHeight = (constraints.maxHeight * 0.29).clamp(
                    130.0,
                    220.0,
                  );
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: Space.xxl),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          compact ? Gap.h12 : Gap.h24,
                          FadeTransition(
                            opacity: _art,
                            child: SvgPicture.asset(
                              'assets/illustrations/welcome_woman.svg',
                              height: artHeight,
                              semanticsLabel:
                                  'Line drawing of a woman with leaves in her hair',
                            ),
                          ),
                          Gap.h16,
                          FadeTransition(
                            opacity: _text,
                            child: _Content(
                              onExplore: _explore,
                              autofocus: !_animate,
                              compact: compact,
                            ),
                          ),
                          compact ? Gap.h12 : Gap.h24,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.onExplore,
    required this.autofocus,
    required this.compact,
  });

  final VoidCallback onExplore;
  final bool autofocus;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/illustrations/leaf_mark.svg',
              height: 30,
              excludeFromSemantics: true,
            ),
            Gap.w4,
            const Flexible(
              child: Text(
                'MyParlour',
                style: AppText.logo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        Gap.h12,
        Text(
          'Manage your parlour\nbusiness easily',
          textAlign: TextAlign.center,
          maxLines: 2,
          style: AppText.logo.copyWith(
            fontSize: 20,
            color: AppColors.primary,
            height: 1.3,
          ),
        ),
        Gap.h12,
        Text(
          'Appointments, billing, customers, staff, inventory & reports '
          '— all in one place.',
          textAlign: TextAlign.center,
          style: AppText.body.copyWith(
            fontSize: 14,
            color: AppColors.textMuted,
          ),
        ),
        compact ? Gap.h12 : Gap.h20,
        SvgPicture.asset(
          'assets/illustrations/salon_tools.svg',
          height: compact ? 48 : 70,
          excludeFromSemantics: true,
        ),
        compact ? Gap.h16 : Gap.h24,
        PrimaryButton(
          key: const Key('welcome.explore'),
          label: 'Explore MyParlour',
          onPressed: onExplore,
          autofocus: autofocus,
        ),
        Gap.h16,
        const Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: Space.sm,
          runSpacing: Space.xs,
          children: [
            DemoPill(),
            Text('Sample data · no sign-in needed', style: AppText.caption),
          ],
        ),
      ],
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({this.top, this.left, this.right, required this.size});

  final double? top;
  final double? left;
  final double? right;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: AppColors.blushDeep,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
