import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:quadri_pilot/data/services/incident_api.service.dart';

class IncidentQueueService {
  static const _storageKey = 'pending_incidents_queue';

  Future<void> enqueue(IncidentPayload payload) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_storageKey) ?? [];
    final next = [...existing, jsonEncode(payload.toJson())];
    await prefs.setStringList(_storageKey, next);
  }

  Future<List<IncidentPayload>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_storageKey) ?? [];
    return existing
        .map((item) => IncidentPayload.fromJson(jsonDecode(item)))
        .toList();
  }

  Future<void> flush(IncidentApiService api) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_storageKey) ?? [];
    if (existing.isEmpty) return;

    final remaining = <String>[];
    for (final item in existing) {
      try {
        final payload = IncidentPayload.fromJson(jsonDecode(item));
        await api.postIncident(payload);
      } catch (_) {
        remaining.add(item);
      }
    }
    await prefs.setStringList(_storageKey, remaining);
  }
}
