part of 'notification_bloc.dart';

sealed class NotificationEvent {
  const NotificationEvent();
}

final class _NotificationMessageChanged extends NotificationEvent {
  const _NotificationMessageChanged(this.message);

  final String message;
}

final class _NotificationConnectionStatusChanged extends NotificationEvent {
  const _NotificationConnectionStatusChanged(this.state);

  final ConnectionState state;
}
