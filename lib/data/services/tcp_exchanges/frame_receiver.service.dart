import 'dart:io';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:quadri_pilot/data/services/tcp_exchanges/sensors/gps_sensor.service.dart';
import 'package:quadri_pilot/data/services/tcp_exchanges/sensors/light_sensor.service.dart';

import '../../../logic/cubits/sensors.cubit.dart';

class FrameReceiverService {
  final Socket socket;
  final Function reconnectCallback;

  final GPSSensorService gpsSensorService;
  final LightSensorService lightSensorService;

  final SensorsCubit sensorCubit;

  final Queue<List<int>> _frameQueue = Queue<List<int>>();
  bool _isProcessing = false;

  FrameReceiverService(
      this.socket,
      this.reconnectCallback,
      this.gpsSensorService,
      this.lightSensorService,
      this.sensorCubit);

  List<List<int>> uncapsulate(List<int> data) {
    List<List<int>> frames = [];
    while (data.length >= 3) {
      int packetSize = _sizeOfPacket(data);
      if (data.length < packetSize) {
        frames.add(data);
        break;
      }
      frames.add(data.sublist(0, packetSize));
      data = data.sublist(packetSize);
    }
    return frames;
  }

  int _sizeOfPacket(List<int> data) {
    return (data[2] << 8) | data[1] + 8;
  }

  void listenToSocket() {
    socket.listen(
      (List<int> data) {
        if (data.isEmpty) return;

        List<List<int>> framesToAdd = uncapsulate(data);

        for (var frame in framesToAdd) {
          _frameQueue.add(List.from(frame));
        }

        if (!_isProcessing) {
          _processNextFrame();
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('Socket error: $error');
        }
        reconnectCallback();
      },
      onDone: () {
        if (kDebugMode) {
          print('Server disconnected');
        }
        reconnectCallback();
      },
    );
  }

  void _processNextFrame() async {
    if (_frameQueue.isEmpty) {
      _isProcessing = false;
      return;
    }

    _isProcessing = true;
    _frameQueue.removeFirst();

    await Future.delayed(Duration(milliseconds: 10));

    _processNextFrame();
  }

  void stop() {
    try {
      socket.close();
      if (kDebugMode) {
        print('Socket closed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error closing socket: $e');
      }
    }
  }
}
