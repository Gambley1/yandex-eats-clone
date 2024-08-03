part of 'notifications_repository.dart';

/// Storage keys for the [NotificationsStorage].
abstract class NotificationsStorageKeys {
  /// Whether the notifications are enabled.
  static const notificationsEnabled = '__notifications_enabled_storage_key__';
}

/// {@template notifications_storage}
/// Storage for the [NotificationsRepository].
/// {@endtemplate}
class NotificationsStorage {
  /// {@macro notifications_storage}
  const NotificationsStorage({
    required Storage storage,
  }) : _storage = storage;

  final Storage _storage;

  /// Sets the notifications enabled to [enabled] in Storage.
  Future<void> setNotificationsEnabled({required bool enabled}) =>
      _storage.write(
        key: NotificationsStorageKeys.notificationsEnabled,
        value: enabled.toString(),
      );

  /// Fetches the notifications enabled value from Storage.
  Future<bool> fetchNotificationsEnabled() async =>
      (await _storage.read(key: NotificationsStorageKeys.notificationsEnabled))
          ?.parseBool() ??
      false;
}

extension _BoolFromStringParsing on String {
  bool parseBool() {
    return toLowerCase() == 'true';
  }
}
