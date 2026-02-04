import 'package:quadri_pilot/data/models/parameters.model.dart';

/// The Sensor object groups all the possible frames that can be sent to the board,
/// each GET expects a PARAM_VALUE in return.
/// The value of OBJ works as follows:
///   - odd number: the current value
///   - even number: the historical values
class Sensor {
  final List<MSG_TYPE> availableMethods;
  final List<OBJ> availableObjects;
  final MSG_FUNCTION function;

  const Sensor({
    required this.availableMethods,
    required this.availableObjects,
    required this.function,
  });
}

enum SENSORS {
  BATTERY_S(Sensor(
      availableMethods: [MSG_TYPE.GET],
      availableObjects: [OBJ.ONE],
      function: MSG_FUNCTION.BATTERY_LVL)),
  GPS_S(Sensor(
      availableMethods: [MSG_TYPE.GET],
      availableObjects: [OBJ.ONE],
      function: MSG_FUNCTION.LOCALISATION_GPS)),
  LIGHT_S(Sensor(
      availableMethods: [MSG_TYPE.GET, MSG_TYPE.SET],
      availableObjects: [OBJ.ONE],
      function: MSG_FUNCTION.LIGHT)),
  HEARTBEAT(Sensor(
      availableMethods: [MSG_TYPE.EVENT],
      availableObjects: [OBJ.ONE],
      function: MSG_FUNCTION.GENERAL));

  final Sensor sensor;
  const SENSORS(this.sensor);
}

// Get the name of the sensor
extension SensorName on SENSORS {
  String get name {
    switch (this) {
      case SENSORS.BATTERY_S:
        return 'Battery';
      case SENSORS.GPS_S:
        return 'GPS';
      case SENSORS.LIGHT_S:
        return 'Light';
      case SENSORS.HEARTBEAT:
        return 'Heartbeat';
    }
  }
}

// Get the unit of the sensor
extension SensorUnit on SENSORS {
  String get unit {
    switch (this) {
      case SENSORS.BATTERY_S:
        return '%';
      case SENSORS.GPS_S:
        return '';
      case SENSORS.LIGHT_S:
        return 'lux';
      case SENSORS.HEARTBEAT:
        return '';
    }
  }
}
