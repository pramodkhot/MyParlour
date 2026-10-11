import 'package:flutter/material.dart';

import '../../../core/design/colors.dart';
import '../../../core/design/spacing.dart';
import '../../../core/design/typography.dart';
import '../../../core/format/dates.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/avatar_initials.dart';
import '../../../core/widgets/header_band.dart';
import '../dashboard_controller.dart';
import 'alerts_sheet.dart';

/// Burgundy header: parlour, date, alerts bell and greeting.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.data,
    required this.bottomPadding,
    this.roundedBottom = true,
  });

  final DashboardData data;
  final double bottomPadding;
  final bool roundedBottom;

  @override
  Widget build(BuildContext context) {
    final parlour = data.parlour;
    return HeaderBand(
      bottomPadding: bottomPadding,
      roundedBottom: roundedBottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _HeaderAvatar(name: parlour.name),
              Gap.w12,
              Expanded(
                child: InkWell(
                  borderRadius: Radii.controlAll,
                  onTap: () => _showParlourSheet(context),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: Space.tapTarget,
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            parlour.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.bodyStrong.copyWith(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down_rounded, size: 22),
                      ],
                    ),
                  ),
                ),
              ),
              _AlertsBell(
                hasAlerts: data.summary.hasAlerts,
                onTap: () => AlertsSheet.show(context, data.summary),
              ),
            ],
          ),
          Gap.h4,
          Text(
            Dates.weekdayDayMonth(data.now),
            style: AppText.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 13,
            ),
          ),
          Gap.h8,
          Text(
            _greeting(context.l10n, data.now, parlour.ownerName),
            style: AppText.greeting,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  /// "Good morning" or "Good morning, Kavita".
  static String _greeting(AppLocalizations l10n, DateTime now, String? owner) {
    final name = owner?.trim() ?? '';
    return switch (Greeting.partOfDay(now)) {
      DayPart.morning =>
        name.isEmpty
            ? l10n.dashGreetingMorning
            : l10n.dashGreetingMorningNamed(name),
      DayPart.afternoon =>
        name.isEmpty
            ? l10n.dashGreetingAfternoon
            : l10n.dashGreetingAfternoonNamed(name),
      DayPart.evening =>
        name.isEmpty
            ? l10n.dashGreetingEvening
            : l10n.dashGreetingEveningNamed(name),
    };
  }

  void _showParlourSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.dashYourParlour, style: AppText.label),
              Gap.h12,
              Row(
                children: [
                  AvatarInitials(name: data.parlour.name),
                  Gap.w12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data.parlour.name, style: AppText.bodyStrong),
                        Text(data.parlour.area, style: AppText.caption),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primary,
                  ),
                ],
              ),
              Gap.h16,
              const Divider(),
              Gap.h12,
              Row(
                children: [
                  const Icon(
                    Icons.storefront_outlined,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                  Gap.w8,
                  Expanded(
                    child: Text(
                      context.l10n.dashMoreBranches,
                      style: AppText.body.copyWith(color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// First letters of the first two words: "Beauty Bliss Parlour" → "BB".
String _parlourInitials(String name) {
  final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
  final letters = words.take(2).map((w) => w[0].toUpperCase()).join();
  return letters.isEmpty ? '?' : letters;
}

class _HeaderAvatar extends StatelessWidget {
  const _HeaderAvatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
      ),
      child: Text(
        _parlourInitials(name),
        textScaler: TextScaler.noScaling,
        style: AppText.bodyStrong.copyWith(color: Colors.white, fontSize: 15),
      ),
    );
  }
}

class _AlertsBell extends StatelessWidget {
  const _AlertsBell({required this.hasAlerts, required this.onTap});

  final bool hasAlerts;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: hasAlerts ? context.l10n.dashAlertsNew : context.l10n.dashAlerts,
      onPressed: onTap,
      color: Colors.white,
      icon: Badge(
        isLabelVisible: hasAlerts,
        smallSize: 9,
        backgroundColor: AppColors.warningBg,
        child: const Icon(Icons.notifications_none_rounded),
      ),
    );
  }
}
