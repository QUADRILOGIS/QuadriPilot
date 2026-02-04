import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/sensor_data.model.dart';
import '../../data/models/sensors.model.dart';
import '../../data/util/data_processor/history_data_processor.dart';

class SensorsCubit extends Cubit<Map<SENSORS, SensorData>> {
  SensorsCubit() : super({});

  void initializeSensor(SENSORS sensorType, {int acquisitionPeriod = 1000}) {
    if (state.containsKey(sensorType)) return;

    emit({
      ...state,
      sensorType: SensorData(
        sensorType: sensorType,
        currentValue: 0.0,
        history: [],
        historyAcquisitionTime: DateTime.now(),
        acquisitionPeriod: acquisitionPeriod,
        gps: (double.nan, double.nan),
        averagedHistory: {}, // ✅ Initialize empty map
      ),
    });
  }

  void updateSensorValue(SENSORS sensorType, double newValue) {
    final function = sensorType;
    if (!state.containsKey(function)) return;

    final updatedSensor = state[function]!;
    final updatedHistory = [...updatedSensor.history, newValue];

    // ✅ **Ensure history doesn't grow indefinitely**
    if (updatedHistory.length > 1000) {
      updatedHistory.removeRange(0, updatedHistory.length - 1000);
    }

    // ✅ **Compute or update 30-minute averages**
    final averagedData = updatedSensor.history.isEmpty
        ? HistoryDataProcessor.computeAverages(
            history: updatedHistory,
            historyStartTime: updatedSensor.historyAcquisitionTime,
            acquisitionPeriodMs: updatedSensor.acquisitionPeriod,
          )
        : HistoryDataProcessor.updateWithNewValue(
            existingAverages: updatedSensor.averagedHistory ?? {},
            newValue: newValue,
            newTimestamp: DateTime.now(),
          );

    emit({
      ...state,
      function: updatedSensor.copyWith(
        currentValue: newValue,
        history: updatedHistory,
        averagedHistory: averagedData,
        gps: (double.nan, double.nan),
      ),
    });

  }

  void updateGPSValue(SENSORS sensorType, (double, double) newValue) {
    final function = sensorType;
    if (!state.containsKey(function)) return;

    final updatedSensor = state[function]!;
    emit({
      ...state,
      function: updatedSensor.copyWith(
        gps: newValue,
      ),
    });
  }

  void resetSensor(SENSORS sensorType) {
    final function = sensorType;
    if (!state.containsKey(function)) return;

    emit({
      ...state,
      function: SensorData(
        sensorType: sensorType,
        currentValue: 0.0,
        history: [],
        historyAcquisitionTime: DateTime.now(),
        acquisitionPeriod: state[function]?.acquisitionPeriod ?? 1000,
        gps: (double.nan, double.nan),
      ),
    });
  }

  SensorData? getSensorValue(SENSORS sensorType) {
    return state[sensorType];
  }

  void updateSensorHistory(
      SENSORS sensorType, List<double> newHistory, int acquisitionPeriod) {
    final function = sensorType;
    if (!state.containsKey(function)) return;

    final updatedSensor = state[function]!;

    // ✅ **Precompute averages**
    final averagedData = HistoryDataProcessor.computeAverages(
      history: newHistory,
      historyStartTime: updatedSensor.historyAcquisitionTime,
      acquisitionPeriodMs: acquisitionPeriod,
    );

    emit({
      ...state,
      function: updatedSensor.copyWith(
        history: newHistory,
        historyAcquisitionTime: DateTime.now(),
        acquisitionPeriod: acquisitionPeriod,
        averagedHistory: averagedData, // ✅ Store processed averages
        gps: (double.nan, double.nan),
      ),
    });
  }
}
