import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quadri_pilot/data/services/api_config.service.dart';

class GpsPayload {
  final int trailerId;
  final double latitude;
  final double longitude;

  const GpsPayload({
    required this.trailerId,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'trailer_id': trailerId,
      'actual_pos_lat': latitude,
      'actual_pos_long': longitude,
    };
  }

  factory GpsPayload.fromJson(Map<String, dynamic> json) {
    return GpsPayload(
      trailerId: json['trailer_id'] as int,
      latitude: (json['actual_pos_lat'] as num).toDouble(),
      longitude: (json['actual_pos_long'] as num).toDouble(),
    );
  }
}

class GpsApiService {
  final http.Client _client;
  final ApiConfigService _config;

  GpsApiService({http.Client? client, ApiConfigService? config})
      : _client = client ?? http.Client(),
        _config = config ?? ApiConfigService();

  Future<void> postGps(GpsPayload payload) async {
    final baseUrl = await _config.getBaseUrl();
    final uri = Uri.parse('$baseUrl/gps');
    final response = await _client
        .post(
          uri,
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode(payload.toJson()),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw GpsApiException(statusCode: response.statusCode);
    }
  }
}

class GpsApiException implements Exception {
  final int statusCode;

  GpsApiException({required this.statusCode});
}
