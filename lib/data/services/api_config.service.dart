import 'package:shared_preferences/shared_preferences.dart';
import 'package:quadri_pilot/constants/app_config.dart';

class ApiConfigService {
  static const String _storageKey = 'api_base_url';
  static const String _tokenKey = 'api_token';
  static const String _managerPhoneKey = 'manager_phone';
  static final String defaultBaseUrl = AppConfig.apiBaseUrl;
  static const String defaultManagerPhone = '0600000000';

  Future<String> getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_storageKey) ?? defaultBaseUrl;
    return _toBaseUrl(stored);
  }

  Future<void> setBaseUrl(String value) async {
    final normalized = value.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, normalized);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token == null || token.trim().isEmpty) return null;
    return token.trim();
  }

  Future<void> setToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, value.trim());
  }

  Future<String> getManagerPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_managerPhoneKey) ?? defaultManagerPhone;
  }

  Future<void> setManagerPhone(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_managerPhoneKey, value.trim());
  }

  Future<String> getHealthUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_storageKey) ?? defaultBaseUrl;
    return _toHealthUrl(stored);
  }

  String _toBaseUrl(String value) {
    var url = value.trim();
    if (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    if (url.endsWith('/health')) {
      url = url.substring(0, url.length - '/health'.length);
    }
    return url;
  }

  String _toHealthUrl(String value) {
    final base = _toBaseUrl(value);
    if (value.trim().endsWith('/health')) {
      return value.trim();
    }
    return '$base/health';
  }
}
