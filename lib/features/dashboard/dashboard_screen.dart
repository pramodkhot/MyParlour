import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/dates.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/header_band.dart';

/// Dashboard tab. Phase 1 shows the header band only; figures, quick
/// actions and lists arrive with the data layer (Phase 3).
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          HeaderBand(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MyParlour',
                  style: AppText.bodyStrong.copyWith(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
                Gap.h4,
                Text(
                  DateFormat('EEEE, d MMMM').format(now),
                  style: AppText.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                ),
                Gap.h16,
                Text(Greeting.forTime(now), style: AppText.greeting),
              ],
            ),
          ),
          const EmptyState(
            icon: Icons.space_dashboard_outlined,
            message:
                "Today's sales, appointments and alerts will show here "
                'in build phase 3.',
          ),
        ],
      ),
    );
  }
}
