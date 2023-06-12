import 'package:papa_burger/src/views/pages/notification/state/notification_bloc.dart';
import 'package:web_socket_client/web_socket_client.dart';

extension ConnectionStateToStatus on ConnectionState {
  ConnectionStatus toStatus() {
    return this is Connected || this is Reconnected
        ? ConnectionStatus.connected
        : ConnectionStatus.disconnected;
  }
}
