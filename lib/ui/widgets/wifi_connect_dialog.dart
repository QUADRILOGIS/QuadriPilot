import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_settings/app_settings.dart';
import 'package:quadri_pilot/core/l10n/app_localizations.dart';
import 'package:quadri_pilot/data/enum/default_values.enum.dart';
import 'package:quadri_pilot/data/models/connection_state.model.dart' as state;
import 'package:quadri_pilot/data/services/tcp_exchanges/tcp_client.service.dart';
import 'package:quadri_pilot/logic/cubits/connection.cubit.dart' as tcp;
import 'package:quadri_pilot/logic/cubits/page.cubit.dart';
import 'package:quadri_pilot/logic/cubits/sensors.cubit.dart';
import 'package:quadri_pilot/logic/cubits/wifi_scan.cubit.dart';

class WifiConnectDialog extends StatefulWidget {
  const WifiConnectDialog({super.key});

  @override
  State<WifiConnectDialog> createState() => _WifiConnectDialogState();
}

class _WifiConnectDialogState extends State<WifiConnectDialog> {
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    context.read<WiFiScanCubit>().startConnectionCheck();
    Future.microtask(() {
      if (mounted) {
        context.read<WiFiScanCubit>().scanWiFiNetworks();
      }
    });
  }

  @override
  void dispose() {
    context.read<WiFiScanCubit>().stopConnectionCheck();
    super.dispose();
  }

  Future<void> _connectToBoard() async {
    setState(() => _isConnecting = true);
    final tcpService = TcpClientService(
      host: DefaultValues.IP,
      port: DefaultValues.PORT,
      connectionCubit: context.read<tcp.ConnectionCubit>(),
      sensorsCubit: context.read<SensorsCubit>(),
      pageCubit: context.read<PageCubit>(),
    );

    await tcpService.connect();
    final isConnected = tcpService.isConnected;

    if (mounted) {
      setState(() => _isConnecting = false);
    }

    if (isConnected && mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _openWiFiSettings() async {
    await AppSettings.openAppSettings(type: AppSettingsType.wifi);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.wifi,
                  color: theme.colorScheme.primary, size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.connectDialogTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.connectDialogBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            BlocBuilder<tcp.ConnectionCubit, state.ConnectionState>(
              builder: (context, connectionState) {
                final isConnected =
                    connectionState.status == state.ConnectionStatus.connected;
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isConnecting
                        ? null
                        : () async {
                            if (isConnected) {
                              Navigator.of(context).pop();
                            } else {
                              await _connectToBoard();
                            }
                          },
                    icon: _isConnecting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.wifi),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    label: Text(
                      isConnected ? l10n.goHome : l10n.connectToDevice,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _openWiFiSettings,
                icon: const Icon(Icons.settings),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  side: BorderSide(color: theme.colorScheme.primary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                label: Text(
                  l10n.configureWifi,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.connectDialogFooter,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
