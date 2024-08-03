part of 'notifications_bloc.dart';

sealed class NotificationsEvent {
  const NotificationsEvent();
}

final class NotificationMessageChanged extends NotificationsEvent {
  const NotificationMessageChanged(this.message);

  final String message;
}
