import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:quadri_pilot/data/enum/default_values.enum.dart';
import 'package:quadri_pilot/data/services/tcp_exchanges/frame_receiver.service.dart';
import 'package:quadri_pilot/data/services/tcp_exchanges/sensors/gps_sensor.service.dart';
import 'package:quadri_pilot/data/services/tcp_exchanges/sensors/light_sensor.service.dart';
import 'package:quadri_pilot/logic/cubits/page.cubit.dart';
import '../../../logic/cubits/sensors.cubit.dart';
import '../../../logic/cubits/connection.cubit.dart';
import 'frame_sender.service.dart';

class TcpClientService {
  static TcpClientService? _instance;
  late Socket _socket;
  final String host;
  final int port;
  bool _isConnected = false;
  int _retryCount = 0;

  late FrameSenderService _frameSenderService;
  late FrameReceiverService _frameReceiverService;
  late GPSSensorService _gpsSensorService;
  late LightSensorService _lightSensorService;

  final ConnectionCubit connectionCubit;
  final SensorsCubit sensorsCubit;
  final PageCubit pageCubit;

  TcpClientService._internal(this.sensorsCubit, this.pageCubit,
      {required this.host, required this.port, required this.connectionCubit});

  factory TcpClientService({
    String host = DefaultValues.IP,
    int port = DefaultValues.PORT,
    required ConnectionCubit connectionCubit,
    required SensorsCubit sensorsCubit,
    required PageCubit pageCubit,
  }) {
    _instance ??= TcpClientService._internal(
      sensorsCubit,
      pageCubit,
      host: host,
      port: port,
      connectionCubit: connectionCubit,
    );
    return _instance!;
  }

  Future<void> connect() async {
    if (_isConnected) {
      if (kDebugMode) print('Already connected to $host:$port');
      return;
    }

    connectionCubit.setConnecting();

    try {
      _socket = await Socket.connect(host, port).timeout(Duration(seconds: 10));
      if (kDebugMode) {
        print(
            'Connected to: ${_socket.remoteAddress.address}:${_socket.remotePort}');
      }

      _isConnected = true;
      _retryCount = 0;
      connectionCubit.setConnected();

      _frameSenderService = FrameSenderService(_socket);
      _gpsSensorService =
          GPSSensorService(_frameSenderService, sensorsCubit, pageCubit);
      _lightSensorService =
          LightSensorService(_frameSenderService, sensorsCubit);

      _frameReceiverService = FrameReceiverService(
        _socket,
        reconnect,
        _gpsSensorService,
        _lightSensorService,
        sensorsCubit,
      );

      _frameReceiverService.listenToSocket();
    } catch (e) {
      if (kDebugMode) print('Connection error: $e');
      connectionCubit.setFailed(message: 'Failed to connect');
      _attemptReconnect();
    }
  }

  bool get isConnected => _isConnected;

  void reconnect() {
    if (_isConnected) {
      disconnect();
    }
    _attemptReconnect();
  }

  void _attemptReconnect() {
    if (_retryCount >= 5) {
      connectionCubit.setFailed(message: 'Max reconnection attempts reached');
      return;
    }

    connectionCubit.setReconnecting();
    _retryCount++;

    Future.delayed(Duration(seconds: 3 * _retryCount), () {
      if (!_isConnected) connect();
    });
  }

  void disconnect() {
    if (!_isConnected) return;

    _socket.destroy();
    _isConnected = false;
    connectionCubit.setDisconnected(message: 'Manually disconnected');

    if (kDebugMode) print('Socket closed');
  }
}
