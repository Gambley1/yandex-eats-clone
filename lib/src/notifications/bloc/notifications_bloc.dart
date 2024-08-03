import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc({
    required UserRepository userRepository,
    required NotificationsRepository notificationRepository,
  })  : _userRepository = userRepository,
        _notificationRepository = notificationRepository,
        super(const NotificationsState.initial()) {
    on<NotificationMessageChanged>(_onNotificationMessageChanged);

    _notificationsSubscription =
        _notificationRepository.notifications().listen(_onNotificationsChanged);
    _userNotificationsSubscription = _notificationRepository
        .userNotifications()
        .listen(_onUserNotificationsChanged);
  }

  final UserRepository _userRepository;
  final NotificationsRepository _notificationRepository;

  Future<void> _onNotificationsChanged(String message) async {
    add(NotificationMessageChanged(message));
  }

  Future<void> _onUserNotificationsChanged(String jsonMessage) async {
    final message = jsonDecode(jsonMessage) as List;
    final userId = message[1] as String;
    final currentUserId = (await _userRepository.user.first).id;
    if (userId != currentUserId) return;

    final body = message[0] as String;
    add(NotificationMessageChanged(body));
  }

  StreamSubscription<String>? _notificationsSubscription;
  StreamSubscription<String>? _userNotificationsSubscription;

  Future<void> _onNotificationMessageChanged(
    NotificationMessageChanged event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(state.copyWith(message: event.message));
    await _notificationRepository.showNotification(body: event.message);
    await Future<void>.delayed(const Duration(seconds: 2))
        .whenComplete(() => emit(state.copyWith(message: '')));
  }

  @override
  Future<void> close() {
    _notificationRepository
      ..closeWsNotifications()
      ..closeWsUserNotifications();
    _notificationsSubscription?.cancel();
    _userNotificationsSubscription?.cancel();
    return super.close();
  }
}
