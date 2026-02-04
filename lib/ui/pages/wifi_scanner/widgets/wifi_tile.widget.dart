import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:quadri_pilot/core/l10n/app_localizations.dart';
import '../../../../data/models/wifi_network.model.dart';

class WiFiTileWidget extends StatelessWidget {
  final WiFiNetwork wifi;
  final bool isConnected;

  const WiFiTileWidget(
      {super.key, required this.wifi, this.isConnected = false});

  Future<void> _openWiFiSettings() async {
    await AppSettings.openAppSettings(type: AppSettingsType.wifi);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => _openWiFiSettings(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.primary),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wifi.ssid,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Icon(Icons.circle,
                          size: 10,
                          color: isConnected
                              ? theme.colorScheme.primary
                              : Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        isConnected ? l10n.connected : l10n.notConnected,
                        style: TextStyle(
                            color: isConnected
                                ? theme.colorScheme.primary
                                : Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              _getWifiIcon(wifi.signalStrength),
              color: Colors.black54,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getWifiIcon(int signalStrength) {
    if (signalStrength > -80) {
      return Icons.wifi;
    } else if (signalStrength > -90) {
      return Icons.wifi_2_bar;
    } else {
      return Icons.wifi_1_bar;
    }
  }
}
