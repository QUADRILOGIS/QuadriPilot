import 'package:wifi_scan/wifi_scan.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/wifi_network.model.dart';
import 'package:network_info_plus/network_info_plus.dart';

class WiFiScanService {
  Future<List<WiFiNetwork>> scanWiFi() async {
    if (!await Permission.location.request().isGranted) return [];

    if (!await WiFiScan.instance.startScan()) return [];

    final networks = await WiFiScan.instance.getScannedResults();
    if (networks.isEmpty) return [];

    final currentSSID = await _getCurrentSSID();

    final Map<String, WiFiAccessPoint> bestNetworks = {};

    for (var wifi in networks) {
      if (!bestNetworks.containsKey(wifi.ssid) ||
          wifi.level > bestNetworks[wifi.ssid]!.level) {
        bestNetworks[wifi.ssid] = wifi;
      }
    }

    return bestNetworks.values
        .map((wifi) => WiFiNetwork.fromWiFiAccessPoint(
              wifi,
              isConnected: wifi.ssid == currentSSID,
            ))
        .toList();
  }

  Future<String?> _getCurrentSSID() async {
    final info = NetworkInfo();
    return await info.getWifiName();
  }
}
