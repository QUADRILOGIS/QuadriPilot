import 'package:flutter/foundation.dart';
import 'package:quadri_pilot/data/models/sensors.model.dart';
import 'package:quadri_pilot/data/models/packet.model.dart';

import '../../../../logic/cubits/sensors.cubit.dart';
import '../frame_sender.service.dart';

class LightSensorService {
  final FrameSenderService senderService;
  final SensorsCubit sensorsCubit;

  int oldValue = 0;

  LightSensorService(this.senderService, this.sensorsCubit) {
    sensorsCubit.initializeSensor(SENSORS.LIGHT_S);
    getLight();
    sensorsCubit.stream.listen((state) {
      final currentValue = state[SENSORS.LIGHT_S]?.currentValue;
      if (currentValue != null && currentValue != oldValue) {
        setLight(currentValue.toInt());
        oldValue = currentValue.toInt();
      }
    });
  }

  void getLight() {
    final sensor = SENSORS.LIGHT_S.sensor;
    PacketModel packet = PacketModel(sensor: sensor);
    senderService.sendFrame(packet.getValue());
  }

  void setLight(int value) {
    final sensor = SENSORS.LIGHT_S.sensor;
    PacketModel packet = PacketModel(sensor: sensor);
    sensorsCubit.updateSensorValue(SENSORS.LIGHT_S, value.toDouble());
    senderService.sendFrame(packet.setValue(value));
  }

  void handleLightResponse(List<int> data, SensorsCubit sensorsCubit) {
    if (data.length != 9) {
      if (kDebugMode) {
        print("Invalid or too small data received.");
      }
      return;
    }
    // sensorsCubit.updateSensorValue(SENSORS.LIGHT_S, data[8] / (255 * 100));
  }

  List<int> exctractPayload(List<int> data) {
    return data.sublist(8);
  }
}
