import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quadri_pilot/constants/app_config.dart';
import 'package:quadri_pilot/data/models/sensors.model.dart';
import 'package:quadri_pilot/data/services/gps_api.service.dart';
import 'package:quadri_pilot/data/services/gps_queue.service.dart';
import 'package:quadri_pilot/logic/cubits/sensors.cubit.dart';

class RaceState {
  final bool isActive;
  final List<GpsPoint> points;
  final (double, double)? lastCardGps;
  final DateTime? startedAt;
  final Duration? lastDuration;

  const RaceState({
    required this.isActive,
    required this.points,
    this.lastCardGps,
    this.startedAt,
    this.lastDuration,
  });

  RaceState copyWith({
    bool? isActive,
    List<GpsPoint>? points,
    (double, double)? lastCardGps,
    DateTime? startedAt,
    Duration? lastDuration,
  }) {
    return RaceState(
      isActive: isActive ?? this.isActive,
      points: points ?? this.points,
      lastCardGps: lastCardGps ?? this.lastCardGps,
      startedAt: startedAt ?? this.startedAt,
      lastDuration: lastDuration ?? this.lastDuration,
    );
  }
}

class RaceCubit extends Cubit<RaceState> {
  final SensorsCubit _sensorsCubit;
  final GpsApiService _gpsApi;
  final GpsQueueService _gpsQueue;
  StreamSubscription? _gpsSubscription;
  Timer? _phoneGpsTimer;

  RaceCubit(
    this._sensorsCubit, {
    GpsApiService? gpsApi,
    GpsQueueService? gpsQueue,
  })  : _gpsApi = gpsApi ?? GpsApiService(),
        _gpsQueue = gpsQueue ?? GpsQueueService(),
        super(const RaceState(isActive: false, points: [], lastDuration: null));

  Future<void> start() async {
    if (state.isActive) return;
    emit(state.copyWith(
      isActive: true,
      startedAt: DateTime.now(),
      lastDuration: null,
    ));
    _gpsSubscription?.cancel();
    _gpsSubscription = _sensorsCubit.stream.listen((stateMap) async {
      if (!state.isActive) return;
      final gpsData = stateMap[SENSORS.GPS_S];
      if (gpsData == null) return;
      final gps = gpsData.gps;
      if (gps == null) return;
      final (lat, lng) = gps;
      if (lat.isNaN || lng.isNaN) return;
      final point = GpsPoint(
        latitude: lat,
        longitude: lng,
        timestamp: DateTime.now(),
      );
      final updated = List<GpsPoint>.from(state.points)..add(point);
      emit(state.copyWith(points: updated, lastCardGps: (lat, lng)));
    });

    await _ensurePermissions();
    _phoneGpsTimer?.cancel();
    _phoneGpsTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      if (!state.isActive) return;
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );
        final payload = GpsPayload(
          trailerId: AppConfig.trailerId,
          latitude: position.latitude,
          longitude: position.longitude,
        );
        try {
          await _gpsApi.postGps(payload);
        } on GpsApiException catch (error) {
          if (error.statusCode >= 500) {
            await _gpsQueue.enqueue(payload);
          }
        } catch (_) {
          await _gpsQueue.enqueue(payload);
        }
      } catch (_) {
        // Ignore location errors silently.
      }
    });
  }

  void stop() {
    if (!state.isActive) return;
    _gpsSubscription?.cancel();
    _phoneGpsTimer?.cancel();
    final startedAt = state.startedAt;
    final duration =
        startedAt == null ? null : DateTime.now().difference(startedAt);
    emit(state.copyWith(isActive: false, lastDuration: duration));
  }

  void reset() {
    _gpsSubscription?.cancel();
    _phoneGpsTimer?.cancel();
    emit(const RaceState(isActive: false, points: [], lastDuration: null));
  }

  Future<void> _ensurePermissions() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }
  }

  @override
  Future<void> close() {
    _gpsSubscription?.cancel();
    _phoneGpsTimer?.cancel();
    return super.close();
  }
}

class GpsPoint {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  const GpsPoint({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });
}
