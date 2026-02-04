import 'dart:typed_data';

import 'package:quadri_pilot/data/enum/default_values.enum.dart';
import 'package:quadri_pilot/data/models/parameters.model.dart';
import 'package:quadri_pilot/data/models/sensors.model.dart';

class PacketModel {
  final int DEVICE_AD = DefaultValues.DEVICE_AD;
  final int fagnon = 208;
  final int length = 0;
  final Sensor sensor;

  PacketModel({
    required this.sensor,
  });

  factory PacketModel.fromBytes(List<int> bytes) {
    final function = MSG_FUNCTION.fromByte(bytes[0]);

    return PacketModel(
      sensor: SENSORS.values
          .firstWhere((sensor) => sensor.sensor.function == function)
          .sensor,
    );
  }

  Uint8List getValue() {
    List<int> packet = [];
    packet.add(fagnon.toUnsigned(8));
    packet.add(0.toUnsigned(8));
    packet.add(0.toUnsigned(8));
    packet.add(DEVICE_AD.toUnsigned(8));
    packet.add(MSG_TYPE.GET.byteValue.toUnsigned(8));
    packet.add(sensor.function.byteValue.toUnsigned(8));
    packet.add(sensor.availableObjects[0].byteValue.toUnsigned(8));
    packet.add(0.toUnsigned(8));
    return Uint8List.fromList(packet);
  }

  Uint8List getHistoryValue() {
    if (sensor.availableObjects.length < 2) {
      throw Exception("This sensor doesn't have a history value");
    }
    List<int> packet = [];
    packet.add(fagnon.toUnsigned(8));
    packet.add(0.toUnsigned(8));
    packet.add(length.toUnsigned(8));
    packet.add(DEVICE_AD.toUnsigned(8));
    packet.add(MSG_TYPE.GET.byteValue.toUnsigned(8));
    packet.add(sensor.function.byteValue.toUnsigned(8));
    packet.add(sensor.availableObjects[1].byteValue.toUnsigned(8));
    packet.add(0.toUnsigned(8));
    return Uint8List.fromList(packet);
  }

  Uint8List eventValue() {
    List<int> packet = [];
    packet.add(fagnon.toUnsigned(8));
    packet.add((length >> 8).toUnsigned(8));
    packet.add((length & 0xFF).toUnsigned(8));
    packet.add(DEVICE_AD.toUnsigned(8));
    packet.add(MSG_TYPE.EVENT.byteValue.toUnsigned(8));
    packet.add(sensor.function.byteValue.toUnsigned(8));
    packet.add(sensor.availableObjects[0].byteValue.toUnsigned(8));
    packet.add(0.toUnsigned(8));
    return Uint8List.fromList(packet);
  }

  Uint8List setValue(int value) {
    if (sensor.function != MSG_FUNCTION.LIGHT) {
      throw Exception("This sensor doesn't have a set value");
    }
    List<int> packet = [];
    packet.add(fagnon.toUnsigned(8));
    packet.add(01.toUnsigned(8));
    packet.add(length.toUnsigned(8));
    packet.add(DEVICE_AD.toUnsigned(8));
    packet.add(MSG_TYPE.SET.byteValue.toUnsigned(8));
    packet.add(sensor.function.byteValue.toUnsigned(8));
    packet.add(sensor.availableObjects[0].byteValue.toUnsigned(8));
    packet.add(0.toUnsigned(8));
    packet.add(value.toUnsigned(8));
    return Uint8List.fromList(packet);
  }
}

extension PacketModelExtension on PacketModel {
  List<int> toBytes() {
    List<int> bytes = [
      sensor.function.byteValue,
      MSG_TYPE.GET.byteValue,
      0,
    ];

    bytes.addAll([0]);

    return bytes;
  }
}
