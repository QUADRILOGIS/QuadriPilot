import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadri_pilot/core/l10n/app_localizations.dart';
import '../../../../data/models/wifi_network.model.dart';
import '../../../../logic/cubits/wifi_scan.cubit.dart';
import 'wifi_tile.widget.dart';

class WiFiListWidget extends StatelessWidget {
  const WiFiListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WiFiScanCubit, List<WiFiNetwork>>(
      builder: (context, wifiList) {
        final filteredList = wifiList
            .where((wifi) =>
                wifi.ssid.isNotEmpty &&
                wifi.ssid.toLowerCase().contains('quadripilot'))
            .toList();

        filteredList
            .sort((a, b) => b.signalStrength.compareTo(a.signalStrength));

        if (filteredList.isEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context).noWifiNetworks),
          );
        }

        return ListView.builder(
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            return WiFiTileWidget(
              wifi: filteredList[index],
              isConnected: filteredList[index].isConnected,
            );
          },
        );
      },
    );
  }
}
