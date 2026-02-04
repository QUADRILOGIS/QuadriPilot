import 'package:wifi_scan/wifi_scan.dart';

class WiFiNetwork {
  final String ssid;
  final int signalStrength;
  final bool isConnected;

  WiFiNetwork({
    required this.ssid,
    required this.signalStrength,
    required this.isConnected,
  });

  factory WiFiNetwork.fromWiFiAccessPoint(WiFiAccessPoint wifi,
      {required bool isConnected}) {
    return WiFiNetwork(
      ssid: wifi.ssid,
      signalStrength: wifi.level,
      isConnected: isConnected,
    );
  }

  WiFiNetwork copyWith({String? ssid, int? signalStrength, bool? isConnected}) {
    return WiFiNetwork(
      ssid: ssid ?? this.ssid,
      signalStrength: signalStrength ?? this.signalStrength,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}
