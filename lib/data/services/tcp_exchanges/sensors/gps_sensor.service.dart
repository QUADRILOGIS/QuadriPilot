import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:quadri_pilot/data/models/sensors.model.dart';
import 'package:quadri_pilot/data/models/packet.model.dart';
import 'package:quadri_pilot/logic/cubits/page.cubit.dart';

import '../../../../logic/cubits/sensors.cubit.dart';
import '../frame_sender.service.dart';

class GPSSensorService {
  final FrameSenderService senderService;
  final SensorsCubit sensorsCubit;
  final PageCubit pageCubit;
  final PacketModel packet = PacketModel(sensor: SENSORS.GPS_S.sensor);

  Timer? _gpsTimer;
  StreamSubscription? _pageSubscription;

  GPSSensorService(this.senderService, this.sensorsCubit, this.pageCubit) {
    sensorsCubit.initializeSensor(SENSORS.GPS_S);
    _startPageListener();
  }

  void _startPageListener() {
    _pageSubscription = pageCubit.stream.listen((page) {
      if (page == AppPage.dashboard) {
        _startGpsTimer();
      } else {
        _stopGpsTimer();
      }
    });
  }

  void _startGpsTimer() {
    if (_gpsTimer == null || !_gpsTimer!.isActive) {
      _gpsTimer = Timer.periodic(Duration(seconds: 5), (timer) {
        getGPS();
      });
    }
  }

  void _stopGpsTimer() {
    _gpsTimer?.cancel();
  }

  void getGPS() {
    senderService.sendFrame(packet.getValue());
  }

  void getGPSHistory() {
    senderService.sendFrame(packet.getHistoryValue());
  }

  void handleGPSResponse(List<int> data, SensorsCubit sensorsCubit) {
    if (data.length < 10) {
      if (kDebugMode) {
        print("Invalid or too small data received.");
      }
      return;
    }
    (double, double) gps = parseGPSFromData(data);
    sensorsCubit.updateGPSValue(SENSORS.GPS_S, gps);
  }

  List<int> extractPayload(List<int> data) {
    return data.sublist(8);
  }

  (double, double) parseGPSFromData(List<int> data) {
    List<int> payload = extractPayload(data);
    int latitudeRaw =
        ByteData.sublistView(Uint8List.fromList(payload.sublist(0, 4)))
            .getInt32(0, Endian.little);
    int longitudeRaw =
        ByteData.sublistView(Uint8List.fromList(payload.sublist(4, 8)))
            .getInt32(0, Endian.little);

    double latitude = latitudeRaw * 0.000001;
    double longitude = longitudeRaw * 0.000001;

    if (data.length < 16) {
      return (double.nan, double.nan);
    }

    return (latitude, longitude);
  }

  void dispose() {
    _gpsTimer?.cancel();
    _pageSubscription?.cancel();
  }
}
