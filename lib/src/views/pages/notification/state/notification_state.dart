// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'notification_bloc.dart';

enum ConnectionStatus { connected, disconnected }

class NotificationState extends Equatable {
  const NotificationState._({
    this.message = '',
    this.status = ConnectionStatus.disconnected,
  });

  const NotificationState.initial() : this._();

  final String message;
  final ConnectionStatus status;

  @override
  List<Object> get props => [message, status];

  NotificationState copyWith({
    String? message,
    ConnectionStatus? status,
  }) {
    return NotificationState._(
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }
}
