import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static final String apiBaseUrl = _resolveApiBaseUrl();
  static const int trailerId = 1;

  static String _resolveApiBaseUrl() {
    final envValue = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    if (envValue.trim().isNotEmpty) {
      return envValue.trim();
    }
    if (!dotenv.isInitialized) {
      return '';
    }
    return dotenv.env['API_BASE_URL']?.trim() ?? '';
  }
}
