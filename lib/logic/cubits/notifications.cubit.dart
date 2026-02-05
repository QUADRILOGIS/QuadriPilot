import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:quadri_pilot/constants/app_config.dart';
import 'package:quadri_pilot/data/services/api_config.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum NotificationSeverity { warning, critical }

class NotificationItem {
  final String id;
  final String part;
  final NotificationSeverity severity;
  final String body;
  final DateTime createdAt;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.part,
    required this.severity,
    required this.body,
    required this.createdAt,
    this.isRead = false,
  });

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      part: part,
      severity: severity,
      body: body,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}

class NotificationsState {
  final List<NotificationItem> items;

  const NotificationsState({required this.items});

  int get unreadCount => items.where((item) => !item.isRead).length;
}

class NotificationsCubit extends Cubit<NotificationsState> {
  final ApiConfigService _config;
  final http.Client _client;
  Timer? _timer;
  final Set<String> _readIds = {};
  static const _readStorageKey = 'read_alert_ids';

  NotificationsCubit()
      : _config = ApiConfigService(),
        _client = http.Client(),
        super(const NotificationsState(items: []));

  void start() {
    _loadReadIds().then((_) => _fetchAlerts());
    _timer ??= Timer.periodic(const Duration(seconds: 20), (_) => _fetchAlerts());
  }

  Future<void> _loadReadIds() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_readStorageKey) ?? [];
    _readIds
      ..clear()
      ..addAll(stored);
  }

  Future<void> _saveReadIds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_readStorageKey, _readIds.toList());
  }

  Future<void> _fetchAlerts() async {
    try {
      final baseUrl = await _config.getBaseUrl();
      final uri =
          Uri.parse('$baseUrl/public/trailers/${AppConfig.trailerId}/alerts');
      final response = await _client.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode < 200 || response.statusCode >= 300) return;
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final data = (decoded['data'] as List<dynamic>? ?? []);
      final items = data.map((raw) {
        final map = raw as Map<String, dynamic>;
        final id = map['id'].toString();
        final status = (map['status'] ?? '').toString();
        if (status == 'solved') return null;
        final part = (map['piece_name'] ?? 'Pièce').toString();
        final dateStr = (map['alert_date'] ?? '').toString();
        final createdAt =
            DateTime.tryParse(dateStr) ?? DateTime.now();
        final severity = status == 'critic'
            ? NotificationSeverity.critical
            : NotificationSeverity.warning;
        return NotificationItem(
          id: id,
          part: part,
          severity: severity,
          body: '',
          createdAt: createdAt,
          isRead: _readIds.contains(id),
        );
      }).whereType<NotificationItem>().toList();

      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(NotificationsState(items: items));
    } catch (_) {
      // Ignore network errors to avoid breaking UI.
    }
  }

  void markAllRead() {
    for (final item in state.items) {
      _readIds.add(item.id);
    }
    _saveReadIds();
    emit(
      NotificationsState(
        items: state.items.map((item) => item.copyWith(isRead: true)).toList(),
      ),
    );
  }

  void markRead(String id) {
    _readIds.add(id);
    _saveReadIds();
    emit(
      NotificationsState(
        items: state.items
            .map((item) => item.id == id ? item.copyWith(isRead: true) : item)
            .toList(),
      ),
    );
  }

  void addNotification(NotificationItem item) {
    emit(NotificationsState(items: [item, ...state.items]));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _client.close();
    return super.close();
  }
}
