enum ConnectionStatus {
  disconnected,
  connecting,
  connected,
  reconnecting,
  failed
}

class ConnectionState {
  final ConnectionStatus status;
  final String? message;

  ConnectionState({required this.status, this.message});
}
