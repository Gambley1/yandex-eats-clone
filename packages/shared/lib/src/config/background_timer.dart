// ignore_for_file: avoid_catching_errors

import 'dart:async';
import 'dart:math';

import 'package:yandex_food_api/client.dart';

/// {@template timers_storage}
/// Timers storage for the authentication client.
/// {@endtemplate}
abstract class TimersStorage {
  /// Returns the current running timers.
  Future<List<TimerData>> readTimers();

  /// Returns the current running timers.
  Future<TimerData?> readTimer(String id);

  /// Saves the current timer.
  Future<void> saveTimers(List<TimerData> timers);
}

/// {@template in_memory_timers_storage}
/// In-memory timers storage for the background timer.
/// {@endtemplate}
class InMemoryTimersStorage implements TimersStorage {
  List<TimerData> _timers = <TimerData>[];

  @override
  Future<List<TimerData>> readTimers() async => _timers;

  @override
  Future<TimerData?> readTimer(String id) async =>
      _timers.firstWhere((timer) => timer.id == id);

  @override
  Future<void> saveTimers(List<TimerData> timers) async => _timers = timers;
}

/// Timer data class
class TimerData {
  /// {@macro timer_data}
  TimerData(
    this.id,
    this.count, {
    this.timer,
  });

  /// Associated id for timer data
  final String id;

  /// Associated count value
  int count;

  /// Associated timer
  Timer? timer;
}

/// {@template background_timer_cubit}
/// Background Timer that keep timer at the background.
/// {@endtemplate}
class BackgroundTimer {
  /// {@macro background_timer}
  const BackgroundTimer({
    required TimersStorage timersStorage,
    required YandexFoodApiClient apiClient,
  })  : _timersStorage = timersStorage,
        _apiClient = apiClient;

  final TimersStorage _timersStorage;
  final YandexFoodApiClient _apiClient;

  /// Start timer
  Future<void> startTimer({required String orderId}) async {
    final id = uuid.v4();
    try {
      await _timersStorage.readTimer(id);
      return;
    } on StateError {
      const duration = Duration(seconds: 1);
      Timer? timer;

      timer = Timer.periodic(duration, (Timer t) async {
        final currentTimers = await _timersStorage.readTimers();
        final index = currentTimers.indexWhere((timer) => timer.id == id);

        if (index != -1) {
          final updatedTimer = currentTimers[index];
          updatedTimer.count++;

          if (updatedTimer.count >= 30) {
            updatedTimer.timer?.cancel();
            currentTimers.removeAt(index);

            final statuses = [OrderStatus.completed, OrderStatus.canceled];

            final randomIndex = Random().nextInt(statuses.length);

            final status = statuses[randomIndex].name;
            await _apiClient.updateOrder(id: orderId, status: status);
          }
        } else {
          timer?.cancel();
        }
      });
      final newTimer = TimerData(id, 0)..timer = timer;
      final updatedTimers = [...await _timersStorage.readTimers(), newTimer];
      await _timersStorage.saveTimers(updatedTimers);
    }
  }

  /// Stop timer
  Future<void> stopTimer(String id) async {
    final currentTimers = [...await _timersStorage.readTimers()];
    final index = currentTimers.indexWhere((timer) => timer.id == id);

    if (index != -1) {
      currentTimers[index].timer?.cancel();
      currentTimers.removeAt(index);
      await _timersStorage.saveTimers(currentTimers);
    }
  }
}
