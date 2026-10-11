import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/dates.dart';
import '../../core/l10n/l10n.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/demo_pill.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/language_picker.dart';
import '../../core/l10n/language_controller.dart';
import '../../core/l10n/app_language.dart';
import '../../domain/models/parlour.dart';
import 'settings_controller.dart';

/// S18 — Settings.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parlour = ref.watch(parlourProvider);
    return Scaffold(
      appBar: AppTopBar(title: context.l10n.settingsTitle),
      body: switch (parlour) {
        AsyncValue(:final value?) => _Body(parlour: value),
        AsyncValue(:final error?) => Center(
          child: EmptyState(
            icon: Icons.error_outline_rounded,
            message: context.l10n.settingsLoadError('$error'),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.parlour});

  final Parlour parlour;

  Future<void> _reset(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final ok = await ConfirmDialog.show(
      context,
      title: l10n.settingsResetTitle,
      message: l10n.settingsResetMessage,
      confirmLabel: l10n.settingsResetConfirm,
      destructive: true,
    );
    if (!ok) return;
    await ref.read(settingsActionsProvider).resetDemo();
    if (context.mounted) showMessage(context, context.l10n.settingsResetDone);
  }

  Future<void> _startEmpty(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final ok = await ConfirmDialog.show(
      context,
      title: l10n.settingsEmptyTitle,
      message: l10n.settingsEmptyMessage(l10n.settingsResetDemo),
      confirmLabel: l10n.settingsStartEmpty,
      destructive: true,
    );
    if (!ok) return;
    await ref.read(settingsActionsProvider).startEmpty();
    if (context.mounted) showMessage(context, context.l10n.settingsEmptyDone);
  }

  Future<void> _chooseLanguage(
    BuildContext context,
    WidgetRef ref,
    AppLanguage language,
  ) async {
    await ref.read(settingsActionsProvider).chooseLanguage(language);
    // Shown after the switch, so it appears in the new language.
    if (context.mounted) {
      showMessage(
        context,
        lookupAppLocalizations(language.locale).languageChanged,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final p = parlour;
    final day = DateTime(2024);
    final days = [
      for (var d = 1; d <= 7; d++)
        if (p.openDays.contains(d)) Dates.weekdayShort(DateTime(2024, 1, d)),
    ].join(', ');
    final version = ref.watch(appVersionProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Space.screen,
        Space.sm,
        Space.screen,
        Space.xxl,
      ),
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.languageTitle, style: AppText.sectionTitle),
              Gap.h12,
              LanguagePicker(
                selected: ref.watch(languageProvider),
                onChanged: (language) =>
                    _chooseLanguage(context, ref, language),
              ),
            ],
          ),
        ),
        Gap.h12,
        _Section(
          title: l10n.settingsProfile,
          onEdit: () => context.push(Routes.settingsProfile),
          rows: [
            (l10n.settingsName, p.name),
            (l10n.settingsOwner, p.ownerName),
            (l10n.settingsPhone, p.phone),
            (l10n.settingsArea, p.area),
            (l10n.settingsAddress, p.address ?? l10n.commonNotAdded),
          ],
        ),
        Gap.h12,
        _Section(
          title: l10n.settingsBusinessHours,
          onEdit: () => context.push(Routes.settingsHours),
          rows: [
            (l10n.settingsOpenDays, days.isEmpty ? l10n.commonNone : days),
            (
              l10n.settingsHours,
              l10n.settingsTimeRange(
                Dates.time(p.openTime.on(day)),
                Dates.time(p.closeTime.on(day)),
              ),
            ),
            (l10n.settingsBookingSlots, l10n.commonMinutes(p.slotMinutes)),
          ],
        ),
        Gap.h12,
        _Section(
          title: l10n.settingsBillingTax,
          onEdit: () => context.push(Routes.settingsBilling),
          rows: [
            (l10n.settingsInvoicePrefix, p.invoicePrefix),
            (
              l10n.settingsGst,
              p.taxEnabled ? l10n.settingsOn : l10n.settingsOff,
            ),
            if (p.taxEnabled) ...[
              (l10n.settingsGstin, p.gstin ?? l10n.commonNotAdded),
              (l10n.settingsDefaultRate, '${p.defaultTaxRateBp ~/ 100}%'),
              (
                l10n.settingsPricesIncludeGst,
                p.pricesIncludeTax ? l10n.settingsYes : l10n.settingsNo,
              ),
            ],
            (l10n.settingsReceiptFooter, p.receiptFooter),
          ],
        ),
        Gap.h12,
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(l10n.uiDemo, style: AppText.sectionTitle),
                  Gap.w8,
                  const DemoPill(),
                ],
              ),
              Gap.h8,
              Text(
                l10n.settingsDemoNote,
                style: AppText.body.copyWith(color: AppColors.textMuted),
              ),
              Gap.h8,
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.restart_alt_rounded),
                title: Text(l10n.settingsResetDemo),
                subtitle: Text(l10n.settingsResetDemoHint),
                onTap: () => _reset(context, ref),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.cleaning_services_outlined),
                title: Text(l10n.settingsStartEmpty),
                subtitle: Text(l10n.settingsStartEmptyHint),
                onTap: () => _startEmpty(context, ref),
              ),
            ],
          ),
        ),
        Gap.h12,
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.settingsAbout, style: AppText.sectionTitle),
              Gap.h8,
              Text(
                '${l10n.appName} ${version.value ?? ''}'.trim(),
                style: AppText.bodyStrong,
              ),
              Gap.h4,
              Text(
                l10n.settingsAboutNote,
                style: AppText.body.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.onEdit,
    required this.rows,
  });

  final String title;
  final VoidCallback onEdit;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        Space.lg,
        Space.xs,
        Space.xs,
        Space.md,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: AppText.sectionTitle)),
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: Text(context.l10n.commonEdit),
              ),
            ],
          ),
          for (final (label, value) in rows)
            Padding(
              padding: const EdgeInsets.only(
                right: Space.md,
                top: 4,
                bottom: 4,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 130,
                    child: Text(label, style: AppText.label),
                  ),
                  Expanded(
                    child: Text(
                      value,
                      textAlign: TextAlign.end,
                      style: AppText.body,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
