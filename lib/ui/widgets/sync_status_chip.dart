import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadri_pilot/core/l10n/app_localizations.dart';
import 'package:quadri_pilot/data/services/api_config.service.dart';
import 'package:quadri_pilot/logic/cubits/api_sync.cubit.dart';
import 'package:http/http.dart' as http;

class SyncStatusChip extends StatelessWidget {
  const SyncStatusChip({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<ApiSyncCubit, ApiSyncState>(
      builder: (context, state) {
        final hasInternet = state.hasInternet;
        final pending = state.pendingCount;
        final bg = hasInternet
            ? theme.colorScheme.primary.withValues(alpha: 0.12)
            : theme.colorScheme.surfaceContainerHigh;
        final fg = hasInternet
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurfaceVariant;
        final label = hasInternet ? l10n.syncOnline : l10n.syncOffline;
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _openConfigDialog(context, l10n),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  hasInternet ? Icons.cloud_done : Icons.cloud_off,
                  size: 16,
                  color: fg,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: fg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (pending > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      l10n.syncPending(pending),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openConfigDialog(
      BuildContext context, AppLocalizations l10n) async {
    final theme = Theme.of(context);
    final config = ApiConfigService();
    final baseUrl = await config.getBaseUrl();
    if (!context.mounted) return;
    final controller = TextEditingController(text: baseUrl);

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.apiBaseUrlTitle),
          content: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.apiBaseUrlHelp,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: l10n.apiBaseUrlHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: BlocBuilder<ApiSyncCubit, ApiSyncState>(
                    builder: (context, state) {
                      if (state.lastError == null) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _CountPill(
                                label: l10n.pendingIncidents,
                                count: state.pendingIncidents,
                              ),
                              const SizedBox(width: 8),
                              _CountPill(
                                label: l10n.pendingGps,
                                count: state.pendingGps,
                              ),
                            ],
                          ),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _CountPill(
                                  label: l10n.pendingIncidents,
                                  count: state.pendingIncidents,
                                ),
                                const SizedBox(width: 8),
                                _CountPill(
                                  label: l10n.pendingGps,
                                  count: state.pendingGps,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.syncLastError(state.lastError!),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () async {
                final value = controller.text.trim();
                if (value.isNotEmpty) {
                  await config.setBaseUrl(value);
                }
                if (!context.mounted) return;
                final health = await config.getHealthUrl();
                final ok = await _testHealth(health);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      ok ? l10n.apiTestOk : l10n.apiTestFailed,
                    ),
                  ),
                );
              },
              child: Text(l10n.apiTest),
            ),
            ElevatedButton(
              onPressed: () async {
                final value = controller.text.trim();
                if (value.isNotEmpty) {
                  await config.setBaseUrl(value);
                }
                if (!context.mounted) return;
                Navigator.pop(context);
                context.read<ApiSyncCubit>().refresh();
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _testHealth(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 5));
      return response.statusCode >= 200 && response.statusCode < 400;
    } catch (_) {
      return false;
    }
  }
}

class _CountPill extends StatelessWidget {
  final String label;
  final int count;

  const _CountPill({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = theme.colorScheme.onSurface;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $count',
        style: theme.textTheme.labelSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
