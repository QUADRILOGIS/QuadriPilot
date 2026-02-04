import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/wifi_scan.service.dart';
import '../../data/models/wifi_network.model.dart';
import 'package:network_info_plus/network_info_plus.dart';

class WiFiScanCubit extends Cubit<List<WiFiNetwork>> {
  final WiFiScanService _wifiScanService;
  bool _isScanning = false;
  Timer? _wifiCheckTimer;
  String? connectedSSID;

  WiFiScanCubit(this._wifiScanService) : super([]);

  Future<void> scanWiFiNetworks() async {
    if (_isScanning) return;
    _isScanning = true;

    try {
      final currentSSID = await _getCurrentSSID();
      final sanitizedSSID = currentSSID?.replaceAll('"', '') ?? '';

      final newNetworks = await _wifiScanService.scanWiFi();

      if (newNetworks.isEmpty) {
        if (kDebugMode) {
          print("No networks found");
        }
        _isScanning = false;
        return;
      }

      final updatedNetworks = newNetworks.map((network) {
        return network.copyWith(isConnected: network.ssid == sanitizedSSID);
      }).toList();

      emit(updatedNetworks);
    } catch (e) {
      if (kDebugMode) {
        print("Error while scanning Wifi: $e");
      }
    } finally {
      _isScanning = false;
    }
  }

  void startConnectionCheck() {
    _wifiCheckTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      await checkConnectionStatus();
    });
  }

  Future<void> checkConnectionStatus() async {
    final currentSSID = await _getCurrentSSID();
    final sanitizedSSID = currentSSID?.replaceAll('"', '') ?? '';

    if (sanitizedSSID != connectedSSID) {
      connectedSSID = sanitizedSSID;
      final currentNetworks = state;
      final updatedNetworks = currentNetworks.map((network) {
        return network.copyWith(isConnected: network.ssid == sanitizedSSID);
      }).toList();
      isConnected = sanitizedSSID.isNotEmpty;
      emit(updatedNetworks);
    }
  }

  void stopConnectionCheck() {
    _wifiCheckTimer?.cancel();
  }

  Future<String?> _getCurrentSSID() async {
    final info = NetworkInfo();
    final ssid = await info.getWifiName();
    return ssid;
  }

  bool isConnected = false;
}
