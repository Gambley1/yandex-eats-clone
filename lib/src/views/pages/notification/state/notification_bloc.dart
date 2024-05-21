import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/services/repositories/notifications/notifications_repository.dart';
import 'package:web_socket_client/web_socket_client.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc({NotificationsRepository? notificationRepository})
      : _notificationRepository =
            notificationRepository ?? NotificationsRepository(),
        super(const NotificationState.initial()) {
    on<NotificationStarted>(_onNotificationStarted);
    on<_NotificationMessageChanged>(_onNotificationMessageChanged);
    on<_NotificationConnectionStatusChanged>(
      _onNotificationConnectionStatusChanged,
    );
  }

  final NotificationsRepository _notificationRepository;
  StreamSubscription<String>? _messagesSubscription;
  StreamSubscription<ConnectionState>? _connectionStateSubscription;

  void _onNotificationStarted(
    NotificationStarted event,
    Emitter<NotificationState> emit,
  ) {
    _messagesSubscription =
        _notificationRepository.notifications().listen((message) {
      add(_NotificationMessageChanged(message));
    });

    _connectionStateSubscription =
        _notificationRepository.connection().listen((status) {
      add(_NotificationConnectionStatusChanged(status));
    });
  }

  Future<void> _onNotificationMessageChanged(
    _NotificationMessageChanged event,
    Emitter<NotificationState> emit,
  ) async {
    logI('Notification: ${event.message}');
    emit(
      state.copyWith(
        message: event.message,
        status: ConnectionStatus.connected,
      ),
    );
    await Future<void>.delayed(const Duration(seconds: 2))
        .whenComplete(() => emit(state.copyWith(message: '')));
  }

  void _onNotificationConnectionStatusChanged(
    _NotificationConnectionStatusChanged event,
    Emitter<NotificationState> emit,
  ) {
    emit(state.copyWith(status: event.state.toStatus()));
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    _connectionStateSubscription?.cancel();
    return super.close();
  }
}
