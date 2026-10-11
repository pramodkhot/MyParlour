import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/l10n/l10n.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/money_text.dart';
import '../../core/widgets/status_chip.dart';
import '../../domain/models/service_item.dart';
import 'services_controller.dart';

/// S16 — Services grouped by category.
class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void add() => context.push(Routes.newService);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppTopBar(
        title: l10n.servicesTitle,
        actions: [
          IconButton(
            tooltip: l10n.servicesAdd,
            onPressed: add,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.servicesAdd,
        onPressed: add,
        child: const Icon(Icons.add_rounded),
      ),
      body: switch (ref.watch(allServicesProvider)) {
        AsyncValue(:final value?) when value.isEmpty => SingleChildScrollView(
          child: EmptyState(
            icon: Icons.content_cut_rounded,
            message: l10n.servicesEmpty,
            actionLabel: l10n.servicesAdd,
            onAction: add,
          ),
        ),
        AsyncValue(:final value?) => _Groups(groups: groupServices(value)),
        AsyncValue(:final error?) => Center(
          child: EmptyState(
            icon: Icons.error_outline_rounded,
            message: l10n.servicesLoadError('$error'),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Groups extends StatelessWidget {
  const _Groups({required this.groups});

  final List<(String, List<ServiceItem>)> groups;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Space.screen,
        Space.xs,
        Space.screen,
        96,
      ),
      children: [
        for (final (category, services) in groups) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.xs, Space.md, 0, Space.sm),
            child: Text(
              context.l10n.builtIn(category),
              style: AppText.sectionTitle,
            ),
          ),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < services.length; i++) ...[
                  if (i > 0)
                    const Divider(indent: Space.lg, endIndent: Space.lg),
                  _ServiceRow(service: services[i]),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({required this.service});

  final ServiceItem service;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.editService(service.id)),
      child: Opacity(
        opacity: service.isActive ? 1 : 0.55,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Space.lg,
            vertical: 14,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(service.name, style: AppText.bodyStrong),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: AppColors.textMuted,
                        ),
                        Gap.w4,
                        Text(
                          context.l10n.duration(service.durationMin),
                          style: AppText.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!service.isActive) ...[
                StatusChip(
                  label: context.l10n.commonInactive,
                  tone: ChipTone.neutral,
                ),
                Gap.w8,
              ],
              MoneyText(service.pricePaise),
            ],
          ),
        ),
      ),
    );
  }
}
