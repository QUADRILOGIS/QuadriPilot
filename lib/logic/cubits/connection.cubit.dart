import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/connection_state.model.dart';

class ConnectionCubit extends Cubit<ConnectionState> {
  ConnectionCubit()
      : super(ConnectionState(status: ConnectionStatus.disconnected));

  void setConnecting() =>
      emit(ConnectionState(status: ConnectionStatus.connecting));
  void setConnected() =>
      emit(ConnectionState(status: ConnectionStatus.connected));
  void setReconnecting() =>
      emit(ConnectionState(status: ConnectionStatus.reconnecting));
  void setDisconnected({String? message}) => emit(
      ConnectionState(status: ConnectionStatus.disconnected, message: message));
  void setFailed({String? message}) =>
      emit(ConnectionState(status: ConnectionStatus.failed, message: message));
}
