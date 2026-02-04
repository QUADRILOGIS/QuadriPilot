import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quadri_pilot/core/l10n/app_localizations.dart';
import 'package:quadri_pilot/logic/cubits/notifications.cubit.dart';
import 'package:quadri_pilot/ui/widgets/app_title.widget.dart';
import 'package:quadri_pilot/ui/widgets/language_menu_button.dart';
import 'package:quadri_pilot/ui/widgets/sync_status_chip.dart';

enum _AlertsFilter { all, alerts, warnings, read }

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  _AlertsFilter _filter = _AlertsFilter.all;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: AppTitle(title: l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: l10n.markAllRead,
            onPressed: () => context.read<NotificationsCubit>().markAllRead(),
          ),
          const LanguageMenuButton(),
        ],
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          final unreadCount = state.unreadCount;
          final items = _applyFilter(state.items, _filter);
          final grouped = _groupByDate(items);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Align(
                alignment: Alignment.centerRight,
                child: SyncStatusChip(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    l10n.notifications,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  if (unreadCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        l10n.unreadCount(unreadCount),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _FilterChip(
                    label: l10n.filterAll,
                    selected: _filter == _AlertsFilter.all,
                    onTap: () => setState(() => _filter = _AlertsFilter.all),
                  ),
                  _FilterChip(
                    label: l10n.filterAlerts,
                    selected: _filter == _AlertsFilter.alerts,
                    onTap: () => setState(() => _filter = _AlertsFilter.alerts),
                  ),
                  _FilterChip(
                    label: l10n.filterWarnings,
                    selected: _filter == _AlertsFilter.warnings,
                    onTap: () => setState(() => _filter = _AlertsFilter.warnings),
                  ),
                  _FilterChip(
                    label: l10n.filterRead,
                    selected: _filter == _AlertsFilter.read,
                    onTap: () => setState(() => _filter = _AlertsFilter.read),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (items.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(child: Text(l10n.noAlerts)),
                )
              else
                ...grouped.entries.expand((entry) {
                  final header = _dateHeader(context, entry.key, l10n, theme);
                  final cards = entry.value.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _AlertCard(item: item),
                    ),
                  );
                  return [
                    header,
                    const SizedBox(height: 8),
                    ...cards,
                  ];
                }),
            ],
          );
        },
      ),
    );
  }

  Map<DateTime, List<NotificationItem>> _groupByDate(
      List<NotificationItem> items) {
    final grouped = <DateTime, List<NotificationItem>>{};
    for (final item in items) {
      final date = DateTime(
        item.createdAt.year,
        item.createdAt.month,
        item.createdAt.day,
      );
      grouped.putIfAbsent(date, () => []).add(item);
    }
    return grouped;
  }

  Widget _dateHeader(
      BuildContext context, DateTime date, AppLocalizations l10n, ThemeData theme) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    String label;
    if (date == today) {
      label = l10n.todayLabel;
    } else if (date == yesterday) {
      label = l10n.yesterdayLabel;
    } else {
      final locale = Localizations.localeOf(context).toString();
      label = DateFormat.yMMMMd(locale).format(date);
    }
    return Text(
      label,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  List<NotificationItem> _applyFilter(
    List<NotificationItem> items,
    _AlertsFilter filter,
  ) {
    switch (filter) {
      case _AlertsFilter.alerts:
        return items
            .where((item) =>
                item.severity == NotificationSeverity.critical && !item.isRead)
            .toList();
      case _AlertsFilter.warnings:
        return items
            .where((item) =>
                item.severity == NotificationSeverity.warning && !item.isRead)
            .toList();
      case _AlertsFilter.read:
        return items.where((item) => item.isRead).toList();
      case _AlertsFilter.all:
        return items;
    }
  }
}

class _AlertCard extends StatelessWidget {
  final NotificationItem item;

  const _AlertCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isCritical = item.severity == NotificationSeverity.critical;
    final accent =
        isCritical ? const Color(0xFFEF4444) : const Color(0xFFF59E0B);
    final bg =
        isCritical ? const Color(0xFFFDECEC) : const Color(0xFFFFF4E5);
    final title = isCritical ? l10n.alertLabel : l10n.warningLabel;
    final time = _formatRelative(item.createdAt, l10n);
    final body = item.body.isEmpty
        ? (isCritical ? l10n.alertBodyCritical : l10n.alertBodyWarning)
        : item.body;

    return InkWell(
      onTap: () => context.read<NotificationsCubit>().markRead(item.id),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.isRead ? theme.colorScheme.surfaceContainerLowest : bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: item.isRead
                ? theme.colorScheme.outlineVariant
                : accent.withValues(alpha: 0.6),
            width: 1.2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isCritical ? Icons.warning : Icons.error,
                color: accent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.part,
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: accent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          title,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 16, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Text(
                        time,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (item.isRead) ...[
                        const Spacer(),
                        Icon(Icons.check,
                            size: 16,
                            color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          l10n.readLabel,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatRelative(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) {
      return l10n.relativeMinutes(diff.inMinutes);
    }
    if (diff.inHours < 24) {
      return l10n.relativeHours(diff.inHours);
    }
    return l10n.relativeDays(diff.inDays);
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: selected ? Colors.white : theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
