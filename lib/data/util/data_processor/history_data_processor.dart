import 'dart:collection';

class HistoryDataProcessor {
  static Map<DateTime, double> computeAverages({
    required List<double> history,
    required DateTime historyStartTime,
    required int acquisitionPeriodMs,
  }) {
    if (history.isEmpty) return {};

    final Map<DateTime, List<double>> groupedData = {};
    final Map<DateTime, double> averagedData = SplayTreeMap();

    // **Start with the most recent time (last value is now)**
    DateTime latestTime = DateTime.now();

    for (int i = 0; i < history.length; i++) {
      // **Calculate timestamps forward from latestTime**
      DateTime timestamp = latestTime.subtract(
        Duration(milliseconds: i * acquisitionPeriodMs),
      );

      // **Round timestamp to the nearest 30-minute slot**
      DateTime roundedTimestamp = DateTime(
        timestamp.year,
        timestamp.month,
        timestamp.day,
        timestamp.hour,
        timestamp.minute - (timestamp.minute % 30),
      );

      // **Group values into 30-minute slots**
      groupedData.putIfAbsent(roundedTimestamp, () => []);
      groupedData[roundedTimestamp]!.add(history[i]);
    }

    // **Calculate the average for each 30-minute slot**
    groupedData.forEach((time, values) {
      averagedData[time] = values.reduce((a, b) => a + b) / values.length;
    });

    return averagedData;
  }

  /// **Updates the existing 30-min map with a new value**
  static Map<DateTime, double> updateWithNewValue({
    required Map<DateTime, double> existingAverages,
    required double newValue,
    required DateTime newTimestamp,
  }) {
    DateTime roundedTimestamp = DateTime(
      newTimestamp.year,
      newTimestamp.month,
      newTimestamp.day,
      newTimestamp.hour,
      newTimestamp.minute - (newTimestamp.minute % 30),
    );

    // If this 30-min slot exists, update the average
    if (existingAverages.containsKey(roundedTimestamp)) {
      existingAverages[roundedTimestamp] =
          (existingAverages[roundedTimestamp]! + newValue) / 2;
    } else {
      existingAverages[roundedTimestamp] = newValue;
    }

    return existingAverages;
  }
}
