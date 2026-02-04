import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quadri_pilot/data/services/api_config.service.dart';

class IncidentPayload {
  final String message;
  final int trailerId;
  final int seriousness;
  final String incidentType;
  final double? latitude;
  final double? longitude;

  const IncidentPayload({
    required this.message,
    required this.trailerId,
    required this.seriousness,
    required this.incidentType,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'trailer_id': trailerId,
      'seriousness': seriousness,
      'incident_type': incidentType,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }

  factory IncidentPayload.fromJson(Map<String, dynamic> json) {
    return IncidentPayload(
      message: json['message'] as String,
      trailerId: json['trailer_id'] as int,
      seriousness: json['seriousness'] as int,
      incidentType: json['incident_type'] as String,
      latitude:
          json['latitude'] == null ? null : (json['latitude'] as num).toDouble(),
      longitude: json['longitude'] == null
          ? null
          : (json['longitude'] as num).toDouble(),
    );
  }
}

class IncidentApiService {
  final http.Client _client;
  final ApiConfigService _config;

  IncidentApiService({http.Client? client, ApiConfigService? config})
      : _client = client ?? http.Client(),
        _config = config ?? ApiConfigService();

  Future<void> postIncident(IncidentPayload payload) async {
    final baseUrl = await _config.getBaseUrl();
    final uri = Uri.parse('$baseUrl/incidents/report');
    final response = await _client
        .post(
          uri,
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode(payload.toJson()),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      String? message;
      try {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        message = decoded['message']?.toString();
      } catch (_) {}
      throw IncidentApiException(
        statusCode: response.statusCode,
        message: message ?? 'Incident API error',
      );
    }
  }
}

class IncidentApiException implements Exception {
  final int statusCode;
  final String message;

  IncidentApiException({required this.statusCode, required this.message});
}
