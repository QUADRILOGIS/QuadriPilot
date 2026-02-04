import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:quadri_pilot/data/services/api_config.service.dart';
import 'package:quadri_pilot/data/services/incident_api.service.dart';
import 'package:quadri_pilot/data/services/incident_queue.service.dart';
import 'package:quadri_pilot/data/services/gps_api.service.dart';
import 'package:quadri_pilot/data/services/gps_queue.service.dart';

class ApiSyncState {
  final bool hasInternet;
  final bool apiReachable;
  final int pendingCount;
  final bool isSyncing;
  final String? lastError;

  const ApiSyncState({
    required this.hasInternet,
    required this.apiReachable,
    required this.pendingCount,
    required this.isSyncing,
    this.lastError,
  });

  ApiSyncState copyWith({
    bool? hasInternet,
    bool? apiReachable,
    int? pendingCount,
    bool? isSyncing,
    String? lastError,
  }) {
    return ApiSyncState(
      hasInternet: hasInternet ?? this.hasInternet,
      apiReachable: apiReachable ?? this.apiReachable,
      pendingCount: pendingCount ?? this.pendingCount,
      isSyncing: isSyncing ?? this.isSyncing,
      lastError: lastError ?? this.lastError,
    );
  }
}

class ApiSyncCubit extends Cubit<ApiSyncState> {
  final IncidentQueueService _queue;
  final IncidentApiService _api;
  final GpsQueueService _gpsQueue;
  final GpsApiService _gpsApi;
  final http.Client _client;
  final ApiConfigService _config;
  Timer? _timer;

  ApiSyncCubit({
    IncidentQueueService? queue,
    IncidentApiService? api,
    GpsQueueService? gpsQueue,
    GpsApiService? gpsApi,
    http.Client? client,
    ApiConfigService? config,
  })  : _queue = queue ?? IncidentQueueService(),
        _api = api ?? IncidentApiService(),
        _gpsQueue = gpsQueue ?? GpsQueueService(),
        _gpsApi = gpsApi ?? GpsApiService(),
        _client = client ?? http.Client(),
        _config = config ?? ApiConfigService(),
        super(const ApiSyncState(
          hasInternet: false,
          apiReachable: false,
          pendingCount: 0,
          isSyncing: false,
          lastError: null,
        ));

  void start() {
    _tick();
    _timer ??= Timer.periodic(const Duration(seconds: 5), (_) => _tick());
  }

  Future<void> refresh() async {
    await _tick();
  }

  Future<void> _tick() async {
    final pendingIncidents = await _queue.loadAll();
    final pendingGps = await _gpsQueue.loadAll();
    emit(state.copyWith(pendingCount: pendingIncidents.length + pendingGps.length));
    final internet = await _pingInternet();
    final apiOk = internet ? await _pingApi() : false;
    emit(state.copyWith(
      hasInternet: internet,
      apiReachable: apiOk,
      lastError: apiOk ? null : state.lastError,
    ));
    if (apiOk && (pendingIncidents.isNotEmpty || pendingGps.isNotEmpty)) {
      emit(state.copyWith(isSyncing: true));
      try {
        await _queue.flush(_api);
        await _gpsQueue.flush(_gpsApi);
        emit(state.copyWith(lastError: null));
      } catch (error) {
        emit(state.copyWith(lastError: error.toString()));
      }
      final remainingIncidents = await _queue.loadAll();
      final remainingGps = await _gpsQueue.loadAll();
      emit(state.copyWith(
        pendingCount: remainingIncidents.length + remainingGps.length,
        isSyncing: false,
      ));
    }
  }

  Future<bool> _pingInternet() async {
    try {
      final uri = Uri.parse('https://clients3.google.com/generate_204');
      final response = await _client.get(uri).timeout(const Duration(seconds: 5));
      return response.statusCode >= 200 && response.statusCode < 400;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _pingApi() async {
    try {
      final healthUrl = await _config.getHealthUrl();
      final uri = Uri.parse(healthUrl);
      final response = await _client.get(uri).timeout(const Duration(seconds: 5));
      return response.statusCode >= 200 && response.statusCode < 400;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _client.close();
    return super.close();
  }
}
