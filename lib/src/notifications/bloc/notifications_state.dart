// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'notifications_bloc.dart';

class NotificationsState extends Equatable {
  const NotificationsState._({required this.message});

  const NotificationsState.initial() : this._(message: '');

  final String message;

  @override
  List<Object> get props => [message];

  NotificationsState copyWith({String? message}) {
    return NotificationsState._(message: message ?? this.message);
  }
}
