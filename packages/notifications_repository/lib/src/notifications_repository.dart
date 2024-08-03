// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:notifications_client/notifications_client.dart';
import 'package:permission_client/permission_client.dart';
import 'package:storage/storage.dart';
import 'package:web_socket_client/web_socket_client.dart';

part 'notifications_storage.dart';

/// {@template notifications_failure}
/// A base failure for the notifications repository failures.
/// {@endtemplate}
abstract class NotificationsFailure implements Exception {
  /// {@macro notifications_failure}
  const NotificationsFailure(this.error);

  /// The error which was caught.
  final Object error;
}

/// {@template toggle_notifications_failure}
/// Thrown when toggling notifications fails.
/// {@endtemplate}
class ToggleNotificationsFailure extends NotificationsFailure {
  /// {@macro toggle_notifications_failure}
  const ToggleNotificationsFailure(super.error);
}

/// {@template fetch_notifications_enabled_failure}
/// Thrown when fetching a notifications enabled status fails.
/// {@endtemplate}
class FetchNotificationsEnabledFailure extends NotificationsFailure {
  /// {@macro fetch_notifications_enabled_failure}
  const FetchNotificationsEnabledFailure(super.error);
}

/// {@template notifications_repository}
/// A repository that manages notifications with web socket.
/// {@endtemplate}
class NotificationsRepository {
  /// {@macro notifications_repository}
  const NotificationsRepository({
    required PermissionClient permissionClient,
    required NotificationsStorage storage,
    required NotificationsClient notificationsClient,
    required WebSocket wsUserNotifications,
    required WebSocket wsNotifications,
  })  : _permissionClient = permissionClient,
        _storage = storage,
        _notificationsClient = notificationsClient,
        _wsUserNotifications = wsUserNotifications,
        _wsNotifications = wsNotifications;

  final PermissionClient _permissionClient;
  final NotificationsStorage _storage;
  final NotificationsClient _notificationsClient;
  final WebSocket _wsUserNotifications;
  final WebSocket _wsNotifications;

  /// Toggles the notifications based on the [enable].
  ///
  /// When [enable] is true, request the notification permission if not granted
  /// and marks the notification setting as enabled. Subscribes the user to
  /// notifications related to user's categories preferences.
  ///
  /// When [enable] is false, marks notification setting as disabled and
  /// unsubscribes the user from notifications related to user's categories
  /// preferences.
  Future<void> toggleNotifications({required bool enable}) async {
    try {
      // Request the notification permission when turning notifications on.
      if (enable) {
        // Find the current notification permission status.
        final permissionStatus = await _permissionClient.notificationsStatus();

        // Navigate the user to permission settings
        // if the permission status is permanently denied or restricted.
        if (permissionStatus.isPermanentlyDenied ||
            permissionStatus.isRestricted) {
          await _permissionClient.openPermissionSettings();
          return;
        }

        // Request the permission if the permission status is denied.
        if (permissionStatus.isDenied) {
          final updatedPermissionStatus =
              await _permissionClient.requestNotifications();
          if (!updatedPermissionStatus.isGranted) {
            return;
          }
        }
      }

      // Update the notifications enabled in Storage.
      await _storage.setNotificationsEnabled(enabled: enable);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ToggleNotificationsFailure(error), stackTrace);
    }
  }

  // Future<void> showOngoingOrderNotification(
  //   String deliveryTime,
  //   String orderId,
  // ) async {
  //   final id = await showOngoingNotification(
  //     title: 'Papa Burger',
  //     body: 'Your order №$orderId has been successfully formed! '
  //         'It will be delivered by $deliveryTime.',
  //   );

  //   _userNotificationRepository.notifications().listen((value) async {
  //     if (value.isNotEmpty) {
  //       await cancelOngoingNotification(id);
  //     }
  //   });
  // }

  Stream<String> userNotifications() =>
      _wsUserNotifications.messages.cast<String>();

  Stream<String> notifications() => _wsNotifications.messages.cast<String>();

  Future<void> showNotification({
    required String body,
    String? title,
    bool isOngoing = false,
    int? id,
    String? payload,
  }) =>
      _notificationsClient.showTextNotification(
        body: body,
        title: title,
        id: id,
        isOngoing: isOngoing,
        payload: payload,
      );

  Future<void> cancelAllNotifications() =>
      _notificationsClient.cancelAllNotifications();

  void closeWsUserNotifications() {
    _wsUserNotifications.close();
  }

  void closeWsNotifications() {
    _wsNotifications.close();
  }
}
