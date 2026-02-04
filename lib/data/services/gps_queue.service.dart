import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:quadri_pilot/data/services/gps_api.service.dart';

class GpsQueueService {
  static const _storageKey = 'pending_gps_queue';

  Future<void> enqueue(GpsPayload payload) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_storageKey) ?? [];
    final next = [...existing, jsonEncode(payload.toJson())];
    await prefs.setStringList(_storageKey, next);
  }

  Future<List<GpsPayload>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_storageKey) ?? [];
    return existing
        .map((item) => GpsPayload.fromJson(jsonDecode(item)))
        .toList();
  }

  Future<void> flush(GpsApiService api) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_storageKey) ?? [];
    if (existing.isEmpty) return;

    final remaining = <String>[];
    for (final item in existing) {
      try {
        final payload = GpsPayload.fromJson(jsonDecode(item));
        await api.postGps(payload);
      } catch (_) {
        remaining.add(item);
      }
    }
    await prefs.setStringList(_storageKey, remaining);
  }
}
