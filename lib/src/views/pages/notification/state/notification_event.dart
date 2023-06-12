part of 'notification_bloc.dart';

abstract class NotificationEvent {
  const NotificationEvent();
}

class NotificationStarted extends NotificationEvent {
  const NotificationStarted();
}

class _NotificationMessageChanged extends NotificationEvent {
  const _NotificationMessageChanged(this.message);

  final String message;
}

class _NotificationConnectionStatusChanged extends NotificationEvent {
  const _NotificationConnectionStatusChanged(this.state);

  final ConnectionState state;
}
