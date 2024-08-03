/// {@template connection_channel}
/// Connection channel enum class to easily identify channel
/// {@endtemplate}
enum ConnectionChannel {
  /// User order status changed channel name of notified by pg_notify channel
  userOrderStatusChanged('user_order_status_changed'),

  /// User notification table changed channel name of notified
  /// by pg_notify channel
  userNotificationTableChanged('user_notification_table_changed'),

  /// Notification table changed channel name of notified by pg_notify channel
  notificationTableChanged('notification_table_changed');

  const ConnectionChannel(this.value);

  /// Value of channel
  final String value;
}

/// To Connection Channel extension
extension ToConnectionChannelExtension on String {
  /// To connection channel
  ConnectionChannel? get toConnectionChannel {
    for (final channel in ConnectionChannel.values) {
      if (channel.value == this) {
        return channel;
      }
    }
    return null;
  }
}
