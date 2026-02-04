import 'package:quadri_pilot/data/models/sensors.model.dart';

class SensorData {
  final SENSORS sensorType;
  final double currentValue;
  final List<double> history;
  final DateTime historyAcquisitionTime;
  final int acquisitionPeriod;
  final (double, double)? gps;
  final Map<DateTime, double>? averagedHistory; // ✅ Add averaged history

  SensorData({
    required this.sensorType,
    required this.currentValue,
    required this.history,
    required this.historyAcquisitionTime,
    required this.acquisitionPeriod,
    this.gps,
    this.averagedHistory, // ✅ Nullable at initialization
  });

  SensorData copyWith({
    double? currentValue,
    List<double>? history,
    DateTime? historyAcquisitionTime,
    int? acquisitionPeriod,
    (double, double)? gps,
    Map<DateTime, double>? averagedHistory, // ✅ Allow updates
  }) {
    return SensorData(
      sensorType: sensorType,
      currentValue: currentValue ?? this.currentValue,
      history: history ?? this.history,
      historyAcquisitionTime:
          historyAcquisitionTime ?? this.historyAcquisitionTime,
      acquisitionPeriod: acquisitionPeriod ?? this.acquisitionPeriod,
      gps: gps ?? this.gps,
      averagedHistory: averagedHistory ?? this.averagedHistory, // ✅
    );
  }
}
